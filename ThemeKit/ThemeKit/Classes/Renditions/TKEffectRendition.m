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

- (void)setEffectPreset:(TKEffectPreset *)effectPreset {
    _effectPreset = effectPreset;
    self._previewImage = nil;
}

+ (NSDictionary *)undoProperties {
    static NSDictionary *TKEffectProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKEffectProperties = @{
                               TKKey(utiType): @"Change UTI",
                               TKKey(effectPreset): @"Change Effect Preset",
                               @"effectPreset.effects": @"Change Effects"
                               };
    });
    
    return TKEffectProperties;
}

@end
