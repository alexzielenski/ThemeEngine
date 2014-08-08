//
//  CFTAsset.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CUIRenditionKey.h"
#import "CUIThemeRendition.h"
#import "CUIMutableStructuredThemeStore.h"
#import "CUIMutableCommonAssetStorage.h"
#import "CSIGenerator.h"
#import "CUIPSDGradient.h"

//!TODO: Implement undo manager
@class CFTElement;
@interface CFTAsset : NSObject
@property (readonly, weak) CFTElement *element;
@property (readonly, strong) NSArray *slices;
@property (readonly, strong) NSArray *metrics;
//!TODO: Make a wrapper class CFTThemeGradient
@property (readwrite, strong) CUIPSDGradient *gradient;
@property (readonly, strong) CUIRenditionKey *key;
@property (readwrite, assign) BOOL shouldRemove;

@property (readwrite, strong) CUIShapeEffectPreset *effectPreset;
@property (readwrite, strong) NSData *rawData;
@property (readwrite, strong) NSData *pdfData;
@property CGImageRef image;
@property (assign) CoreThemeLayout layout;
@property (assign) CoreThemeType type;
@property (assign) CGFloat scale;
@property (readonly, copy) NSString *name;
@property (copy) NSString *utiType;
@property (assign) CGBlendMode blendMode;
@property (assign) CGFloat opacity;
@property (assign) CFTEXIFOrientation exifOrientation;
@property (assign) short colorSpaceID;

@property (assign, getter=isExcludedFromContrastFilter) BOOL excludedFromContrastFilter;
@property (assign, getter=isRenditionFPO) BOOL renditionFPO;
@property (assign, getter=isVector) BOOL vector;
@property (assign, getter=isOpaque) BOOL opaque;

+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (void)commitToStorage:(CUIMutableCommonAssetStorage *)assetStorage;
- (BOOL)isDirty;

@end
