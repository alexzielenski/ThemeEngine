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
        self.storage = [[TKClass(CUIMutableCommonAssetStorage) alloc] initWithPath:path forWriting:YES];
        [self _beginEnumeration];
    }
    
    return self;
}

- (void)writeToDiskUpdatingChangeCounts:(BOOL)update {
    NSPredicate *dirtyPredicate = [NSPredicate predicateWithFormat:@"isDirty == YES"];
    NSSet *dirtyAssets = [self.allRenditions filteredSetUsingPredicate:dirtyPredicate];
    
    for (TKRendition *rendition in dirtyAssets) {
        [rendition commitToStorage];
        
        if (update)
            [rendition updateChangeCount:NSChangeCleared];
    }

    [self.storage writeToDiskAndCompact:YES];
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
    rendition.element = nil;
    
    if (![rendition isKindOfClass:[TKClass(TKColorRendition) class]]) {
        [self.storage setRenditionCount:self.storage.renditionCount - 1];
    }
}

@end
