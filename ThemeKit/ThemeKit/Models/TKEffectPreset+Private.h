//
//  TKEffectPreset+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectPreset.h"
#import <CoreUI/Rendering/CUIShapeEffectPreset.h>

@interface TKEffectPreset ()
@property (readonly) CUIShapeEffectPreset *effectPreset;
@property (readwrite, strong) NSMutableArray *effects;
+ (instancetype)effectPresetWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preset;
- (instancetype)initWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preser;
@end
