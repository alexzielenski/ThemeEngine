//
//  TKEffect+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffect.h"
#import <CoreUI/Rendering/CUIShapeEffectPreset.h>

@interface TKEffect ()
+ (NSArray *)effectsWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preset;

+ (instancetype)effectWithEffectTuples:(CUIEffectTuple *)tuples
                                 count:(NSUInteger)count;

- (instancetype)initWithEffectTuples:(CUIEffectTuple *)tuples
                               count:(NSUInteger)count;

// This method is expensive
// You are responsible for freeing the tuples afterwards
- (void)commitToPreset:(CUIShapeEffectPreset *)preset atIndex:(NSUInteger)x ;

@end
