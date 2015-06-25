//
//  TKRendition+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRendition.h"
#import <CoreUI/CUIThemeRendition.h>
#import <Cocoa/Cocoa.h>
#import <CoreUI/CUIMutableCommonAssetStorage.h>
#import <CoreUI/CSIGenerator.h>

@interface TKRendition ()
@property (strong) CUIThemeRendition *rendition;
@property (strong) CUIRenditionKey *renditionKey;
@property (strong) NSImage *_previewImage;

@property (nonatomic, readwrite, weak) TKElement *element;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, getter=isAssetPack) BOOL assetPack;

// Create Color Renditions
+ (instancetype)renditionWithColorKey:(struct colorkey)key definition:(struct colordef)definition;
- (instancetype)initWithColorKey:(struct colorkey)key definition:(struct colordef)definition;

// Create all other renditions, in order of called
+ (instancetype)renditionWithCSIData:(NSData *)csiData renditionKey:(CUIRenditionKey *)key;
+ (instancetype)renditionWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key;
+ (Class)renditionClassForCoreUIRendition:(CUIThemeRendition *)rendition;
- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key;

- (CUIMutableCommonAssetStorage *)cuiAssetStorage;
- (NSData *)keyData;
- (CSIGenerator *)generator;

- (void)commitToStorage;
- (void)removeFromStorage;

@end
