//
//  CFTElement.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFTAsset.h"

@interface CFTElement : NSObject
@property (readonly, copy) NSString *name;
@property (strong) NSUndoManager *undoManager;

+ (instancetype)elementWithAssets:(NSSet *)assets name:(NSString *)name;
- (instancetype)initWithAssets:(NSSet *)assets name:(NSString *)name;

- (void)addAssets:(NSSet *)assets;
- (void)addAsset:(CFTAsset *)asset;

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

@end

@interface CFTElement (Properties)
@property (readonly, strong) NSSet *assets;
@end