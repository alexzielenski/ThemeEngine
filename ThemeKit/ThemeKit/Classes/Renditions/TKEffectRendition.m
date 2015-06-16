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

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    self._previewImage = [[NSImage alloc] init];
    [self._previewImage addRepresentation:[self.effectPreset proccesedImage:[TKEffectPreset shapeImage]]];
}

- (TKEffectPreset *)effectPreset {
    if (!_effectPreset) {
        self.effectPreset = [TKEffectPreset effectPresetWithCUIShapeEffectPreset:self.rendition.effectPreset];
    }
    
    return _effectPreset;
}

- (void)setEffectPreset:(TKEffectPreset *)effectPreset {
    _effectPreset = effectPreset;
    self._previewImage = nil;
}

@end
