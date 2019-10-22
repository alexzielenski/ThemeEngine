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

#import "TKVerifyTool.h"

extern NSInteger kCoreThemeStepperElementID;
NSString *const TKAssetStorageDidFinishLoadingNotification = @"TKAssetStorageDidFinishLoadingNotification";

@interface TKAssetStorage ()
@property (readwrite, strong) NSSet<TKElement *> *elements;
@property (readwrite, strong) NSMutableDictionary<NSString *, TKElement *> *elementNameMap;
@property (strong) NSOperationQueue *queue;
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
        self.catalog = [[CUICatalog alloc] initWithURL:[NSURL fileURLWithPath: path] error:nil];
        self.storage = [[TKClass(CUICommonAssetStorage) alloc] initWithPath:path forWriting:NO];
        self.filePath = path;
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
    if (!self.storage) {
        NSLog(@"This is not a valid car file");
        return;
    }
    self.elements = [NSMutableSet<TKElement *> set];

    NSMutableArray *allowed = [NSMutableArray array];
    const struct renditionkeyfmt *fmt = self.storage.keyFormat;
    for (int x = 0; x < fmt->num_identifiers; x++) {
        [allowed addObject:@(fmt->identifier_list[x])];
    }
    
    self.renditionKeyAttributes = allowed;
    self.elementNameMap = [NSMutableDictionary<NSString *, TKElement *> dictionary];
    
    self.queue = [[NSOperationQueue alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.queue addOperationWithBlock:^{
        [weakSelf _enumerateFacets];
        [weakSelf _enumerateAssets];
        [weakSelf _enumerateColors];
        [weakSelf _enumerateFonts];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TKAssetStorageDidFinishLoadingNotification object:self];
        });
    }];
    
}

- (void)_enumerateFacets {
    if (!self.storage)
        return;
    
    BOMTreeRef facet_tree = TKIvar(self.storage, BOMTreeRef, _facetKeysdb);
    if (facet_tree == NULL)
        return;
    
    int num_facets = BOMTreeCount(facet_tree);
    NSLog(@"Found %d facets", num_facets);
    if (num_facets == 0)
        return;
    
    BOMTreeIteratorRef iterator = BOMTreeIteratorNew(facet_tree, 0, 0, 0);
    
    while (!BOMTreeIteratorIsAtEnd(iterator)) {
        struct facet_key *key = BOMTreeIteratorKey(iterator);
        size_t key_size = BOMTreeIteratorKeySize(iterator);
        
        // We only care about the key
        NSData *keyData     = [NSData dataWithBytes:key length:key_size];
        NSString *facetName = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];

        // Create the element, even if it's empty
        (void)[self elementWithName:facetName createIfNeeded:YES];
        
        
        BOMTreeIteratorNext(iterator);
    }
    BOMTreeIteratorFree(iterator);
}

- (void)_enumerateAssets {
    NSLog(@"Found %d renditions", self.storage.renditionCount);
    
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        [self.storage enumerateKeysAndObjectsWithoutIgnoringUsingBlock:^(struct renditionkeytoken *keyList, NSData *csiData) {
            if (weakSelf != nil && csiData != nil) {
                CUIRenditionKey *key = [CUIRenditionKey renditionKeyWithKeyList:keyList];
                TKRendition *rendition = [TKRendition renditionWithCSIData:csiData renditionKey:key];

                if (!rendition.rendition) {
                    NSString *name;
                    CUIThemeRendition *cui = [TKVerifyTool fixedRenditionForCSIData:csiData
                                                                                key:key
                                                                            outName:&name];
                    
                    if (!cui) {
                        //!TODO Abort
                        NSLog(@"Failed to automatically fix rendition with name: %@", name);
                        return;
                    } else {
                        rendition = [TKRendition renditionWithCUIRendition:cui csiData:csiData key:key];
                    }
                }
                [weakSelf _addRendition: rendition];
            } else {
                // null csi data?
                NSLog(@"couldnt get rendition");
            }
        }];
        NSLog(@"pared %lu renditions", self.allRenditions.count);
    }
}

- (void)_enumerateColors {
    if (!self.storage)
        return;
    
    BOMStorageRef stor = BOMStorageOpen(self.filePath.UTF8String, false);
    BOMTreeRef color_tree = BOMTreeOpenWithName(stor, "COLORS", false);
//    if(bomTree == NULL)
//        return;
//
//
//    BOMTreeRef color_tree = TKIvar(self.storage, BOMTreeRef, _colordb);
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
        
        if (key != NULL && value != NULL) {
            TKRendition *rendition = [TKRendition renditionWithColorKey:*key definition:*value];
            
            [self _addRendition:rendition];
        }
        BOMTreeIteratorNext(iterator);
    }
    BOMTreeIteratorFree(iterator);
    BOMStorageFree(stor);
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
    if (!name)
        return nil;
    
    if (!self.elementNameMap) {
        self.elementNameMap = [NSMutableDictionary dictionary];
    }
    
    TKElement *element = self.elementNameMap[name];
    
    if (!element && create) {
        element = [TKElement elementWithRenditions:nil
                                              name:name
                                           storage:self];
        
        self.elementNameMap[name] = element;
        [self addElements:[NSSet setWithObject:element]];
    } else {

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
    NSString *elementName = TKElementNameForRendition(rendition, self);

    TKElement *element = [self elementWithName:elementName createIfNeeded:YES];
    if (element)
        [element addRendition:rendition];
    else {
        NSLog(@"Failed to add rendition: %@", rendition);
    }
}

@end
