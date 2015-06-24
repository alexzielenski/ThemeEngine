//
//  TKModelObject.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKModelObject.h"

@interface TKModelObject ()
@property (nonatomic, readwrite, assign) NSUInteger changeCount;
@property (nonatomic, readwrite, assign) NSUInteger lastChangeCount;
- (void)setUpUndo;
- (void)evaluateProperties:(NSDictionary<NSString *, NSString *> *)properties
                 forObject:(id)object
                unregister:(BOOL)unregister
                collection:(BOOL)collection;
@end

static const void *TKModelObjectContext = &TKModelObjectContext;
static const void *TKModelObjectCollectionContext = &TKModelObjectCollectionContext;


@implementation TKModelObject
@dynamic dirty;

- (id)init {
    if ((self = [super init])) {
        [self setUpUndo];
    }
    
    return self;
}

- (void)setUpUndo {
    if (![self wantsUndoHandling])
        return;
    
    if (![self wantsUndoManager])
        self.undoManager = [[NSUndoManager alloc] init];
    
    NSDictionary *properties = [self.class undoProperties];
    [self evaluateProperties:properties forObject:self unregister:NO collection:NO];
    
    properties = [self.class collectionProperties];
    for (NSString *value in properties.allKeys) {
        [self addObserver:self
               forKeyPath:value
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                  context:&TKModelObjectCollectionContext];
    }
}

- (void)evaluateProperties:(NSDictionary<NSString *, NSString *> *)properties
                 forObject:(id)object
                unregister:(BOOL)unregister
                collection:(BOOL)collection {
    
    void *context = &TKModelObjectContext;
    
    if (!unregister) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
        if (collection)
            options |= NSKeyValueObservingOptionInitial;
        
        for (NSString *value in properties.allKeys) {
            [object addObserver:self
                     forKeyPath:value
                        options:options
                        context:context];
            if (collection) {
                // Set the properties for a key->action map associated with the object
                // don't bump the retain count because the dictionary is static
                objc_setAssociatedObject(object,
                                         context,
                                         properties,
                                         OBJC_ASSOCIATION_ASSIGN);
            }
        }
    } else {
        for (NSString *value in properties.allKeys) {
            [object removeObserver:self
                        forKeyPath:value
                           context:context];
        }
    }
}

- (void)dealloc {
    NSDictionary *properties = [self.class undoProperties];
    [self evaluateProperties:properties forObject:self unregister:YES collection:NO];
    
    properties = [self.class collectionProperties];
    for (NSString *key in properties) {
        NSArray *registration = properties[key];
        NSDictionary *props = registration.lastObject;
        
        id collection = [self valueForKeyPath:key];
        
        for (id object in collection) {
            [self evaluateProperties:props
                           forObject:object
                          unregister:YES
                          collection:YES];
        }
        
        [self removeObserver:self
                  forKeyPath:key
                     context:&TKModelObjectCollectionContext];
    }
}

- (BOOL)wantsUndoManager {
    return NO;
}

