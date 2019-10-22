//
//  TKMutableAssetStorage.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKMutableAssetStorage.h"
#import "TKAssetStorage+Private.h"
#import <CoreUI/CUIMutableCommonAssetStorage.h>
#import "TKRendition+Private.h"
#import "TKElement+Private.h"
#import "BOM.h"

// Are ThemeIdentifiers unique?
@implementation TKMutableAssetStorage

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        self.catalog = [[CUIMutableCatalog alloc] initWithURL:[NSURL fileURLWithPath: path] error:nil];

        self.storage = [[TKClass(CUIMutableCommonAssetStorage) alloc] initWithPath:path forWriting:YES];
        self.filePath = path;
        [self _beginEnumeration];
    }
    
    return self;
}

- (void)writeToDiskUpdatingChangeCounts:(BOOL)update {
    if (!self.storage) return;
    
    NSPredicate *dirtyPredicate = [NSPredicate predicateWithFormat:@"isDirty == YES"];
    NSSet *dirtyAssets = [self.allRenditions filteredSetUsingPredicate:dirtyPredicate];
    
    for (TKRendition *rendition in dirtyAssets) {
        [rendition commitToStorage];
        
        if (update)
            [rendition updateChangeCount:NSChangeCleared];
    }
    
    //TODO: Make this slow compression optional via UI
    
    // Changed to YES to fix size of files expanding over time
    // But should be NO because compact breaks future edits after saving
    [self.storage writeToDiskAndCompact:YES];
    
    // Must re-open storage after compacting
    self.storage = [[TKClass(CUIMutableCommonAssetStorage) alloc] initWithPath:self.filePath forWriting:YES];
}

- (void)addRendition:(TKRendition *)rendition {
    [self _addRendition:rendition];
    
    if (![rendition isKindOfClass:[TKClass(TKColorRendition) class]]) {
        [self.storage setRenditionCount:self.storage.renditionCount + 1];
    }
}

- (void)removeRendition:(TKRendition *)rendition {
    [rendition removeFromStorage];
    
    [rendition.element removeRendition:rendition];
    
    if (rendition.element.renditions.count == 0) {
        [self removeElements:[NSSet setWithObject:rendition.element]];
        //!TODO: Remove facet key
    }
    
    rendition.element = nil;
    
    if (![rendition isKindOfClass:[TKClass(TKColorRendition) class]]) {
        [self.storage setRenditionCount:self.storage.renditionCount - 1];
    }
}

@end
