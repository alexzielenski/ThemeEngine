//
//  CFAsset.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFAsset.h"
#import "CSIBitmapWrapper.h"
#import "CUIThemeGradient.h"
#import "CUIPSDGradientEvaluator.h"
#import "CUIMutableCommonAssetStorage.h"
#import <objc/runtime.h>

#define kSLICES 1001
#define kMETRICS 1003
#define kFLAGS 1004
#define kUTI 1005
#define kEXIF 1006

/* CSI Format
 csi_header (in CUIThemeRendition.h)
 
 list of metadata in this format:
 
 0xE903 - 1001: Slice rects, First 4 bytes length, next num slices rects, next a list of the slice rects
 0xEB03 - 1003: Metrics – First 4 length, next 4 num metrics, next a list of metrics (struct of 3 CGSizes)
 0xEC03 - 1004: Composition - First 4 lenght, second is the blendmode, third is a float for opacity
 0xED03 - 1005: UTI Type, First 4 length, next 4 length of string, then the string
 0xEE03 - 1006: Image Metadata: First 4 length, next 4 EXIF orientation, (UTI type...?)
 
 unk
 
 GRADIENTS marked DARG with colors as RLOC, and opacity a TCPO format unknown
 0x4D4C4543 - MLEC: Start Image Data?
 */

static CUIPSDGradient *psdGradientFromThemeGradient(CUIThemeGradient *themeGradient, double angle, unsigned int style) {
    Ivar ivar = class_getInstanceVariable([themeGradient class], "gradientEvaluator");
    CUIPSDGradientEvaluator *evaluator = object_getIvar(themeGradient, ivar);
    return [[CUIPSDGradient alloc] initWithEvaluator:evaluator drawingAngle:angle gradientStyle:style];
}

static CUIPSDGradient *psdGradientFromRendition(CUIThemeRendition *rendition) {
    return psdGradientFromThemeGradient(rendition.gradient, rendition.gradientDrawingAngle, rendition.gradientStyle);
}


@interface CFAsset () {
    CGImageRef _image;
    CGPDFDocumentRef _pdfDocument;
}
@property (readwrite, strong) CUIThemeRendition *rendition;
@property (readwrite, assign) CGRect *slices;
@property (readwrite, assign) NSUInteger nslices;
@property (readwrite, assign) CUIMetrics *metrics;
@property (readwrite, assign) NSUInteger nmetrics;
@property (readwrite, copy) NSString *name;
@property (readwrite, strong) CUIRenditionKey *key;
- (void)_initializeSlicesFromCSIData:(NSData *)csiData;
- (void)_initializeMetricsFromCSIData:(NSData *)csiData;
@end

@implementation CFAsset
@dynamic image, pdfDocument;

+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    return [[self alloc] initWithRenditionCSIData:csiData forKey:key];
}

- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    if ((self = [self init])) {
        [csiData writeToFile:@"/Users/Alex/Desktop/data" atomically:NO];
        
        self.key = [CUIRenditionKey renditionKeyWithKeyList:key];
        self.rendition = [[objc_getClass("CUIThemeRendition") alloc] initWithCSIData:csiData forKey:key];
        self.gradient = psdGradientFromRendition(self.rendition);
        self.effectPreset = self.rendition.effectPreset;
        self.image = self.rendition.unslicedImage;
        self.pdfDocument = self.rendition.pdfDocument;
        self.gradientStyle = self.rendition.gradientStyle;
        self.gradientAngle = self.rendition.gradientDrawingAngle;
        self.layout = self.rendition.subtype;
        self.type = self.rendition.type;
        self.scale = self.rendition.scale;
        self.name = self.rendition.name;
        self.utiType = self.rendition.utiType;
        self.blendMode = self.rendition.blendMode;
        self.opacity = self.rendition.opacity;
        self.exifOrientation = self.rendition.exifOrientation;
        self.colorspaceID = self.rendition.colorSpaceID;
        
        [self _initializeSlicesFromCSIData:csiData];
        [self _initializeMetricsFromCSIData:csiData];
    }
    
    return self;
}

- (void)_initializeSlicesFromCSIData:(NSData *)csiData {
    unsigned int bytes = kSLICES;
    NSRange sliceLocation = [csiData rangeOfData:[NSData dataWithBytes:&bytes length:sizeof(bytes)]
                                         options:0
                                           range:NSMakeRange(0, csiData.length)];
    if (sliceLocation.location != NSNotFound) {
        unsigned int nslices = 0;
        [csiData getBytes:&nslices range:NSMakeRange(sliceLocation.location + sizeof(unsigned int) * 2, sizeof(nslices))];
        self.nslices = nslices;
        CGRect *slices = malloc(sizeof(CGRect) * self.nslices);
        for (int idx = 0; idx < nslices; idx++) {
            struct {
                unsigned int x;
                unsigned int y;
                unsigned int w;
                unsigned int h;
            } sliceInts;
            [csiData getBytes:&sliceInts range:NSMakeRange(sliceLocation.location + sizeof(sliceInts) * idx + sizeof(unsigned int) * 3, sizeof(sliceInts))];
            // order may be different
            slices[idx] = NSMakeRect(sliceInts.x, sliceInts.y, sliceInts.w, sliceInts.h);
        }
        
        self.slices = slices;
    }
}