- (BOOL)wantsUndoHandling {
    return YES;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    // Get old and new values
    id value = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    
    // KVO injects an NSNull rather than nil in the dictionary
    if ([value isKindOfClass:[NSNull class]])
        value = nil;
    if ([newValue isKindOfClass:[NSNull class]])
        newValue = nil;
    
    
    if (context == &TKModelObjectContext) {
        if (!self.undoManager) {
            return;
        }
        // Don't trigger a registration if there was no change
        if (newValue == value)
            return;
        
        if ([value respondsToSelector:@selector(isEqual:)]) {
            if ([value isEqual:newValue])
                return;
        }
        
        // Update our dirty status accordingly
        if (self.undoManager.isUndoing) {
            [self updateChangeCount:NSChangeUndone];
        } else if (self.undoManager.isRedoing) {
            [self updateChangeCount:NSChangeRedone];
        } else {
            [self updateChangeCount:NSChangeDone];
        }
        
        // Register undo
        [[self.undoManager prepareWithInvocationTarget:object] setValue:value
                                                             forKeyPath:keyPath];
        
        // Register the action name
        if (!self.undoManager.isUndoing) {
            if (object == self)
                [self.undoManager setActionName:[self.class undoProperties][keyPath]];
            else {
                // Context for collection types are the dictionary
                // for their associated keypath-Action registration
                NSDictionary *strs = objc_getAssociatedObject(object, context);
                [self.undoManager setActionName:strs[keyPath]];
            }
        }
        
    } else if (context == &TKModelObjectCollectionContext) {
        NSArray *registration = [self.class collectionProperties][keyPath];
        NSIndexSet *indices = change[NSKeyValueChangeIndexesKey];
        
        NSArray *newValues = (NSArray *)newValue;
        NSArray *oldValues = (NSArray *)value;
        
        // We support undo operations for collections adding/removing/setting
        if (self.undoManager) {
            // Don't trigger a registration if there was no change
            if (newValue != value) {
                if (!([value respondsToSelector:@selector(isEqual:)] &&
                      [value isEqual:newValue])) {
                    
                    // Update our dirty status accordingly
                    if (self.undoManager.isUndoing) {
                        [self updateChangeCount:NSChangeUndone];
                    } else if (self.undoManager.isRedoing) {
                        [self updateChangeCount:NSChangeRedone];
                    } else {
                        [self updateChangeCount:NSChangeDone];
                    }
                    
                    
                    TKCollectionType type = [registration[1] unsignedIntegerValue];
                    NSKeyValueChange kind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
                    NSString *verb = nil;
                    
                    switch (kind) {
                        case NSKeyValueChangeSetting: {
                            [[self.undoManager prepareWithInvocationTarget:object] setValue:value
                                                                                 forKeyPath:keyPath];
                            verb = @"Change";
                            break;
                        }
                        case NSKeyValueChangeInsertion: {
                            [self.undoManager registerUndoWithTarget:object handler:^(id  __nonnull target) {
                                switch (type) {
                                    case TKCollectionTypeArray:
                                        [[target mutableArrayValueForKeyPath:keyPath] removeObjectsAtIndexes:indices];
                                        break;
                                    case TKCollectionTypeSet:
                                        [[target mutableSetValueForKeyPath:keyPath] minusSet:[NSSet setWithArray:newValues]];
                                        break;
                                    case TKCollectionTypeOrderedSet:
                                        [[target mutableOrderedSetValueForKeyPath:keyPath] removeObjectsAtIndexes:indices];
                                        break;
                                }
                            }];
                            
                            verb = @"Add";
                            break;
                        }
                        case NSKeyValueChangeRemoval: {
                            [self.undoManager registerUndoWithTarget:object handler:^(id  __nonnull target) {
                                switch (type) {
                                    case TKCollectionTypeArray:
                                        [[target mutableArrayValueForKeyPath:keyPath] insertObjects:oldValues
                                                                                          atIndexes:indices];
                                        break;
                                    case TKCollectionTypeSet:
                                        [[target mutableSetValueForKeyPath:keyPath] unionSet:[NSSet setWithArray:oldValues]];
                                        break;
                                    case TKCollectionTypeOrderedSet:
                                        [[target mutableOrderedSetValueForKeyPath:keyPath] insertObjects:oldValues
                                                                                               atIndexes:indices];
                                        break;
                                }
                            }];
                            verb = @"Remove";
                            break;
                        }
                        case NSKeyValueChangeReplacement: {
                            [self.undoManager registerUndoWithTarget:object handler:^(id  __nonnull target) {
                                switch (type) {
                                    case TKCollectionTypeArray:
                                        [[target mutableArrayValueForKeyPath:keyPath] replaceObjectsAtIndexes:indices
                                                                                                  withObjects:oldValues];
                                        break;
                                    case TKCollectionTypeSet:
                                        [[target mutableSetValueForKeyPath:keyPath] minusSet:[NSSet setWithArray:newValues]];
                                        [[target mutableSetValueForKeyPath:keyPath] unionSet:[NSSet setWithArray:oldValues]];
                                        break;
                                    case TKCollectionTypeOrderedSet:
                                        [[target mutableOrderedSetValueForKeyPath:keyPath] replaceObjectsAtIndexes:indices
                                                                                                       withObjects:oldValues];
                                        break;
                                }
                            }];
                            
                            verb = @"Change";
                            break;
                        }
                    }
                    
                    verb = [verb stringByAppendingFormat:@" %@", registration[0]];
                    if (!self.undoManager.isUndoing) {
                        [self.undoManager setActionName:verb];
                    }
                    
                } // value isEuql
            } // value !=
        } // self.undo
        
        // After registering the adding/removing, etc. we have to observe each
        NSDictionary *properties = registration.lastObject;
        
        for (id object in oldValues) {
            [self evaluateProperties:properties
                           forObject:object
                          unregister:YES
                          collection:YES];
        }
        
        for (id object in newValues) {
            [self evaluateProperties:properties
                           forObject:object
                          unregister:NO
                          collection:YES];
        }
        
        
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

+ (NSDictionary *)undoProperties {
    static NSDictionary *TKDefaultProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKDefaultProperties = @{};
    });
    
    return TKDefaultProperties;
}

+ (NSDictionary *)collectionProperties {
    static NSDictionary *TKDefaultProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKDefaultProperties = @{};
    });
    
    return TKDefaultProperties;
}

- (BOOL)isDirty {
    return self.lastChangeCount != self.changeCount;
}

- (void)updateChangeCount:(NSDocumentChangeType)change {
    switch (change) {
        case NSChangeRedone:
        case NSChangeDone:
            self.changeCount++;
            break;
        case NSChangeUndone:
            self.changeCount = MAX(self.changeCount - 1, 0);
            break;
        case NSChangeReadOtherContents:
            self.lastChangeCount = self.changeCount = 0;
            break;
        case NSChangeAutosaved:
        case NSChangeCleared:
            self.lastChangeCount = self.changeCount;
            break;
        default: {
            break;
        }
    }
}
+ (NSSet *)keyPathsForValuesAffectingDirty {
    return [NSSet setWithObjects:TKKey(changeCount), TKKey(lastChangeCount), nil];
}

@end
