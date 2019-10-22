//
//  TERenditionsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController.h"
#import <ThemeKit/TKRendition.h>
#import "TERenditionsController+Dragging.h"
#import "TEExportController.h"

static NSString *keyForGroupTag(NSInteger tag) {
    switch (tag) {
        case 0:
            return @"element.name";
        case 1:
            return @"type";
        case 2:
            return @"state";
        case 3:
            return @"scale";
        case 4:
            return @"size";
        case 5:
            return @"value";
        case 6:
            return @"layer";
        case 7:
            return @"idiom";
        default:
            return nil;
    }
}

static NSString *stringKeyForGroupTag(NSInteger tag) {
    switch (tag) {
        case 0:
            return @"element.name";
        case 1:
            return @"typeString";
        case 2:
            return @"stateString";
        case 3:
            return @"scaleString";
        case 4:
            return @"sizeString";
        case 5:
            return @"valueString";
        case 6:
            return @"layerString";
        case 7:
            return @"idiomString";
        default:
            return nil;
    }
}

@interface TERenditionsController ()
@property (strong) NSArray *groups;
@property (strong) NSArray *originalSortDescriptors;
@property (assign) BOOL groupCalculationDisabled;
@end

static const void *REEVALUATEGROUPS    = &REEVALUATEGROUPS;
static const void *PREVIEWIMAGECHANGED = &PREVIEWIMAGECHANGED;

@implementation TERenditionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentGroup = -1;
    
    self.renditionsArrayController
    .sortDescriptors = @[
                         [NSSortDescriptor sortDescriptorWithKey:@"element.name" ascending:NO
                                                        selector:@selector(caseInsensitiveCompare:)],
                         [NSSortDescriptor sortDescriptorWithKey:@"partID" ascending:YES],
                         [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES],
                         [NSSortDescriptor sortDescriptorWithKey:@"state" ascending:YES],
                         [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:YES]
                         ];
    self.originalSortDescriptors = self.renditionsArrayController.sortDescriptors;
    
    [self.renditionBrowser bind:NSContentBinding
                       toObject:self.renditionsArrayController
                    withKeyPath:@"arrangedObjects"
                        options:nil];
    self.renditionBrowser.canControlQuickLookPanel = YES;
    
    [self.inspectorController bind:@"representedObject"
                          toObject:self.renditionsArrayController
                       withKeyPath:@"selectedObjects"
                           options:nil];
    
    [self.renditionsArrayController addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(arrangedObjects))
                                        options:0
                                        context:&REEVALUATEGROUPS];
    [self addObserver:self
           forKeyPath:@"renditionsArrayController.arrangedObjects.previewImage"
              options:0
              context:&PREVIEWIMAGECHANGED];
    [self bootstrapDragAndDrop];
}

- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@"renditionsArrayController.arrangedObjects.previewImage"];
    [self.inspectorController unbind:@"representedObject"];
    [self.renditionsArrayController removeObserver:self forKeyPath:NSStringFromSelector(@selector(arrangedObjects)) context:&REEVALUATEGROUPS];
    [self.renditionBrowser unbind:NSContentBinding];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &REEVALUATEGROUPS) {
        if (!self.groupCalculationDisabled)
            self.currentGroup = self.currentGroup;
    } else if (context == &PREVIEWIMAGECHANGED) {
        [self.renditionBrowser reloadData];
        
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - Interface Actions

- (BOOL)validateMenuItem:(nonnull NSMenuItem *)menuItem {
    if (menuItem.action == @selector(receiveFromEditor:) ||
        menuItem.action == @selector(sendToEditor:)) {
        return self.renditionsArrayController.selectionIndexes.count > 0;
    }
    
    return YES;
}

- (IBAction)removeSelection:(id)sender {
    NSLog(@"remove rends");
}

- (IBAction)makeMicaPinkAgain:(id)sender {
    NSArray *selectedRenditions = [self.renditionsArrayController selectedObjects];
    for (TKRendition *rendition in selectedRenditions) {
        if ([rendition isKindOfClass:[TKRawDataRendition class]]) {
            TKRawDataRendition *rawDataRendition = (TKRawDataRendition *)rendition;
            if (rawDataRendition.rootLayer != nil) {
                CALayer *mine = rawDataRendition.copyRootLayer;
                mine.backgroundColor = [NSColor systemPinkColor].CGColor;
                for (CALayer *sublayer in mine.sublayers) {
                    sublayer.backgroundColor = mine.backgroundColor;
                }
                rawDataRendition.rootLayer = mine;
            }
        }
    }
    
}

- (IBAction)importMica:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[@"caar"];
    panel.allowsOtherFileTypes = NO;
    panel.allowsMultipleSelection = NO;
    if ([panel runModal] == NSModalResponseOK) {
        NSURL *selectedURL = panel.URL;
        
        NSData *caarData = [NSData dataWithContentsOfURL:selectedURL];
        NSDictionary *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:caarData];
        
        if ([unarchived isKindOfClass:[NSDictionary class]]) {
            if ([[unarchived objectForKey:@"rootLayer"] isKindOfClass:[CALayer class]]) {
                NSArray *selectedRenditions = [self.renditionsArrayController selectedObjects];
                
                for (TKRendition *rendition in selectedRenditions) {
                    if ([rendition isKindOfClass:[TKRawDataRendition class]]) {
                        TKRawDataRendition *rawDataRendition = (TKRawDataRendition *)rendition;
                        if ([rawDataRendition.utiType isEqualToString:TKUTITypeCoreAnimationArchive]) {
                            rawDataRendition.rawData = caarData;
                        }
                    }
                }

            }
        }
        
    }
}

