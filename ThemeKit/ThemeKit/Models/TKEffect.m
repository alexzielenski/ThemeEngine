//
//  TKEffect.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffect.h"
#import "TKEffect+Private.h"
#import <CoreUI/Rendering/CUIShapeEffectPreset.h>

@interface TKEffect ()
@property (readwrite, assign) CUIEffectType type;
@property (readwrite, strong) NSMutableDictionary *parameters;
@end

@implementation TKEffect
@dynamic colorValue, color2Value, offsetValue, opacity2Value, opacityValue, blendModeValue, blurRadiusValue, angleValue, softenValue, spreadValue, typeString;

#pragma mark - Initialization

+ (instancetype)effectWithType:(CUIEffectType)type {
    return [[self alloc] initWithType:type];
}

+ (instancetype)effectWithEffectTuples:(CUIEffectTuple *)tuples count:(NSUInteger)count {
    return [[self alloc] initWithEffectTuples:tuples count:count];
}

+ (NSArray *)effectsWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preset {
    NSMutableArray *effects = [NSMutableArray array];
    NSUInteger count = preset.effectCount;
    for (NSUInteger x = 0; x < count; x++) {
        CUIEffectTuple *tuples = NULL;
        NSUInteger tupleCount = 0;
        [preset getEffectTuples:&tuples count:&tupleCount atEffectIndex:x];
        [effects addObject:[TKEffect effectWithEffectTuples:tuples count:tupleCount]];
    }
    
    return effects;
}

+ (instancetype)gradientEffectWithTopColor:(NSColor *)topColor bottomColor:(NSColor *)bottomColor {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeGradientFill];
    [effect setColor:topColor forParameter:CUIEffectParameterColor];
    [effect setColor:bottomColor forParameter:CUIEffectParameterColor2];
    [effect setNumber:@(topColor.alphaComponent) forParameter:CUIEffectParameterOpacity];
    return effect;
}

+ (instancetype)bevelAndEmbossEffectWithHighlightColor:(NSColor *)highlightColor shadowColor:(NSColor *)shadowColor blurRadius:(NSInteger)blur soften:(NSInteger)soften {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeBevelAndEmboss];
    [effect setColor:highlightColor forParameter:CUIEffectParameterColor];
    [effect setColor:shadowColor forParameter:CUIEffectParameterColor2];
    [effect setNumber:@(highlightColor.alphaComponent) forParameter:CUIEffectParameterOpacity];
    [effect setNumber:@(shadowColor.alphaComponent) forParameter:CUIEffectParameterOpacity2];
    [effect setNumber:@(blur) forParameter:CUIEffectParameterBlurRadius];
    [effect setNumber:@(soften) forParameter:CUIEffectParameterSoften];
    return effect;
}

+ (instancetype)extraShadowEffectWithColor:(NSColor *)color blurRadius:(NSInteger)blur offset:(NSInteger)offset spread:(NSInteger)spread angle:(NSInteger)angle {
    TKEffect *effect = [self dropShadowEffectWithColor:color blurRadius:blur offset:offset spread:spread angle:angle];
    effect.type = CUIEffectTypeExtraShadow;
    return effect;
}

+ (instancetype)dropShadowEffectWithColor:(NSColor *)color blurRadius:(NSInteger)blur offset:(NSInteger)offset spread:(NSInteger)spread angle:(NSInteger)angle {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeDropShadow];
    [effect setColor:color forParameter:CUIEffectParameterColor];
    [effect setNumber:@(color.alphaComponent) forParameter:CUIEffectParameterOpacity];
    [effect setNumber:@(spread) forParameter:CUIEffectParameterSpread];
    [effect setNumber:@(blur) forParameter:CUIEffectParameterBlurRadius];
    [effect setNumber:@(offset) forParameter:CUIEffectParameterOffset];
    [effect setNumber:@(angle) forParameter:CUIEffectParameterAngle];
    return effect;
}

