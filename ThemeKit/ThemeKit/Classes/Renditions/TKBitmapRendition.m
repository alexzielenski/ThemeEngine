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

#
#import <CoreUI/Renditions/CUIRenditions.h>

@implementation TKBitmapRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData  key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:(NSData *)csiData key:key])) {
        self.assetPack = rendition.type == CoreThemeTypeAssetPack;
        self.layoutInformation = [TKLayoutInformation layoutInformationWithCSIData:csiData];
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
            
            // remove backing image after we're done with it
            CGImageRef *ptr = TKIvarPointer(self.rendition, "_unslicedImage");
            if (ptr != NULL && *ptr != NULL) {
                CGImageRelease(*ptr);
                *ptr = NULL;
            }

            // This is on CUIThemePixelRendition
            //!TODO: Circumvent the default unslicedImage implementation
            //! so that we can reliably throw out unused Apple data.
            //! and save ram
//            CGImageRef *image = TKIvarPointer(self.rendition, "unslicedImage");
//            if (image != NULL) {
//                if (*image != NULL)
//                    CGImageRelease(*image);
//                *image = NULL;
//            }
        }
    }
    return _image;
}

+ (NSDictionary *)undoProperties {
    static NSDictionary *TKBitmapProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKBitmapProperties = @{
                               TKKey(utiType): @"Change UTI",
                               TKKey(image): @"Change Image",
                               TKKey(opacity): @"Change Opacity",
                               TKKey(blendMode): @"Change Blend Mode",
                               TKKey(exifOrientation): @"Change EXIF Orientation",
                               TKKey(layoutInformation): @"Change Layout",
                               @"layoutInformation.sliceRects": @"Change Slices",
                               @"layoutInformation.metrics": @"Change Image Size"
                               };
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
    wrapper.allowsMultiPassEncoding = YES;
    CGContextDrawImage(wrapper.bitmapContext,
                       CGRectMake(0, 0, self.image.pixelsWide, self.image.pixelsHigh),
                       self.image.CGImage);
    
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

@end