- (IBAction)receiveFromEditor:(id)sender {
    [[TEExportController sharedExportController] importRenditions:[self.renditionsArrayController selectedObjects]];
}

- (IBAction)sendToEditor:(id)sender {
    [[TEExportController sharedExportController] exportRenditions:[self.renditionsArrayController selectedObjects]];
}


- (void)setCurrentGroup:(NSInteger)currentGroup {
    // Use this so we can observe arranged objects and regroup everytime it changes
    // without triggering an infinite loop
    _currentGroup = currentGroup;
    
    NSString *key = keyForGroupTag(currentGroup);
    if (key) {
        self.groupCalculationDisabled = YES;
        self.renditionsArrayController.sortDescriptors =
            @[ [NSSortDescriptor sortDescriptorWithKey:key ascending:YES] ];
        self.groupCalculationDisabled = NO;
        
        // Come back after it's been resorted
        // sort primarily by the group selected
        NSMutableArray *groups = [NSMutableArray array];
        
        NSArray *objects = self.renditionsArrayController.arrangedObjects;
        if (objects.count == 0) {
            goto reset;
        }
        
        
        // Loop through every element
        // Test to see if this current item is different from the last unique one we found
        // if so, create the group
        // Also, make sure to include a terminating nil for the last group
        id lastObject = [objects[0] valueForKeyPath:key];
        NSUInteger lastIdx = 0;
        for (NSUInteger x = 0; x <= objects.count; x++) {
            id value = x < objects.count ? [objects[x] valueForKeyPath:key] : nil;

            if (![value isEqualTo:lastObject]) {
                // new unique object, commit the last one to the array
                [groups addObject:@{
                                    IKImageBrowserGroupStyleKey: @(IKGroupDisclosureStyle),
                                    IKImageBrowserGroupTitleKey: [objects[x - 1] valueForKeyPath:stringKeyForGroupTag(currentGroup)],
                                    IKImageBrowserGroupRangeKey: [NSValue valueWithRange:NSMakeRange(lastIdx, x - lastIdx)],
                                    }];
                lastObject = value;
                lastIdx = x;
            }
        }
        
        self.groups = groups;
        
        [self.renditionBrowser reloadData];
    } else {
    reset:
        self.groups = nil;
        self.groupCalculationDisabled = YES;
        self.renditionsArrayController.sortDescriptors = self.originalSortDescriptors;
        self.groupCalculationDisabled = NO;
        return;
    }
}

- (IBAction)zoomAnchorPressed:(NSButton *)sender {
    if (sender.tag == 0) {
        self.renditionBrowser.zoomValue = self.zoomSlider.minValue;
    } else {
        self.renditionBrowser.zoomValue = self.zoomSlider.maxValue;
    }
}

static NSString *sanitizeToken(NSString *token) {
    if ([token hasPrefix:@"\""] && [token hasSuffix:@"\""]) {
        // strip quotes
        return [token substringWithRange:NSMakeRange(1, token.length - 2)];
    }
    return [token stringByAppendingString:@"*"];
}

// Search parser
// supports any of the keywords specified in TKRendition+Filtering
// format, space separated terms
// use a ! prefix to negate
// minimum query length: 2
// to search a specific property use the format: "idiom:universal" with no spaces
// sorround any token with quotes for absolute matching (no fuzzy matching)
- (IBAction)searchRenditions:(NSSearchField *)sender {
    if (sender.stringValue.length < 2) {
        self.renditionsArrayController.filterPredicate = nil;
        return;
    }
    
    NSArray *tokens = [sender.stringValue componentsSeparatedByString:@" "];
    NSMutableArray *predicates = [NSMutableArray array];
    for (NSString *item in tokens) {
        NSPredicate *predicate = nil;
        
        NSString *token = item;
        
        // See if this is a negation
        BOOL negate = [token hasPrefix:@"!"];
        if (negate)
            token = [token substringFromIndex:1];
        
        // See if its a specific search with a colon
        
        NSArray *parameters = [token componentsSeparatedByString:@":"];

        // If its just a keyword, search every keyword
        if (parameters.count == 1) {
            token = sanitizeToken(token);
            if (token.length == 0)
                continue;
            
            predicate = [NSPredicate predicateWithFormat:
                         @"ANY keywords LIKE[cd] %@", token];
            
        // otherwise search only the specific keyword
        } else if (parameters.count == 2) {
            NSString *key = parameters[0];
            token = sanitizeToken(parameters[1]);
            if (token.length == 0)
                continue;
            
            // the user might have typed name, or type, check name and typeString keys
            // and make sure this is a real key
            NSString *keyString = [key stringByAppendingString:@"String"];
            if (![TKRendition instancesRespondToSelector:NSSelectorFromString(keyString)]) {
                if (![TKRendition instancesRespondToSelector:NSSelectorFromString(key)]) {
                    continue;
                }
            } else {
                key = keyString;
            }
            
            predicate = [NSPredicate predicateWithFormat:
                         @"%K LIKE[cd] %@", key, token];
            
        } else {
            continue;
        }
        
        if (negate) {
            predicate = [NSCompoundPredicate notPredicateWithSubpredicate:predicate];
        }
        
        [predicates addObject:predicate];
    }
    
    self.renditionsArrayController.filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

#pragma mark - IKImageBrowserViewDataSource

- (NSUInteger)numberOfGroupsInImageBrowser:(IKImageBrowserView *)aBrowser {
    return self.groups.count;
}

- (NSDictionary *)imageBrowser:(IKImageBrowserView *)aBrowser groupAtIndex:(NSUInteger)index {
    return self.groups[index];
}

@end