+ (instancetype)outerGlowEffectWithColor:(NSColor *)color bluRadius:(NSInteger)blur spread:(NSInteger)spread {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeOuterGlow];
    [effect setColor:color forParameter:CUIEffectParameterColor];
    [effect setNumber:@(color.alphaComponent) forParameter:CUIEffectParameterOpacity];
    [effect setNumber:@(blur) forParameter:CUIEffectParameterBlurRadius];
    [effect setNumber:@(spread) forParameter:CUIEffectParameterSpread];
    return effect;
}

+ (instancetype)innerShadowEffectWithColor:(NSColor *)color blurRadius:(NSInteger)blur offset:(NSInteger)offset angle:(NSInteger)angle blendMode:(CGBlendMode)blendMode {
    TKEffect *effect = [self dropShadowEffectWithColor:color blurRadius:blur offset:offset spread:0 angle:angle];
    effect.type = CUIEffectTypeInnerShadow;
    [effect removeParameter:CUIEffectParameterSpread];
    [effect setNumber:@(blendMode) forParameter:CUIEffectParameterBlendMode];
    return effect;
}

+ (instancetype)innerGlowEffectWithColor:(NSColor *)color bluRadius:(NSInteger)blur blendMode:(CGBlendMode)blendMode {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeInnerGlow];
    [effect setColor:color forParameter:CUIEffectParameterColor];
    [effect setNumber:@(color.alphaComponent) forParameter:CUIEffectParameterOpacity];
    [effect setNumber:@(blur) forParameter:CUIEffectParameterBlurRadius];
    [effect setNumber:@(blendMode) forParameter:CUIEffectParameterBlendMode];
    return effect;
}

+ (instancetype)colorFillEffectWithColor:(NSColor *)color blendMode:(CGBlendMode)blendMode {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeColorFill];
    [effect setColor:color forParameter:CUIEffectParameterColor];
    [effect setNumber:@(color.alphaComponent) forParameter:CUIEffectParameterOpacity];
    [effect setNumber:@(blendMode) forParameter:CUIEffectParameterBlendMode];
    return effect;
}

+ (instancetype)outputOpacityEffect:(CGFloat)opacity {
    TKEffect *effect = [TKEffect effectWithType:CUIEffectTypeOutputOpacity];
    [effect setNumber:@(opacity) forParameter:CUIEffectParameterOpacity];
    return effect;
}

+ (instancetype)shapeOpacityEffect:(CGFloat)opacity {
    TKEffect *effect = [self outputOpacityEffect:opacity];
    effect.type = CUIEffectTypeShapeOpacity;
    return effect;
}

- (instancetype)initWithType:(CUIEffectType)type {
    if ((self = [super init])) {
        self.type = type;
        self.parameters = [NSMutableDictionary dictionary];
        
        // add required params
        NSArray *required = [CUIShapeEffectPreset requiredEffectParametersForEffectType:type];
        for (NSNumber *num in required) {
            switch (num.unsignedIntegerValue) {
                case CUIEffectParameterColor:
                case CUIEffectParameterColor2:
                    [self setColor:[NSColor blackColor]
                      forParameter:(CUIEffectParameter)num.unsignedIntegerValue];
                    break;
                default:
                    [self setNumber:@(0)
                       forParameter:(CUIEffectParameter)num.unsignedIntegerValue];
                    break;
            }
        }        
    }
    
    return self;
}

