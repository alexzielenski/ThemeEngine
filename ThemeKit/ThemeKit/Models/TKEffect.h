//
//  TKEffect.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKTypes.h>

@interface TKEffect : NSObject <NSCopying>
@property (readonly, assign) CUIEffectType type;
@property (readonly) NSString *typeString;

+ (instancetype)effectWithType:(CUIEffectType)type;
- (instancetype)initWithType:(CUIEffectType)type;

+ (instancetype)gradientEffectWithTopColor:(NSColor *)topColor
                               bottomColor:(NSColor *)bottomColor;

+ (instancetype)bevelAndEmbossEffectWithHighlightColor:(NSColor *)highlightColor
                                           shadowColor:(NSColor *)shadowColor
                                            blurRadius:(NSInteger)blur
                                                soften:(NSInteger)soften;

+ (instancetype)extraShadowEffectWithColor:(NSColor *)color
                                blurRadius:(NSInteger)blur
                                    offset:(NSInteger)offset
                                    spread:(NSInteger)spread
                                     angle:(NSInteger)angle;

+ (instancetype)dropShadowEffectWithColor:(NSColor *)color
                               blurRadius:(NSInteger)blur
                                   offset:(NSInteger)offset
                                   spread:(NSInteger)spread
                                    angle:(NSInteger)angle;

+ (instancetype)outerGlowEffectWithColor:(NSColor *)color
                               bluRadius:(NSInteger)blur
                                  spread:(NSInteger)spread;

+ (instancetype)innerShadowEffectWithColor:(NSColor *)color
                                blurRadius:(NSInteger)blur
                                    offset:(NSInteger)offset
                                     angle:(NSInteger)angle
                                 blendMode:(CGBlendMode)blendMode;

+ (instancetype)innerGlowEffectWithColor:(NSColor *)color
                               bluRadius:(NSInteger)blur
                               blendMode:(CGBlendMode)blendMode;

+ (instancetype)colorFillEffectWithColor:(NSColor *)color
                               blendMode:(CGBlendMode)blendMode;

+ (instancetype)outputOpacityEffect:(CGFloat)opacity;
+ (instancetype)shapeOpacityEffect:(CGFloat)opacity;

- (void)setColor:(NSColor *)color forParameter:(CUIEffectParameter)parameter;
- (void)setNumber:(NSNumber *)number forParameter:(CUIEffectParameter)parameter;

- (NSColor *)colorForParameter:(CUIEffectParameter)parameter;
- (NSNumber *)numberForParameter:(CUIEffectParameter)parameter;

- (void)removeParameter:(CUIEffectParameter)parameter;

// These properties are KVC-Compliant
@property NSColor *colorValue;
@property NSColor *color2Value;
@property CGFloat opacityValue;
@property CGFloat opacity2Value;
@property NSUInteger blurRadiusValue;
@property NSUInteger offsetValue;
@property NSUInteger angleValue;
@property CGBlendMode blendModeValue;
@property NSUInteger softenValue;
@property NSUInteger spreadValue;
@end

@interface TKEffect (Properties)
@property (readonly, strong) NSDictionary *parameters;
@end
