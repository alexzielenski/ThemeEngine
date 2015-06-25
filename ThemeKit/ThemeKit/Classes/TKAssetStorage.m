//
//  TKAssetStorage.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKAssetStorage.h"
#import "TKAssetStorage+Private.h"

#import <CoreUI/CUIMutableCommonAssetStorage.h>
#import <CoreUI/CUIThemeRendition.h>

#import "TKRendition+Private.h"
#import "TKElement+Private.h"

extern NSInteger kCoreThemeStepperElementID;

@interface TKAssetStorage ()
@property (readwrite, strong) NSSet<TKElement *> *elements;
@property (readwrite, strong) NSMutableDictionary<NSString *, TKElement *> *elementNameMap;
// Maps keys to their renditions
@property (strong) NSCache *renditionCache;
- (TKElement *)elementWithName:(NSString *)name createIfNeeded:(BOOL)create;
@end

@implementation TKAssetStorage
@dynamic dirty, path;

+ (instancetype)assetStorageWithPath:(NSString *)path {
    return [[[self class] alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        self.storage = [[TKClass(CUICommonAssetStorage) alloc] initWithPath:path forWriting:NO];
        [self _beginEnumeration];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.undoManager = [[NSUndoManager alloc] init];
    }
    
    return self;
}

- (NSString *)path {
    return self.storage.path;
}

#pragma mark - Enumeration

- (void)_beginEnumeration {
    self.elementNameMap = [NSMutableDictionary<NSString *, TKElement *> dictionary];
    
    [self _enumerateAssets];
    [self _enumerateColors];
    [self _enumerateFonts];
}

- (void)_enumerateAssets {
    self.elements = [NSMutableSet<TKElement *> set];
    
    NSLog(@"Found %d renditions", self.storage.renditionCount);
    
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        [self.storage enumerateKeysAndObjectsUsingBlock:^(struct renditionkeytoken *keyList, NSData *csiData) {
            if (weakSelf) {
                TKRendition *rendition = [TKRendition renditionWithCSIData:csiData renditionKey:[CUIRenditionKey renditionKeyWithKeyList:keyList]];
                [weakSelf _addRendition: rendition];
            }
        }];
    }
}

- (void)_enumerateColors {
    if (!self.storage)
        return;
    
    BOMTreeRef color_tree = TKIvar(self.storage, BOMTreeRef, _colordb);
    if (color_tree == NULL)
        return;
    
    int num_colors = BOMTreeCount(color_tree);
    NSLog(@"Found %d colors", num_colors);
    if (num_colors == 0)
        return;
    
    BOMTreeIteratorRef iterator = BOMTreeIteratorNew(color_tree, 0, 0, 0);
    
    while (!BOMTreeIteratorIsAtEnd(iterator)) {
        struct colorkey *key = BOMTreeIteratorKey(iterator);
        struct colordef *value = BOMTreeIteratorValue(iterator);
        
        TKRendition *rendition = [TKRendition renditionWithColorKey:*key definition:*value];
        
        [self _addRendition:rendition];
        
        BOMTreeIteratorNext(iterator);
    }
    BOMTreeIteratorFree(iterator);
}

- (void)_enumerateFonts {
    if (!self.storage)
        return;
    
    BOMTreeRef font_tree = TKIvar(self.storage, BOMTreeRef, _fontdb);
    if (font_tree == NULL)
        return;
    
    int num_fonts = BOMTreeCount(font_tree);
    NSLog(@"Found %d fonts", num_fonts);
    
//    BOMTreeIteratorRef iterator = BOMTreeIteratorNew(font_tree, 0, 0, 0);
}

#pragma mark - Filtering

- (TKElement *)elementWithName:(NSString *)name {
    return [self elementWithName:name createIfNeeded:NO];
}

- (TKElement *)elementWithName:(NSString *)name createIfNeeded:(BOOL)create {
    if (!self.elementNameMap) {
        self.elementNameMap = [NSMutableDictionary dictionary];
    }
    
    TKElement *element = self.elementNameMap[name];
    
    if (!element) {
        element = [TKElement elementWithRenditions:nil
                                              name:name
                                           storage:self];
        
        self.elementNameMap[name] = element;
        [self addElements:[NSSet setWithObject:element]];
    }
    
    return element;
}

#pragma mark - Managing Renditions

- (CUIThemeRendition *)renditionWithKey:(struct renditionkeytoken *)keyList {
    if (!self.renditionCache) {
        self.renditionCache = [[NSCache alloc] init];
        self.renditionCache.countLimit = 30;
    }
    
    CUIRenditionKey *key = [CUIRenditionKey renditionKeyWithKeyList:keyList];
    CUIThemeRendition *rendition = [self.renditionCache objectForKey:key];
    if (!rendition) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"renditionKey == %@", key];
        NSSet *filtered = [self.allRenditions filteredSetUsingPredicate:filter];
        rendition = [filtered.anyObject valueForKey:TKKey(rendition)];
        if (!rendition) {
            return nil;
        }
        
        [self.renditionCache setObject:rendition forKey:key];
    }
    
    return rendition;
}

- (NSSet<TKRendition *> *)allRenditions {
    return [self valueForKeyPath:@"elements.@distinctUnionOfSets.renditions"];
}

- (void)addElements:(NSSet<TKElement *> *)objects {
    @synchronized(self) {
        [(NSMutableSet *)self.elements unionSet:objects];
    }
}

- (void)removeElements:(NSSet<TKElement *> *)objects {
    @synchronized(self) {
        [(NSMutableSet *)self.elements minusSet:objects];
    }
}

- (void)_addRendition:(TKRendition *)rendition {
    NSString *elementName = TKElementNameForRendition(rendition);
    TKElement *element = [self elementWithName:elementName createIfNeeded:YES];
    [element addRendition:rendition];
}

@end