- (instancetype)initWithEffectTuples:(CUIEffectTuple *)tuples count:(NSUInteger)count {
    if ((self = [super init])) {
        self.type = tuples[0].effectType;
        self.parameters = [NSMutableDictionary dictionary];
        
        for (NSUInteger x = 0; x < count; x++) {
            CUIEffectTuple tuple = tuples[x];
            switch (tuple.effectParameter) {
                case CUIEffectParameterColor:
                case CUIEffectParameterColor2: {
                    struct _rgbcolor color = tuple.effectValue.colorValue;
                    [self setColor:[NSColor colorWithRed:(CGFloat)color.r / 255.0
                                                   green:(CGFloat)color.g / 255.0
                                                    blue:(CGFloat)color.b / 255.0
                                                   alpha:1.0]
                      forParameter:tuple.effectParameter];
                    break;
                }
                case CUIEffectParameterOpacity:
                case CUIEffectParameterOpacity2:
                    [self setNumber:@(tuple.effectValue.floatValue) forParameter:tuple.effectParameter];
                    break;
                default:
                    [self setNumber:@(tuple.effectValue.intValue) forParameter:tuple.effectParameter];
                    break;
            }
        }
    }
    return self;
}

- (id)init {
    NSAssert(NO, @"You must call -initWithType: on CUIEffect");
    return nil;
}

#pragma mark - Protocols

- (id)copyWithZone:(NSZone *)zone {
    TKEffect *effect = [TKEffect effectWithType:self.type];
    for (NSString *key in self.parameters) {
        effect.parameters[key] = [self.parameters[key] copy];
    }
    return effect;
}

- (BOOL)isEqual:(TKEffect *)object {
    return self.type == object.type && [self.parameters isEqualToDictionary:object.parameters];
}

#pragma mark - Effect Parameters

