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
#import <objc/runtime.h>

#define kSLICES 0xE903
#define kMETRICS 0xEB03
#define kFLAGS 0xEC03
#define kUTI 0xED03
#define kEXIF 0xEE03

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
    void *ptr = ivar == NULL ? NULL : (__bridge void *)themeGradient + ivar_getOffset(ivar);
    CUIPSDGradientEvaluator *evaluator = (__bridge CUIPSDGradientEvaluator *)(ptr);
    return [[CUIPSDGradient alloc] initWithEvaluator:evaluator drawingAngle:angle gradientStyle:style];
}

static CUIPSDGradient *psdGradientFromRendition(CUIThemeRendition *rendition) {
    return psdGradientFromThemeGradient(rendition.gradient, rendition.gradientDrawingAngle, rendition.gradientStyle);
}


@interface CFAsset ()
@property (readwrite, strong) CUIThemeRendition *rendition;
@property (readwrite, assign) CGRect *slices;
@property (readwrite, assign) NSUInteger nslices;
@property (readwrite, assign) CUIMetrics *metrics;
@property (readwrite, assign) NSUInteger nmetrics;
@property (strong) CUIRenditionKey *key;
- (void)_initializeSlicesFromCSIData:(NSData *)csiData;
- (void)_initializeMetricsFromCSIData:(NSData *)csiData;
@end

@implementation CFAsset

+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    return [[self alloc] initWithCSIData:csiData forKey:key];
}

- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    if ((self = [self init])) {
        self.key = [CUIRenditionKey renditionKeyWithKeyList:key];
        self.rendition = [[objc_getClass("CUIThemeRendition") alloc] initWithCSIData:csiData forKey:key];

        self.gradient = psdGradientFromRendition(self.rendition);
        self.image = [[NSBitmapImageRep alloc] initWithCGImage:self.rendition.unslicedImage];
        
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
        [csiData getBytes:&nslices range:NSMakeRange(sliceLocation.location + sizeof(unsigned int) * 2, 4)];
        self.nslices = nslices;
        CGRect *slices = malloc(sizeof(CGRect) * self.nslices);
        for (int idx = 0; idx < nslices; idx++) {
            struct {
                unsigned int x;
                unsigned int y;
                unsigned int w;
                unsigned int h;
            } sliceInts;
            
            [csiData getBytes:&sliceInts range:NSMakeRange(sliceLocation.location + sizeof(sliceInts) * idx, sizeof(sliceInts))];
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
        [csiData getBytes:&nmetrics range:NSMakeRange(metricLocation.location + sizeof(unsigned int) * 2, 4)];
        self.nmetrics = nmetrics;
        CUIMetrics *metrics = malloc(sizeof(metrics) * self.nmetrics);
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
            
            [csiData getBytes:&mtr range:NSMakeRange(metricLocation.location + sizeof(mtr) * idx, sizeof(mtr))];
            renditionMetric.edgeTR = CGSizeMake(mtr.c, mtr.b);
            renditionMetric.edgeBL = CGSizeMake(mtr.a, mtr.d);
            renditionMetric.imageSize = CGSizeMake(mtr.e, mtr.f);
            metrics[idx] = renditionMetric;
        }
        
        self.metrics = metrics;
    }
}

- (void)commitToStorage:(CUIMutableStructuredThemeStore *)storage {
    
}

@end
