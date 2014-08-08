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
#import <stddef.h>

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
 0xEC03 - 1004: Composition - First 4 length, second is the blendmode, third is a float for opacity
 0xED03 - 1005: UTI Type, First 4 length, next 4 length of string, then the string
 0xEE03 - 1006: Image Metadata: First 4 length, next 4 EXIF orientation, (UTI type...?)
 
 unk
 
 GRADIENTS marked DARG with colors as RLOC, and opacity a TCPO format unknown
 0x4D4C4543 - MLEC: Start Image Data?
 RAW DATA: marts 'RAWD' followed by 4 bytes of zero and an unsigned int of the length of the raw data
 */

static CUIPSDGradient *psdGradientFromThemeGradient(CUIThemeGradient *themeGradient, double angle, unsigned int style) {
    if (!themeGradient)
        return nil;
    
    Ivar ivar = class_getInstanceVariable([themeGradient class], "gradientEvaluator");
    CUIPSDGradientEvaluator *evaluator = object_getIvar(themeGradient, ivar);
    return [[CUIPSDGradient alloc] initWithEvaluator:evaluator drawingAngle:angle gradientStyle:style];
}

static CUIPSDGradient *psdGradientFromRendition(CUIThemeRendition *rendition) {
    return psdGradientFromThemeGradient(rendition.gradient, rendition.gradientDrawingAngle, rendition.gradientStyle);
}

static BOOL gradientsEqual(CUIThemeGradient *themeGradient, CUIPSDGradient *psd) {
    Ivar ivar = class_getInstanceVariable([themeGradient class], "gradientEvaluator");
    CUIPSDGradientEvaluator *evaluator = object_getIvar(themeGradient, ivar);
    
    //!TODO: compare values instead of pointers
    return psd.evaluator == evaluator;
}

@interface CFAsset () {
    CGImageRef _image;
    CGPDFDocumentRef _pdfDocument;
}
@property (readwrite, weak) CFElement *element;
@property (readwrite, strong) CUIThemeRendition *rendition;
@property (readwrite, assign) CGRect *slices;
@property (readwrite, assign) NSUInteger nslices;
@property (readwrite, assign) CUIMetrics *metrics;
@property (readwrite, assign) NSUInteger nmetrics;
@property (readwrite, copy) NSString *name;
@property (readwrite, strong) CUIRenditionKey *key;
- (void)_initializeSlicesFromCSIData:(NSData *)csiData;
- (void)_initializeMetricsFromCSIData:(NSData *)csiData;
- (void)_initializeRawDataFromCSIData:(NSData *)csiData;
- (NSData *)_keyDataWithFormat:(struct _renditionkeyfmt *)format;
@end

@implementation CFAsset
@dynamic image, pdfData;

+ (instancetype)assetWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    return [[self alloc] initWithRenditionCSIData:csiData forKey:key];
}