- (void)_initializeMetricsFromCSIData:(NSData *)csiData {
    unsigned int bytes = kMETRICS;
    NSRange metricLocation = [csiData rangeOfData:[NSData dataWithBytes:&bytes length:sizeof(bytes)]
                                          options:0
                                            range:NSMakeRange(0, csiData.length)];
    if (metricLocation.location != NSNotFound) {
        unsigned int nmetrics = 0;
        [csiData getBytes:&nmetrics range:NSMakeRange(metricLocation.location + sizeof(unsigned int) * 2, sizeof(nmetrics))];
        self.nmetrics = nmetrics;

        CUIMetrics *metrics = malloc(sizeof(CUIMetrics) * self.nmetrics);
        for (int idx = 0; idx < nmetrics; idx++) {
            CUIMetrics renditionMetric;

            struct {
                unsigned int a;
                unsigned int b;
                unsigned int c;
                unsigned int d;
                unsigned int e;
                unsigned int f;
            } mtr;
            
            [csiData getBytes:&mtr range:NSMakeRange(metricLocation.location + sizeof(mtr) * idx + sizeof(unsigned int) * 3, sizeof(mtr))];
            renditionMetric.edgeTR = CGSizeMake(mtr.c, mtr.b);
            renditionMetric.edgeBL = CGSizeMake(mtr.a, mtr.d);
            renditionMetric.imageSize = CGSizeMake(mtr.e, mtr.f);
            metrics[idx] = renditionMetric;
        }
        
        self.metrics = metrics;
    }
}

- (void)commitToStorage:(CUIMutableCommonAssetStorage *)assetStorage  :(CUIStructuredThemeStore *)storage {
    if (![self.rendition isKindOfClass:objc_getClass("_CUIThemePixelRendition")] &&
        ![self.rendition isKindOfClass:objc_getClass("_CUIThemeGradientRendition")] &&
        ![self.rendition isKindOfClass:objc_getClass("_CUIThemeEffectRendition")]) {
        // we only save shape effects, gradients, and bitmaps
        return;
    }
    
    CSIGenerator *gen = nil;
    if ([self.rendition isKindOfClass:objc_getClass("_CUIThemeEffectRendition")]) {
        gen = [[CSIGenerator alloc] initWithShapeEffectPreset:self.rendition.effectPreset forScaleFactor:self.rendition.scale];
    } else {
        CGSize size = CGSizeZero;
        if ([self.rendition isKindOfClass:objc_getClass("_CUIThemePixelRendition")]) {
            size = CGSizeMake(CGImageGetWidth(self.image), CGImageGetHeight(self.image));
        }
        gen = [[CSIGenerator alloc] initWithCanvasSize:size sliceCount:(unsigned int)self.nslices layout:self.rendition.subtype];
    }
    
    if (self.image) {
        CGSize imageSize = CGSizeMake(CGImageGetWidth(self.image), CGImageGetHeight(self.image));
        CSIBitmapWrapper *wrapper = [[CSIBitmapWrapper alloc] initWithPixelWidth:imageSize.width
                                                                     pixelHeight:imageSize.height];
        CGContextDrawImage(wrapper.bitmapContext, CGRectMake(0, 0, imageSize.width, imageSize.height), self.image);
        [gen addBitmap:wrapper];
    }
    
    for (unsigned int idx = 0; idx < self.nslices; idx++) {
        [gen addSliceRect:self.slices[idx]];
    }
    
    for (unsigned int idx = 0; idx < self.nmetrics; idx++) {
        [gen addMetrics:self.metrics[idx]];
    }
    
    gen.gradient = self.gradient;
    gen.effectPreset = self.effectPreset;
    
    gen.scaleFactor = self.scale;
    gen.exifOrientation = self.exifOrientation;
    gen.opacity = self.opacity;
    gen.blendMode = self.blendMode;
    gen.colorSpaceID = self.colorspaceID;
    gen.templateRenderingMode = self.rendition.templateRenderingMode;
    gen.isVectorBased = self.rendition.isVectorBased;
    gen.utiType = self.utiType;
    gen.isRenditionFPO = self.rendition.isHeaderFlaggedFPO;
    gen.name = self.rendition.name;
//    gen.excludedFromContrastFilter = YES;
    
    NSData *renditionKey = [storage _newRenditionKeyDataFromKey:(struct _renditionkeytoken *)self.rendition.key];
    [assetStorage setAsset:[gen CSIRepresentationWithCompression:YES] forKey:renditionKey];
}

#pragma mark - Properties

- (CGImageRef)image {
    @synchronized(self) {
        return _image;
    }
}

- (void)setImage:(CGImageRef)image {
    @synchronized(self) {
        if (_image != NULL)
            CGImageRelease(_image);
        
        _image = CGImageRetain(image);
    }
}

- (CGPDFDocumentRef)pdfDocument {
    @synchronized(self) {
        return _pdfDocument;
    }
}

- (void)setPdfDocument:(CGPDFDocumentRef)pdfDocument {
    @synchronized(self) {
        if (_pdfDocument != NULL)
            CGPDFDocumentRelease(_pdfDocument);
        
        _pdfDocument = CGPDFDocumentRetain(pdfDocument);
    }
}

@end
