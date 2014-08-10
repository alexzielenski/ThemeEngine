//
//  CFTElementStore.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTElementStore.h"
#import <objc/runtime.h>

typedef void *BOMTreeIteratorRef;
typedef void *BOMTreeRef;
extern BOMTreeIteratorRef BOMTreeIteratorNew(BOMTreeRef tree, int unk, int numberOfKeys, int unk3);
extern BOOL BOMTreeIteratorIsAtEnd(BOMTreeIteratorRef iterator);
extern void BOMTreeIteratorFree(BOMTreeIteratorRef iterator);
extern size_t BOMTreeIteratorKeySize(BOMTreeIteratorRef iterator);
extern void *BOMTreeIteratorKey(BOMTreeIteratorRef iterator);
extern size_t BOMTreeIteratorValueSize(BOMTreeIteratorRef iterator);
extern void *BOMTreeIteratorValue(BOMTreeIteratorRef iterator);
extern void BOMTreeIteratorNext(BOMTreeIteratorRef iterator);

extern BOOL BOMTreeCopyToTree(BOMTreeRef source, BOMTreeRef dest);


@interface CFTElementStore ()
@property (readwrite, strong) CUIMutableStructuredThemeStore *themeStore;
@property (readwrite, strong) CUIMutableCommonAssetStorage *assetStorage;
@property (readwrite, copy) NSString *path;
@property (readwrite, strong) NSMutableSet *elements;
- (void)_enumerateAssets;
- (void)_enumerateColors;
- (void)_addAsset:(CFTAsset *)asset;
- (void)_addElement:(CFTElement *)element;
+ (NSString *)elementNameForAsset:(CFTAsset *)asset;
@end

@implementation CFTElementStore

+ (instancetype)storeWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        self.path = path;
        self.themeStore = [[objc_getClass("CUIMutableStructuredThemeStore") alloc] initWithPath:path];
        self.assetStorage = [[objc_getClass("CUIMutableCommonAssetStorage") alloc] initWithPath:path forWriting:YES];
        
        [self _enumerateAssets];
        [self _enumerateColors];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.elements = [NSMutableSet set];
    }
    
    return self;
}

