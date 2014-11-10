//
//  CFTElementStore.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTElementStore.h"
#import "ZKSwizzle.h"

@interface CFTElementStore ()
@property (readwrite, strong) CUIMutableCommonAssetStorage *assetStorage;
@property (readwrite, copy) NSString *path;
@property (readwrite, strong) NSMutableSet *elements;
@property (readwrite, strong) NSUndoManager *undoManager;
- (void)_enumerateAssets;
- (void)_enumerateColors;
- (void)_enumerateFonts;
- (void)_addElement:(CFTElement *)element;
- (void)_removeElement:(CFTElement *)element;
+ (NSString *)elementNameForAsset:(CFTAsset *)asset;
@end

@implementation CFTElementStore

+ (instancetype)storeWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [super init])) {
        self.undoManager = [[NSUndoManager alloc] init];
        [self.undoManager disableUndoRegistration];
        self.elements = [NSMutableSet set];
        self.path = path;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            self.assetStorage = [[objc_getClass("CUIMutableCommonAssetStorage") alloc] initWithPath:path forWriting:YES];

        } else {
            // creates a new file
            self.assetStorage = [[objc_getClass("CUIMutableCommonAssetStorage") alloc] initWithPath:path];
        }
        
        [self _enumerateAssets];
        [self _enumerateColors];
        [self _enumerateFonts];
        [self.undoManager enableUndoRegistration];
    }
    
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"CFTThemeStore must be given a path to init from in -initWithPath");
    return nil;
}

+ (NSString *)elementNameForAsset:(CFTAsset *)asset {
    if (asset.type == kCoreThemeTypeColor)
        return @"Colors";
    
    NSString *name = [[[asset.name stringByReplacingOccurrencesOfString:@"@2x" withString:@""]stringByReplacingOccurrencesOfString:@"@3x" withString:@""]stringByDeletingPathExtension];
    
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
    @autoreleasepool {
        [self.assetStorage enumerateKeysAndObjectsUsingBlock:^(struct _renditionkeytoken *key, NSData *csiData) {
            CFTAsset *asset = [CFTAsset assetWithRenditionCSIData:csiData forKey:key];
            [weakSelf addAsset:asset];
        }];
    }
}

- (void)_enumerateColors {
    BOMTreeRef treeRef = ZKHookIvar(self.assetStorage, BOMTreeRef, "_colordb");
    if (treeRef == NULL)
        return;
    
    int count = BOMTreeCount(treeRef);
    NSLog(@"Found %d colors", count);
    BOMTreeIteratorRef iterator = BOMTreeIteratorNew(treeRef, 0x0, 0x0, 0x0);
    do {
        size_t size = BOMTreeIteratorKeySize(iterator);
        void *bytes = BOMTreeIteratorKey(iterator);
        
        size_t valueSize = BOMTreeIteratorValueSize(iterator);
        void *valueBytes = BOMTreeIteratorValue(iterator);
        
        if (size > 0 && valueSize > 0) {
            CFTAsset *asset = [CFTAsset assetWithColorDef:*(struct _colordef *)valueBytes forKey:*(struct _colorkey *)bytes];
            [self addAsset: asset];
        }
        
        BOMTreeIteratorNext(iterator);
        
    } while (!BOMTreeIteratorIsAtEnd(iterator));
    BOMTreeIteratorFree(iterator);
}

- (void)_enumerateFonts {
    BOMTreeRef treeRef = ZKHookIvar(self.assetStorage, BOMTreeRef, "_fontdb");
    if (treeRef == NULL)
        return;
    
    int count = BOMTreeCount(treeRef);
    if (count > 0) {
        NSLog(@"Found %d fonts!", count);
    }
}
- (void)addAssets:(NSSet *)assets {
    for (CFTAsset *asset in assets) {
        NSString *elementName = [self.class elementNameForAsset:asset];
        CFTElement *element = [self elementWithName:elementName];
        if (!element) {
            element = [CFTElement elementWithAssets:nil name:elementName];
            [self _addElement:element];
        }
        
        [element addAsset:asset];
    }
}

- (void)addAsset:(CFTAsset *)asset {
    [self addAssets:[NSSet setWithObject:asset]];
}

- (void)removeAssets:(NSSet *)assets {
    for (CFTAsset *asset in assets) {
        CFTElement *element = asset.element;
        [element removeAsset:asset];
        if (element.assets.count == 0) {
            [self _removeElement:element];
        }
    }
}

- (void)removeAsset:(CFTAsset *)asset {
    [self removeAssets:[NSSet setWithObject:asset]];
}

- (void)_addElement:(CFTElement *)element {
    NSSet *set = [NSSet setWithObject:element];

    [self willChangeValueForKey:@"elements"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:set];
    element.store = self;
    element.undoManager = self.undoManager;
    [self.elements addObject:element];
    [self didChangeValueForKey:@"elements"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:set];
}

- (void)_removeElement:(CFTElement *)element {
    NSSet *set = [NSSet setWithObject:element];
    [self willChangeValueForKey:@"elements"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:set];
    [self.elements removeObject:element];
    [self didChangeValueForKey:@"elements"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:set];
}

- (NSArray *)allElementNames {
    return [self valueForKeyPath:@"elements.name"];
}

- (CFTElement *)elementWithName:(NSString *)name {
    NSSet *filtered = [self.elements filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    return filtered.anyObject;
}

- (BOOL)save {
    @autoreleasepool {
        NSSet *assets = self.allAssets;
        [assets makeObjectsPerformSelector:@selector(commitToStorage:) withObject:self.assetStorage];
        [self.assetStorage setRenditionCount:(unsigned int)self.allAssets.count];
        return [(CUIMutableCommonAssetStorage *)self.assetStorage writeToDiskAndCompact:YES];
    }
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
