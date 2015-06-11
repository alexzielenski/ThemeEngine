//
//  CFTElement.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTElement.h"
#import "CFTElementStore.h"

@interface CFTElement ()
@property (readwrite, copy) NSString *name;
@property (readwrite, strong) NSMutableSet *assets;
@end

@implementation CFTElement

+ (instancetype)elementWithAssets:(NSSet *)assets name:(NSString *)name {
    return [[self alloc] initWithAssets:assets name:name];
}

- (instancetype)initWithAssets:(NSSet *)assets name:(NSString *)name {
    if ((self = [self init])) {
        self.name = name;
        [self addAssets:assets];
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.assets = [NSMutableSet set];
    }
    
    return self;
}

- (void)addAssets:(NSSet *)assets {
    // In future versions of Yosemite, assets no longer used unique names
    // so this line broke it
//    assets = [assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (name IN %@)", [self.assets valueForKey:@"name"]]];
//    if (assets.count == 0)
//        return;
//    }

    [[self.undoManager prepareWithInvocationTarget:self.store] removeAssets:assets];
    if (!self.undoManager.isUndoing) {
        [self.undoManager setActionName:@"Add Assets"];
    }
    
    [self willChangeValueForKey:@"assets"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:assets];
    [assets makeObjectsPerformSelector:@selector(setUndoManager:) withObject:self.undoManager];
    if (self.undoManager.isUndoRegistrationEnabled) {
        [assets setValue:@1 forKeyPath:@"changeCount"];
    }
    [assets makeObjectsPerformSelector:NSSelectorFromString(@"setElement:") withObject:self];
    [self.assets unionSet:assets];
    [self didChangeValueForKey:@"assets"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:assets];
}

- (void)addAsset:(CFTAsset *)asset {
    [self addAssets:[NSSet setWithObject:asset]];
}

- (void)removeAssets:(NSSet *)assets {
    assets = [assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"element == %@", self]];
    
    [[self.undoManager prepareWithInvocationTarget:self.store] addAssets:assets];
    if (!self.undoManager.isUndoing) {
        [self.undoManager setActionName:@"Remove Assets"];
    }
    
    [assets makeObjectsPerformSelector:NSSelectorFromString(@"setElement:") withObject:nil];
    [self willChangeValueForKey:@"assets"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:assets];
    [assets makeObjectsPerformSelector:@selector(removeFromStorage) withObject:nil];
    [self.assets minusSet:assets];
    [self didChangeValueForKey:@"assets"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:assets];
}

- (void)removeAsset:(CFTAsset *)asset {
    if (asset.element != self)
        return;
    
    [self removeAssets:[NSSet setWithObject:asset]];
}

- (NSSet *)assetsWithIdiom:(CoreThemeIdiom)idiom {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeIdiom == %d", idiom]];
}

- (NSSet *)assetsWithScale:(double)scale {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"scale == %f", scale]];
}

- (NSSet *)assetsWithLayer:(CoreThemeLayer)layer {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeLayer == %d", layer]];
}

- (NSSet *)assetsWithPresentationState:(CoreThemePresentationState)state {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themePresentationState == %d", state]];
}

- (NSSet *)assetsWithState:(CoreThemeState)state {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeState == %d", state]];
}

- (NSSet *)assetsWithValue:(CoreThemeValue)value {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeValue == %d", value]];
}

- (NSSet *)assetsWithDirection:(CoreThemeDirection)direction {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeDirection == %d", direction]];
}

- (NSSet *)assetsWithSize:(CoreThemeSize)size {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeSize == %d", size]];
}

- (NSSet *)assetsWithType:(CoreThemeType)type {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"type == %d", type]];
}

- (NSSet *)assetsWithLayout:(CoreThemeLayout)layout {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"layout == %d", layout]];
}

@end
