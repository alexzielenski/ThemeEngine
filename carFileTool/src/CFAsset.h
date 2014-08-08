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
#import "CUIMutableCommonAssetStorage.h"
#import "CSIGenerator.h"
#import "CUIPSDGradient.h"

@class CFElement;
@interface CFAsset : NSObject
@property (readonly, weak) CFElement *element;
@property (readonly, assign) CGRect *slices;
@property (readonly, assign) NSUInteger nslices;
@property (readonly, assign) CUIMetrics *metrics;
@property (readonly, assign) NSUInteger nmetrics;
@property (readwrite, strong) CUIPSDGradient *gradient;
@property (readonly, strong) CUIRenditionKey *key;

@property (readwrite, strong) CUIShapeEffectPreset *effectPreset;
@property CGPDFDocumentRef pdfDocument;
@property CGImageRef image;

//!TODO: find what each value does and make an enum
@property (assign) CoreThemeLayout layout;
@property (assign) CoreThemeType type;
@property (assign) CGFloat scale;
@property (readonly, copy) NSString *name;
@property (copy) NSString *utiType;
//!TODO: find what each value does and make an enum. i think it is CGBlendMode
@property (assign) unsigned int blendMode;
@property (assign) CGFloat opacity;
@property (assign) CFEXIFOrientation exifOrientation;
@property (assign) unsigned long long colorSpaceID;

+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key;
- (void)commitToStorage:(CUIMutableCommonAssetStorage *)assetStorage  :(CUIStructuredThemeStore *)storage;

- (BOOL)isDirty;

@end
