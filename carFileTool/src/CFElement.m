//
//  CFElement.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFElement.h"

@interface CFElement ()
@property (readwrite, copy) NSString *name;
@property (readwrite, strong) NSMutableSet *assets;
@end

@implementation CFElement

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
    for (CFAsset *asset in assets)
        [self addAsset:asset];
}

- (void)addAsset:(CFAsset *)asset {
    [self.assets addObject:asset];
}

- (NSSet *)assetsWithIdiom:(CoreThemeIdiom)idiom {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeIdiom == %d", idiom]];
}

- (NSSet *)assetsWithScale:(double)scale {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.scale == %f", scale]];
}

- (NSSet *)assetsWithLayer:(CoreThemeLayer)layer {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeLayer == %d", layer]];
}

- (NSSet *)assetsWithPresentationState:(CoreThemePresentationState)state {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themePresentationState == %d", state]];
}

- (NSSet *)assetsWithState:(CoreThemeState)state {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeState == %d", state]];
}

- (NSSet *)assetsWithValue:(CoreThemeValue)value {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeValue == %d", value]];
}

- (NSSet *)assetsWithDirection:(CoreThemeDirection)direction {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeDirection == %d", direction]];
}

- (NSSet *)assetsWithSize:(CoreThemeSize)size {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.key.themeSize == %d", size]];
}

- (NSSet *)assetsWithType:(CoreThemeType)type {
    return [self.assets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"rendition.type == %d", type]];
}

@end
