//
//  CFTEffectWrapper.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTEffectWrapper.h"

@interface CFTEffectWrapper ()
@property (readwrite, strong) NSMutableArray *effects;
@end

@implementation CFTEffectWrapper
@dynamic effectPreset;

+ (instancetype)effectWrapper {
    return [[self alloc] init];
}

+ (instancetype)effectWrapperWithEffectPreset:(CUIShapeEffectPreset *)preset {
    return [[self alloc] initWithEffectPreset:preset];
}

- (instancetype)initWithEffectPreset:(CUIShapeEffectPreset *)preset {
    if (!preset) {
        return nil;
    }
    if ((self = [self init])) {
        unsigned long long count = preset.effectCount;
        for (unsigned long long x = 0; x < count; x++) {
            CUIEffectTuple *tuples = NULL;
            unsigned long long tupleCount = 0;
            [preset getEffectTuples:&tuples count:&tupleCount atEffectIndex:x];
            [self addEffect:[CFTEffect effectWithEffectTuples:tuples count:tupleCount]];
        }
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.effects = [NSMutableArray array];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    CFTEffectWrapper *wrapper = [[CFTEffectWrapper alloc] init];
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        [wrapper insertEffect:[self.effects[x] copy] atIndex:x];
    }
    return wrapper;
}

- (BOOL)isEqual:(CFTEffectWrapper *)object {
    return [self.effects isEqualToArray:object.effects];
}

- (void)addEffect:(CFTEffect *)effect {
    [self insertEffect:effect atIndex:self.effects.count];
}

- (void)insertEffect:(CFTEffect *)effect atIndex:(NSUInteger)index {
    if (self.effects.count > 7)
        return;
    
    [self.effectPreset willChange:NSKeyValueChangeInsertion
                  valuesAtIndexes:[NSIndexSet indexSetWithIndex:index]
                           forKey:@"effects"];
    [self.effects insertObject:effect atIndex:index];
    [self.effectPreset didChange:NSKeyValueChangeInsertion
                 valuesAtIndexes:[NSIndexSet indexSetWithIndex:index]
                          forKey:@"effects"];
}

- (void)removeEffect:(CFTEffect *)effect {
    [self.effects removeObjectAtIndex:[self.effects indexOfObject:effect]];
}

- (void)removeEffectAtIndex:(NSUInteger)index {
    [self.effects willChange:NSKeyValueChangeRemoval
             valuesAtIndexes:[NSIndexSet indexSetWithIndex:index]
                      forKey:@"effects"];
    [self.effects removeObjectAtIndex:index];
    [self.effects didChange:NSKeyValueChangeRemoval
            valuesAtIndexes:[NSIndexSet indexSetWithIndex:index]
                     forKey:@"effects"];
}

- (void)moveEffectAtIndex:(NSUInteger)index toIndex:(NSUInteger)destination {
    __strong CFTEffect *effect = self.effects[index];

    if (index < destination)
        destination--;

    [self.effects removeObjectAtIndex:index];

    if (destination > self.effects.count)
        destination = self.effects.count;

    [self.effects insertObject:effect atIndex:destination];
}

- (CUIShapeEffectPreset *)effectPreset {
    CUIShapeEffectPreset *preset = [[CUIShapeEffectPreset alloc] init];
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        CFTEffect *effect = self.effects[x];
        NSArray *keys = [effect.parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
        for (NSNumber *key in keys) {
            CUIEffectParameter parameter = (CUIEffectParameter)key.integerValue;
            NSNumber *value = effect.parameters[@(parameter)];
            
            CUIEffectTuple tuple;
            tuple.effectType = effect.type;
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
    
    return preset;
}

+ (NSSet *)keyPathsForValuesAffectingEffectPreset {
    return [NSSet setWithObject:@"effects"];
}

@end
