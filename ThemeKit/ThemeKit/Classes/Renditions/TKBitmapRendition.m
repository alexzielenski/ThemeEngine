//
//  TKBitmapRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKBitmapRendition.h"
#import "TKRendition+Private.h"
#import "TKElement.h"
#import "TKLayoutInformation+Private.h"

@import Accelerate;
#import <CoreUI/Renditions/CUIRenditions.h>

@implementation TKBitmapRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData  key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:(NSData *)csiData key:key])) {
        self.assetPack = rendition.type == CoreThemeTypeAssetPack;
        self.layoutInformation = [TKLayoutInformation layoutInformationWithCSIData:csiData];

        if (!rendition) {
//            [csiData writeToFile:[NSString stringWithFormat:@"/Users/Alex/Desktop/%@", key] atomically:NO];
//            NSLog(@"%@", csiData);
        }
    }
    
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.image) {
        // Just get the image of the rendition
        self._previewImage = [[NSImage alloc] initWithSize:self.image.size];
        [self._previewImage addRepresentation:self.image];
    }
}

- (void)setElement:(TKElement * __nullable)element {
    [super setElement:element];
    
    if ([self.rendition isKindOfClass:TKClass(_CUIInternalLinkRendition)]) {
        [self.rendition _setStructuredThemeStore:self.element.storage];
    }
}

- (NSBitmapImageRep *)image {
    // Lazy load
    // We must set our image here so internal references can be resolved
    // -initWithCGImage: only bumps the retain count, it does not copy, so we're good
    if (!_image) {
        CGImageRef unsliced = self.rendition.unslicedImage;
        if (unsliced != NULL) {
            _image = [[NSBitmapImageRep alloc] initWithCGImage:unsliced];
        }
    }
    return _image;
}

- (void)setImage:(NSBitmapImageRep *)image {
    NSSize oldSize = NSMakeSize(_image.pixelsWide, _image.pixelsHigh);
    _image = image;
    
    CGFloat xScale = image.pixelsWide / oldSize.width;
    CGFloat yScale = image.pixelsHigh / oldSize.height;
    
    // Autoscale slices and metrics
    NSMutableArray *metrics = [NSMutableArray array];
    for (NSValue *metricValue in self.layoutInformation.metrics) {
        CUIMetrics metric;
        [metricValue getValue:&metric];
        metric.imageSize = NSMakeSize(image.pixelsWide, image.pixelsHigh);

        CGSize bl = metric.edgeBL;
        CGSize tr = metric.edgeTR;
        
        bl.width  *= xScale;
        bl.height *= yScale;
        tr.width  *= xScale;
        tr.height *= yScale;
        
        metric.edgeBL = bl;
        metric.edgeTR = tr;
        
        [metrics addObject:[NSValue valueWithBytes:&metric objCType:@encode(CUIMetrics)]];
    }
    
    NSMutableArray *slices = [NSMutableArray array];
    for (NSValue *sliceValue in self.layoutInformation.sliceRects) {
        NSRect slice = sliceValue.rectValue;
        slice.origin.x    *= xScale;
        slice.origin.y    *= yScale;
        slice.size.width  *= xScale;
        slice.size.height *= yScale;
        [slices addObject:[NSValue valueWithRect:slice]];
    }
    
    self.layoutInformation.metrics = metrics;
    self.layoutInformation.sliceRects = slices;
}

+ (NSDictionary *)undoProperties {
    static NSMutableDictionary *TKBitmapProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKBitmapProperties = [NSMutableDictionary dictionary];
        [TKBitmapProperties addEntriesFromDictionary:@{
                                                       TKKey(image): @"Change Image",
                                                       TKKey(layoutInformation): @"Change Layout",
                                                       @"layoutInformation.sliceRects": @"Change Slices",
                                                       @"layoutInformation.metrics": @"Change Image Size"
                                                       }];
        [TKBitmapProperties addEntriesFromDictionary:super.undoProperties];
    });
    
    return TKBitmapProperties;
}