- (instancetype)initWithRenditionCSIData:(NSData *)csiData forKey:(struct _renditionkeytoken *)key {
    if ((self = [self init])) {
        [csiData writeToFile:@"/Users/Alex/Desktop/data" atomically:NO];
        //!TODO: Get renditionflags from raw data
        self.key = [CUIRenditionKey renditionKeyWithKeyList:key];
        self.rendition = [[objc_getClass("CUIThemeRendition") alloc] initWithCSIData:csiData forKey:key];
        self.gradient = psdGradientFromRendition(self.rendition);
        self.effectPreset = self.rendition.effectPreset;
        self.image = self.rendition.unslicedImage;
        self.type = self.rendition.type;
        self.scale = self.rendition.scale;
        self.name = self.rendition.name;
        self.utiType = self.rendition.utiType;
        self.blendMode = self.rendition.blendMode;
        self.opacity = self.rendition.opacity;
        self.exifOrientation = self.rendition.exifOrientation;
        self.colorSpaceID = (short)self.rendition.colorSpaceID;
        [csiData getBytes:&_layout range:NSMakeRange(offsetof(struct _csiheader, metadata.layout), 2)];

        [self _initializeSlicesFromCSIData:csiData];
        [self _initializeMetricsFromCSIData:csiData];
        [self _initializeRawDataFromCSIData:csiData];
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

- (void)_initializeRawDataFromCSIData:(NSData *)csiData {
    unsigned int listOffset = offsetof(struct _csiheader, listLength);
    unsigned int listLength = 0;
    [csiData getBytes:&listLength range:NSMakeRange(listOffset, sizeof(listLength))];
    listOffset += listLength + sizeof(unsigned int) * 4;
    
    unsigned int type = 0;
    [csiData getBytes:&type range:NSMakeRange(listOffset, sizeof(type))];
    if (type != 'RAWD')
        return;
    
    listOffset += 8;
    unsigned int dataLength = 0;
    [csiData getBytes:&dataLength range:NSMakeRange(listOffset, sizeof(dataLength))];
    
    if (dataLength == 0)
        return;
    
    listOffset += sizeof(dataLength);
    self.rawData = [csiData subdataWithRange:NSMakeRange(listOffset, dataLength)];
}

// same as calling CUIStructuredThemeStore _newRenditionKeyDataFromKey:
- (NSData *)_keyDataWithFormat:(struct _renditionkeyfmt *)format {
    /*
     The key format contains a list of the order of attributes for which they should appear
     for each key in data. The list has just ints corresponding to the identifier for each attribute
     so we find which index each value in the attribute list shall go into and place its value at the
     right offset. Identifiers correspond to CFThemeAttributeName
     */
    NSMutableData *data = [[NSMutableData alloc] initWithLength:format->numTokens * sizeof(uint16_t)];
    struct _renditionkeytoken currentToken = self.key.keyList[0];
    unsigned int idx = 0;
    do {
        int tokenIdx = -1;
        unsigned int keyIdx = 0;
        do {
            if (format->attributes[keyIdx] == currentToken.identifier)
                tokenIdx = keyIdx;
            keyIdx++;
        } while (tokenIdx == -1 && keyIdx < format->numTokens);
        
        if (tokenIdx != -1) {
            size_t size = sizeof(currentToken.value);
            [data replaceBytesInRange:NSMakeRange(tokenIdx * size, size) withBytes:&currentToken.value length:size];
        }
        
        currentToken = self.key.keyList[++idx];
    } while (currentToken.identifier != 0);
    
    return data;
}

- (void)commitToStorage:(CUIMutableCommonAssetStorage *)assetStorage {
    NSData *renditionKey = [self _keyDataWithFormat:(struct _renditionkeyfmt *)assetStorage.keyFormat];

    if (self.shouldRemove) {
        [assetStorage removeAssetForKey:renditionKey];
        return;
    }
    
    if (!self.isDirty)
        return;
    
    if (self.type > kCoreThemeTypePDF) {
        // we only save shape effects, gradients, pdfs, and bitmaps
        return;
    }
    
    CSIGenerator *gen = nil;
    if (self.type == kCoreThemeTypeEffect) {
        gen = [[CSIGenerator alloc] initWithShapeEffectPreset:self.effectPreset forScaleFactor:self.scale];
    } else if (self.type == kCoreThemeTypePDF) {
        gen = [[CSIGenerator alloc] initWithRawData:self.pdfData pixelFormat:'PDF ' layout:self.layout];
    } else {
        CGSize size = CGSizeZero;
        if (self.type != kCoreThemeTypeGradient) {
            size = CGSizeMake(CGImageGetWidth(self.image), CGImageGetHeight(self.image));
        }
        gen = [[CSIGenerator alloc] initWithCanvasSize:size sliceCount:(unsigned int)self.nslices layout:self.layout];
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
    if (self.type <= 8) {
        gen.scaleFactor = self.scale;
    }
    
//!TODO: For some reason whenever I compile PDFs i get a colorspaceID of 15 even when I set it to something else
    gen.exifOrientation = self.exifOrientation;
    gen.colorSpaceID = self.colorSpaceID;
    gen.opacity = self.opacity;
    gen.blendMode = self.blendMode;
    gen.templateRenderingMode = self.rendition.templateRenderingMode;
    gen.isVectorBased = self.rendition.isVectorBased;
    gen.utiType = self.utiType;
    gen.isRenditionFPO = self.rendition.isHeaderFlaggedFPO;
    gen.name = self.rendition.name;
//    gen.excludedFromContrastFilter = YES;
    
    NSData *csiData = [gen CSIRepresentationWithCompression:YES];
    if (self.type == kCoreThemeTypePDF) {
        [csiData writeToFile:@"/Users/Alex/Desktop/csi_new" atomically:NO];
        [[self.rendition valueForKey:@"_srcData"] writeToFile:@"/Users/Alex/Desktop/csi_old" atomically:NO];
    }
    [assetStorage setAsset:csiData forKey:renditionKey];
}

- (BOOL)isDirty {
    return self.type == kCoreThemeTypePDF;
    BOOL clean = YES;
#define COMPARE(KEY) clean &= self.KEY == self.rendition.KEY
    COMPARE(scale);
    COMPARE(exifOrientation);
    COMPARE(opacity);
    COMPARE(blendMode);
    COMPARE(colorSpaceID);
    COMPARE(utiType);
    COMPARE(type);
    
    clean &= self.layout == self.rendition.subtype;
    clean &= self.image == self.rendition.unslicedImage;
    clean &= gradientsEqual(self.rendition.gradient, self.gradient);

    //!TODO: PDF Data
    //!TODO: slice changes
    
    return !clean;
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

- (NSData *)pdfData {
    return self.rawData;
}

- (void)setPdfData:(NSData *)pdfData {
    [self setRawData:pdfData];
}

+ (NSSet *)keyPathsForValuesAffectingPdfData {
    return [NSSet setWithObject:@"rawData"];
}

@end
