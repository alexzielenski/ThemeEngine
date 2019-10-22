//
//  TKGradientRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientRendition.h"
#import "TKRendition+Private.h"

#import "TKGradient+Private.h"

@implementation TKGradientRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        self.gradient = [TKGradient gradientWithCUIGradient:rendition.gradient
                                                      angle:rendition.gradientDrawingAngle
                                                      style:rendition.gradientStyle];
    }
    
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.gradient) {
        __strong TKGradient *grad = self.gradient;
        
        self._previewImage = [NSImage imageWithSize:NSMakeSize(64, 64)
                                            flipped:NO
                                     drawingHandler:^BOOL(NSRect dstRect) {
                                         [grad drawInRect:dstRect];
                                         return YES;
                                     }];
    }
}

+ (NSDictionary *)undoProperties {
    static NSMutableDictionary *TKGradientProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKGradientProperties = [NSMutableDictionary dictionary];
        [TKGradientProperties addEntriesFromDictionary:@{
                                                         TKKey(utiType): @"Change UTI",
                                                         TKKey(gradient): @"Change Gradient",
                                                         @"gradient.radial": @"Change Gradient Type",
                                                         @"gradient.angle": @"Change Gradient Angle",
                                                         @"gradient.dithered": @"Change Gradient Dithering",
                                                         @"gradient.smoothingCoefficient": @"Change Gradient Smoothing",
                                                         @"gradient.fillCoefficient": @"Change Gradient Fill Coefficient",
                                                         @"gradient.fillColor": @"Change Gradient Fill Color",
                                                         @"gradient.blendMode": @"Change Gradient Blend Mode",
                                                         }];
        [TKGradientProperties addEntriesFromDictionary:[super undoProperties]];
    });
    
    return TKGradientProperties;
}

+ (NSDictionary<NSString *, NSDictionary *> *)collectionProperties {
    static NSDictionary *collectionProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionProperties = @{ @"gradient.colorStops": @[ @"Color Stops", @(TKCollectionTypeArray), @{
                                                                 @"color": @"Change Stop Color",
                                                                 @"location": @"Move Stop",
                                                                 @"leadOutColor": @"Change Stop LeadOut Color",
                                                                 @"doubleStop": @"Make Double Stop",
                                                                 }],
                                  @"gradient.opacityStops": @[ @"Opacity Stops", @(TKCollectionTypeArray), @{
                                                                   @"opacity": @"Change Stop Opacity",
                                                                   @"location": @"Change Stop Location",
                                                                   @"leadOutOpacity": @"Change Stop LeadOut Opacity",
                                                                   @"doubleStop": @"Make Double Stop",
                                                                   }],
                                  @"gradient.opacityMidpoints": @[ @"Midpoints", @(TKCollectionTypeArray), @{} ],
                                  @"gradient.colorMidpoints": @[ @"Midpoints", @(TKCollectionTypeArray), @{} ]
                                  };
    });
    return collectionProperties;
}

- (CSIGenerator *)generator {
    CSIGenerator *generator = [[CSIGenerator alloc] initWithCanvasSize:CGSizeZero
                                                            sliceCount:0
                                                                layout:self.layout];
    
    generator.gradient = self.gradient.psdGradient;
    return generator;
}

@end
