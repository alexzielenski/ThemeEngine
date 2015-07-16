//
//  TKEffectRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectRendition.h"
#import "TKRendition+Private.h"
#import "TKEffectPreset+Private.h"

@interface TKEffectRendition () {
    TKEffectPreset *_effectPreset;
}

@end

@implementation TKEffectRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        self.effectPreset = [TKEffectPreset effectPresetWithCUIShapeEffectPreset:rendition.effectPreset];

    }
    
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    self._previewImage = [[NSImage alloc] init];
    [self._previewImage addRepresentation:[self.effectPreset proccesedImage:[TKEffectPreset shapeImage]]];
}

+ (NSDictionary *)undoProperties {
    static NSMutableDictionary *TKEffectProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKEffectProperties = [NSMutableDictionary dictionary];
        [TKEffectProperties addEntriesFromDictionary:@{
                                                       TKKey(utiType): @"Change UTI",
                                                       TKKey(effectPreset): @"Change Effect Preset",
                                                       @"effectPreset.scaleFactor": @"Change Scale Factor"
                                                       }];
        [TKEffectProperties addEntriesFromDictionary:[super undoProperties]];
    });
    
    return TKEffectProperties;
}

+ (NSDictionary<NSString *, NSDictionary *> *)collectionProperties {
    static NSDictionary *collectionProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionProperties = @{ @"effectPreset.effects": @[ @"Effects", @(TKCollectionTypeArray), @{
                                                                  TKKey(colorValue): @"Change Effect Color",
                                                                  TKKey(color2Value): @"Change Effect Color 2",
                                                                  TKKey(opacityValue): @"Change Effect Opacity",
                                                                  TKKey(opacity2Value): @"Change Effect Opacity 2",
                                                                  TKKey(blurRadiusValue): @"Change Effect Blur Radius",
                                                                  TKKey(offsetValue): @"Change Effect Offset",
                                                                  TKKey(angleValue): @"Change Effect Angle",
                                                                  TKKey(softenValue): @"Change Effect Softness",
                                                                  TKKey(spreadValue): @"Change Effect Spread"
                                                                  }],
                                  };
    });
    return collectionProperties;
}

- (CSIGenerator *)generator {
    CSIGenerator *generator = [[CSIGenerator alloc] initWithShapeEffectPreset:self.effectPreset.effectPreset
                                                               forScaleFactor:(unsigned int)self.scaleFactor * 100];
    
    return generator;
}

@end
