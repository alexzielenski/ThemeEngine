//
//  CFElementStore.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFElementStore.h"
#import <objc/runtime.h>

@interface CFElementStore ()
@property (readwrite, strong) CUIMutableStructuredThemeStore *themeStore;
@property (readwrite, strong) CUIMutableCommonAssetStorage *assetStorage;
@property (readwrite, copy) NSString *path;
@property (readwrite, strong) NSMutableSet *elements;
- (void)_enumerateAssets;
- (void)_addAsset:(CFAsset *)asset;
- (void)_addElement:(CFElement *)element;
+ (NSString *)elementNameForAsset:(CFAsset *)asset;
@end

@implementation CFElementStore

+ (instancetype)storeWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        self.path = path;
        self.themeStore = [[objc_getClass("CUIMutableStructuredThemeStore") alloc] initWithPath:path];
        self.assetStorage = [[objc_getClass("CUIMutableCommonAssetStorage") alloc] initWithPath:path forWriting:YES];
        
        [self _enumerateAssets];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.elements = [NSMutableSet set];
    }
    
    return self;
}

+ (NSString *)elementNameForAsset:(CFAsset *)asset {
    NSString *name = [[asset.name stringByReplacingOccurrencesOfString:@"@2x" withString:@""] stringByDeletingPathExtension];
    // element is to be size agnostic
    name = [name stringByReplacingOccurrencesOfString:@"_Mini" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Regular" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Large" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Small" withString:@""];
    
    // element is direction agnostic. basically agnostic of all states/types except for the element
    name = [name stringByReplacingOccurrencesOfString:@"_Horizontal" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"_Vertical" withString:@""];
    
    return name;
}

- (void)_enumerateAssets {
    __weak CFElementStore *weakSelf = self;
    [self.assetStorage enumerateKeysAndObjectsUsingBlock:^(struct _renditionkeytoken *key, NSData *csiData) {
        CFAsset *asset = [CFAsset assetWithRenditionCSIData:csiData forKey:key];
        [weakSelf _addAsset:asset];
    }];
}

- (void)_addAsset:(CFAsset *)asset {
    NSString *elementName = [self.class elementNameForAsset:asset];
    CFElement *element = [self elementWithName:elementName];
    if (!element) {
        element = [CFElement elementWithAssets:nil name:elementName];
        [self _addElement:element];
    }
    
    [element addAsset:asset];
}

- (void)_addElement:(CFElement *)element {
    [self.elements addObject:element];
}

- (NSArray *)allElementNames {
    return [self valueForKeyPath:@"elements.name"];
}

- (CFElement *)elementWithName:(NSString *)name {
    NSSet *filtered = [self.elements filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    return filtered.anyObject;
}

- (void)save {
    NSSet *assets = [self valueForKeyPath:@"elements.@unionOfSets.assets"];
    for (CFAsset *asset in assets) {
        //!TODO: Commit only if needed
        [asset commitToStorage:(CUIMutableCommonAssetStorage *)self.assetStorage :self.themeStore];
    }
    
    [(CUIMutableCommonAssetStorage *)self.assetStorage writeToDiskAndCompact:YES];
}

@end