- (void)setColor:(NSColor *)color forParameter:(CUIEffectParameter)parameter {
    if (!color)
        return;
    
    NSAssert([color isKindOfClass:[NSColor class]], @"Must pass NSColor object to %@. You passed %@", NSStringFromSelector(_cmd), color);
    [self willChangeValueForKey:@"parameters"];
    
    color = [color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    self.parameters[@(parameter)] = color;
    
    [self didChangeValueForKey:@"parameters"];
}

- (void)setNumber:(NSNumber *)number forParameter:(CUIEffectParameter)parameter {
    NSAssert([number isKindOfClass:[number class]], @"Must pass NSNumber object to %@", NSStringFromSelector(_cmd));
    [self willChangeValueForKey:@"parameters"];
    self.parameters[@(parameter)] = number;
    [self didChangeValueForKey:@"parameters"];
}
- (void)removeParameter:(CUIEffectParameter)parameter {
    [self willChangeValueForKey:@"parameters"];
    self.parameters[@(parameter)] = nil;
    [self didChangeValueForKey:@"parameters"];
}

- (NSColor *)colorForParameter:(CUIEffectParameter)parameter {
    if ([self.parameters.allKeys containsObject:@(parameter)])
        return self.parameters[@(parameter)];
    return nil;
}

- (NSNumber *)numberForParameter:(CUIEffectParameter)parameter {
    if ([self.parameters.allKeys containsObject:@(parameter)])
        return self.parameters[@(parameter)];
    return nil;
}

- (void)commitToPreset:(CUIShapeEffectPreset *)preset atIndex:(NSUInteger)x {
    NSArray *keys = self.parameters.allKeys;
    for (NSNumber *key in keys) {
        CUIEffectParameter parameter = (CUIEffectParameter)key.integerValue;
        NSNumber *value = self.parameters[@(parameter)];
        
        CUIEffectTuple tuple;
        tuple.effectType = self.type;
        tuple.effectParameter = parameter;
        
        CUIEffectValue val;
        
        switch (parameter) {
            case CUIEffectParameterColor:
            case CUIEffectParameterColor2: {
                NSColor *clr = [(NSColor *)value colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
                struct _rgbcolor rgb;
                
                rgb.r = (unsigned char)(clr.redComponent * 255);
                rgb.g = (unsigned char)(clr.greenComponent * 255);
                rgb.b = (unsigned char)(clr.blueComponent * 255);
                
                val.colorValue = rgb;
                break;
            }
            case CUIEffectParameterAngle: {
                val.angleValue = value.shortValue;
                break;
            }
            case CUIEffectParameterBlendMode: {
                val.enumValue = value.unsignedIntValue;
                break;
            }
            case CUIEffectParameterOpacity:
            case CUIEffectParameterOpacity2:
                val.floatValue = value.doubleValue;
                break;
            default:
                val.intValue = value.unsignedLongLongValue;
                break;
        }
        
        tuple.effectValue = val;
        [preset _insertEffectTuple:tuple atEffectIndex:x];
    }
}

#pragma mark - Convenience Properties

- (NSString *)typeString {
    return CUIEffectTypeToString(self.type);
}

- (NSColor *)colorValue {
    return [self colorForParameter:CUIEffectParameterColor];
}

- (NSColor *)color2Value {
    return [self colorForParameter:CUIEffectParameterColor2];
}

- (CGFloat)opacityValue {
    return [[self numberForParameter:CUIEffectParameterOpacity] doubleValue];
}

- (CGFloat)opacity2Value {
    return [[self numberForParameter:CUIEffectParameterOpacity2] doubleValue];
}

- (NSUInteger)blurRadiusValue {
    return [[self numberForParameter:CUIEffectParameterBlurRadius] unsignedIntegerValue];
}

- (NSUInteger)offsetValue {
    return [[self numberForParameter:CUIEffectParameterOffset] unsignedIntegerValue];
}

- (NSUInteger)angleValue {
    return [[self numberForParameter:CUIEffectParameterAngle] unsignedIntegerValue];
}

- (CGBlendMode)blendModeValue {
    return (CGBlendMode)[[self numberForParameter:CUIEffectParameterBlendMode] unsignedIntegerValue];
}

- (NSUInteger)softenValue {
    return [[self numberForParameter:CUIEffectParameterSoften] unsignedIntegerValue];
}

- (NSUInteger)spreadValue {
    return [[self numberForParameter:CUIEffectParameterSpread] unsignedIntegerValue];
}

- (void)setColorValue:(NSColor *)colorValue {
    [self setColor:colorValue forParameter:CUIEffectParameterColor];
}

- (void)setColor2Value:(NSColor *)color2Value {
    [self setColor:color2Value forParameter:CUIEffectParameterColor2];
}

- (void)setOpacityValue:(CGFloat)opacityValue {
    [self setNumber:@(opacityValue) forParameter:CUIEffectParameterOpacity];
}

- (void)setOpacity2Value:(CGFloat)opacity2Value {
    [self setNumber:@(opacity2Value) forParameter:CUIEffectParameterOpacity2];
}

- (void)setOffsetValue:(NSUInteger)offsetValue {
    [self setNumber:@(offsetValue) forParameter:CUIEffectParameterOffset];
}

- (void)setBlendModeValue:(CGBlendMode)blendModeValue {
    [self setNumber:@(blendModeValue) forParameter:CUIEffectParameterBlendMode];
}

- (void)setBlurRadiusValue:(NSUInteger)blurRadiusValue {
    [self setNumber:@(blurRadiusValue) forParameter:CUIEffectParameterBlurRadius];
}

- (void)setAngleValue:(NSUInteger)angleValue {
    [self setNumber:@(angleValue) forParameter:CUIEffectParameterAngle];
}

- (void)setSoftenValue:(NSUInteger)softenValue {
    [self setNumber:@(softenValue) forParameter:CUIEffectParameterSoften];
}

- (void)setSpreadValue:(NSUInteger)spreadValue {
    [self setNumber:@(spreadValue) forParameter:CUIEffectParameterSpread];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasSuffix:@"Value"]) {
        return [NSSet setWithObject:@"parameters"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}

- (void)setNilValueForKey:(nonnull NSString *)key {
    if ([key hasSuffix:@"Value"]) {
        [self setValue:@(0) forKey:key];
    } else {
        [super setNilValueForKey:key];
    }
}

@end