+ (NSString *)elementNameForAsset:(CFTAsset *)asset {
    if (asset.type == kCoreThemeTypeColor)
        return @"Colors";
    
    NSString *name = [[asset.name stringByReplacingOccurrencesOfString:@"@2x" withString:@""] stringByDeletingPathExtension];
    // element is to be size agnostic
    name = [name stringByReplacingOccurrencesOfString:@"_Mini" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Regular" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Large" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Small" withString:@""];
    
    // element is direction agnostic. basically agnostic of all states/types except for the element
    name = [name stringByReplacingOccurrencesOfString:@"_Horizontal" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Vertical" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_PointingUp" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_PointingDown" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_PointingLeft" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_PointingRight" withString:@""];
    
    name = [name stringByReplacingOccurrencesOfString:@"_Active" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Inactive" withString:@""];
    
    return name;
}

- (void)_enumerateAssets {
    __weak CFTElementStore *weakSelf = self;
    [self.assetStorage enumerateKeysAndObjectsUsingBlock:^(struct _renditionkeytoken *key, NSData *csiData) {
        CFTAsset *asset = [CFTAsset assetWithRenditionCSIData:csiData forKey:key];
        [weakSelf _addAsset:asset];
    }];
}

- (void)_enumerateColors {
    Ivar ivar = class_getInstanceVariable(object_getClass(self.assetStorage), "_colordb");
    BOMTreeRef treeRef = *(BOMTreeRef *)((__bridge void *)self.assetStorage + ivar_getOffset(ivar));
    BOMTreeIteratorRef iterator = BOMTreeIteratorNew(treeRef, 0x0, 0x0, 0x0);
    do {
        size_t size = BOMTreeIteratorKeySize(iterator);
        void *bytes = BOMTreeIteratorKey(iterator);
        
        size_t valueSize = BOMTreeIteratorValueSize(iterator);
        void *valueBytes = BOMTreeIteratorValue(iterator);
        
        if (size > 0 && valueSize > 0) {
            CFTAsset *asset = [CFTAsset assetWithColorDef:*(struct _colordef *)valueBytes forKey:*(struct _colorkey *)bytes];
            [self _addAsset: asset];
        }
        
        BOMTreeIteratorNext(iterator);
        
    } while (!BOMTreeIteratorIsAtEnd(iterator));
    BOMTreeIteratorFree(iterator);
}

- (void)_addAsset:(CFTAsset *)asset {
    NSString *elementName = [self.class elementNameForAsset:asset];
    CFTElement *element = [self elementWithName:elementName];
    if (!element) {
        element = [CFTElement elementWithAssets:nil name:elementName];
        [self _addElement:element];
    }
    
    [element addAsset:asset];
}

- (void)_addElement:(CFTElement *)element {
    [self.elements addObject:element];
}

- (NSArray *)allElementNames {
    return [self valueForKeyPath:@"elements.name"];
}

- (CFTElement *)elementWithName:(NSString *)name {
    NSSet *filtered = [self.elements filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    return filtered.anyObject;
}

- (void)save {
    NSSet *assets = self.allAssets;
    [assets makeObjectsPerformSelector:@selector(commitToStorage:) withObject:self.assetStorage];
    [(CUIMutableCommonAssetStorage *)self.assetStorage writeToDiskAndCompact:YES];
}

- (NSSet *)allAssets {
    return [self valueForKeyPath:@"elements.@distinctUnionOfSets.assets"];
}

#pragma mark - Filters


- (NSSet *)assetsWithIdiom:(CoreThemeIdiom)idiom {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeIdiom == %d", idiom]];
}

- (NSSet *)assetsWithScale:(double)scale {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"scale == %f", scale]];
}

- (NSSet *)assetsWithLayer:(CoreThemeLayer)layer {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeLayer == %d", layer]];
}

- (NSSet *)assetsWithPresentationState:(CoreThemePresentationState)state {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themePresentationState == %d", state]];
}

- (NSSet *)assetsWithState:(CoreThemeState)state {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeState == %d", state]];
}

- (NSSet *)assetsWithValue:(CoreThemeValue)value {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeValue == %d", value]];
}

- (NSSet *)assetsWithDirection:(CoreThemeDirection)direction {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeDirection == %d", direction]];
}

- (NSSet *)assetsWithSize:(CoreThemeSize)size {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"key.themeSize == %d", size]];
}

- (NSSet *)assetsWithType:(CoreThemeType)type {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"type == %d", type]];
}

- (NSSet *)assetsWithLayout:(CoreThemeLayout)layout {
    return [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"layout == %d", layout]];
}

- (NSSet *)elementsWithAssetsWithIdiom:(CoreThemeIdiom)idiom {
    return [[self assetsWithIdiom:idiom] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithScale:(double)scale {
    return [[self assetsWithScale:scale] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithLayer:(CoreThemeLayer)layer {
    return [[self assetsWithLayer:layer] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithPresentationState:(CoreThemePresentationState)state {
    return [[self assetsWithPresentationState:state] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithState:(CoreThemeState)state {
    return [[self assetsWithState:state] valueForKeyPath:@"element"];
}
- (NSSet *)elementsWithAssetsWithValue:(CoreThemeValue)value {
    return [[self assetsWithValue:value] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithDirection:(CoreThemeDirection)direction {
    return [[self assetsWithDirection:direction] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithSize:(CoreThemeSize)size {
    return [[self assetsWithSize:size] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithType:(CoreThemeType)type {
    return [[self assetsWithType:type] valueForKeyPath:@"element"];
}

- (NSSet *)elementsWithAssetsWithLayout:(CoreThemeLayout)layout {
    return [[self assetsWithLayout:layout] valueForKeyPath:@"element"];
}

@end
