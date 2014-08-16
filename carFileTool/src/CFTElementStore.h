//
//  CFTElementStore.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFTElement.h"
#import "CUIMutableCommonAssetStorage.h"
#import "CUIMutableStructuredThemeStore.h"

@interface CFTElementStore : NSObject
@property (readonly, strong) CUIStructuredThemeStore *themeStore;
@property (readonly, strong) CUICommonAssetStorage *assetStorage;
@property (readonly, copy) NSString *path;
@property (readonly, strong) NSUndoManager *undoManager;

+ (instancetype)storeWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path;

- (void)addAsset:(CFTAsset *)asset;
- (void)removeAsset:(CFTAsset *)asset;

- (NSArray *)allElementNames;
- (CFTElement *)elementWithName:(NSString *)name;

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

- (NSSet *)elementsWithAssetsWithIdiom:(CoreThemeIdiom)idiom;
- (NSSet *)elementsWithAssetsWithScale:(double)scale;
- (NSSet *)elementsWithAssetsWithLayer:(CoreThemeLayer)layer;
- (NSSet *)elementsWithAssetsWithPresentationState:(CoreThemePresentationState)state;
- (NSSet *)elementsWithAssetsWithState:(CoreThemeState)state;
- (NSSet *)elementsWithAssetsWithValue:(CoreThemeValue)value;
- (NSSet *)elementsWithAssetsWithDirection:(CoreThemeDirection)direction;
- (NSSet *)elementsWithAssetsWithSize:(CoreThemeSize)size;
- (NSSet *)elementsWithAssetsWithType:(CoreThemeType)type;
- (NSSet *)elementsWithAssetsWithLayout:(CoreThemeLayout)layout;

- (BOOL)save;

@end

@interface CFTElementStore (Properties)
@property (readonly, strong) NSSet *elements;
@end