- (CSIGenerator *)generator {
    
    if (self.layout == CoreThemeLayoutInternalLink) {
        self.layout = self.rendition.subtype;
    }

    
    CSIGenerator *gen = [[CSIGenerator alloc] initWithCanvasSize:CGSizeMake(self.image.pixelsWide, self.image.pixelsHigh)
                                                      sliceCount:(unsigned int)self.layoutInformation.sliceRects.count
                                                          layout:self.layout];
    
    CSIBitmapWrapper *wrapper = [[CSIBitmapWrapper alloc] initWithPixelWidth:(unsigned int)self.image.pixelsWide
                                                                 pixelHeight:(unsigned int)self.image.pixelsHigh];
    wrapper.pixelFormat = self.pixelFormat;
    wrapper.allowsMultiPassEncoding = NO;
    
    if (!self.image.isPlanar && self.image.hasAlpha &&
        self.image.bitsPerPixel == 32 && self.image.samplesPerPixel == 4 &&
        wrapper.pixelFormat == CSIPixelFormatARGB &&
        [[self class] shouldProcessPixels]) {
        
        //! Experimental: Disable this by setting +shouldProcessPixels to NO
        //! To try to avoid issues with alpha and lossiness with the bitmap context
        //!
        
        unsigned long *rowBytes = TKIvarPointer(wrapper, "_rowbytes");
        *rowBytes = self.image.bytesPerRow;
        
        unsigned long dataLength = self.image.bytesPerRow * self.image.pixelsHigh;
        unsigned char *newData   = malloc(dataLength);
        unsigned char *pixelData = self.image.bitmapData;
        NSBitmapFormat format    = self.image.bitmapFormat;
        const uint8_t *map = NULL;

        // RGBA to BGRA
        if ((format & NSAlphaFirstBitmapFormat) != NSAlphaFirstBitmapFormat) {
            if ((format & NS32BitBigEndianBitmapFormat) == NS32BitBigEndianBitmapFormat) {
                // ABGR -> BGRA
                const uint8_t big[4] = { 3, 0, 1, 2 };
                map = big;
            } else {
                // RGBA -> BGRA
                const uint8_t little[4] = { 2, 1, 0, 3 };
                map = little;
            }
        } else {
            // ARGB to BGRA
            if ((format & NS32BitBigEndianBitmapFormat) == NS32BitBigEndianBitmapFormat) {
                // BGRA -> BGRA
                const uint8_t big[4] = { 0, 1, 2, 3 };
                map = big;
            } else {
                // ARGB -> BGRA
                const uint8_t little[4] = { 3, 2, 1, 0 };
                map = little;
            }
        }
        
        vImage_Buffer src;
        src.height   = self.image.pixelsHigh;
        src.width    = self.image.pixelsWide;
        src.rowBytes = self.image.bytesPerRow;
        src.data     = pixelData;
        
        vImage_Buffer dst;
        dst.height   = src.height;
        dst.width    = src.width;
        dst.rowBytes = src.rowBytes;
        dst.data     = newData;
        
        vImagePermuteChannels_ARGB8888(&src,
                                       &dst,
                                       map,
                                       kvImageNoFlags);
        
        // Unpremultiply that alpha
        if ((format & NSAlphaNonpremultipliedBitmapFormat) != NSAlphaNonpremultipliedBitmapFormat) {
            src.data = newData;
            vImageUnpremultiplyData_ARGB8888(&src,
                                             &dst,
                                             kvImageNoFlags);
        }
        
        [wrapper setPixelData:[NSData dataWithBytesNoCopy:newData length:dataLength freeWhenDone:YES]];
    } else {
        CGContextDrawImage(wrapper.bitmapContext,
                           CGRectMake(0, 0, self.image.pixelsWide, self.image.pixelsHigh),
                           self.image.CGImage);
    }
    
    [gen addBitmap:wrapper];
    
    NSArray<NSValue *> *slices = self.layoutInformation.sliceRects;
    for (NSInteger x = 0; x < slices.count; x++) {
        [gen addSliceRect:slices[x].rectValue];
    }
    
    NSArray<NSValue *> *metrics = self.layoutInformation.metrics;
    for (NSInteger x = 0; x < metrics.count; x++) {
        CUIMetrics metric;
        [metrics[x] getValue:&metric];
        [gen addMetrics:metric];
    }
    
    return gen;
}


static BOOL shouldProcessPixels = NO;
+ (void)setShouldProcessPixels:(BOOL)flag {
    shouldProcessPixels = flag;
}

+ (BOOL)shouldProcessPixels {
    return shouldProcessPixels;
}

@end
