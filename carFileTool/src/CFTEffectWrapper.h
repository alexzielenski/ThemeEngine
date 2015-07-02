//
//  CFTEffectWrapper.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFTEffect.h"
#import "CUIShapeEffectPreset.h"

@interface CFTEffectWrapper : NSObject <NSCopying>

+ (instancetype)effectWrapper;
+ (instancetype)effectWrapperWithEffectPreset:(CUIShapeEffectPreset *)preset;
- (instancetype)initWithEffectPreset:(CUIShapeEffectPreset *)preser;

- (void)addEffect:(CFTEffect *)effect;
- (void)insertEffect:(CFTEffect *)effect atIndex:(NSUInteger)index;

- (void)removeEffect:(CFTEffect *)effect;
- (void)removeEffectAtIndex:(NSUInteger)index;

- (void)moveEffectAtIndex:(NSUInteger)index toIndex:(NSUInteger)destination;

@property (readonly) CUIShapeEffectPreset *effectPreset;
@end

@interface CFTEffectWrapper (Properties)
@property (readonly, strong) NSArray *effects;
@end
