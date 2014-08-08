//
//  CFAsset.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CUIRenditionKey.h"
#import "CUIThemeRendition.h"
#import "CUIMutableStructuredThemeStore.h"
#import "CSIGenerator.h"
#import "CUIPSDGradient.h"

@interface CFAsset : NSObject
@property (readonly, strong) CUIThemeRendition *rendition;
@property (readonly, assign) CGRect *slices;
@property (readonly, assign) NSUInteger nslices;
@property (readonly, assign) CUIMetrics *metrics;
@property (readonly, assign) NSUInteger nmetrics;
@property (readwrite, strong) CUIPSDGradient *gradient;
@property (readwrite, strong) NSBitmapImageRep *image;
+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (void)commitToStorage:(CUIMutableStructuredThemeStore *)storage;
@end
