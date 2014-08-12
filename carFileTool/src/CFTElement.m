//
//  CFTElement.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTElement.h"

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
    for (CFTAsset *asset in assets)
        [self addAsset:asset];
}

- (void)addAsset:(CFTAsset *)asset {
    asset.undoManager = self.undoManager;
    [asset setValue:self forKey:@"element"];
    [self.assets addObject:asset];
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
