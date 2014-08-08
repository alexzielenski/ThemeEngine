//
//  CFElementStore.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFElement.h"
#import "CUIMutableCommonAssetStorage.h"
#import "CUIMutableStructuredThemeStore.h"

@interface CFElementStore : NSObject
@property (readonly, strong) CUIStructuredThemeStore *themeStore;
@property (readonly, strong) CUICommonAssetStorage *assetStorage;
@property (readonly, copy) NSString *path;

+ (instancetype)storeWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path;

- (NSArray *)allElementNames;
- (CFElement *)elementWithName:(NSString *)name;

- (NSSet *)allAssets;

- (NSSet *)assetsWithIdiom:(CoreThemeIdiom)idiom;
- (NSSet *)assetsWithScale:(double)scale;
- (NSSet *)assetsWithLayer:(CoreThemeLayer)layer;
- (NSSet *)assetsWithPresentationState:(CoreThemePresentationState)state;
- (NSSet *)assetsWithState:(CoreThemeState)state;
- (NSSet *)assetsWithValue:(CoreThemeValue)value;
- (NSSet *)assetsWithDirection:(CoreThemeDirection)direction;
- (NSSet *)assetsWithSize:(CoreThemeSize)size;
- (NSSet *)assetsWithType:(CoreThemeType)type;
- (NSSet *)assetsWithLayout:(CoreThemeLayout)layout;

- (void)save;

@end

@interface CFElementStore (Properties)
@property (readonly, strong) NSSet *elements;
@end
