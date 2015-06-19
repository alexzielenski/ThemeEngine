//
//  TKEffectPreset.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectPreset.h"
#import "TKEffectPreset+Private.h"
#import "TKEffect+Private.h"
@import CoreImage.CIContext;
#import <CoreUI/Rendering/CUIShapeEffectStack.h>

@interface TKEffectPreset ()
@end

@implementation TKEffectPreset
@dynamic effectPreset;

#pragma mark - Initialization

+ (instancetype)effectPreset {
    return [[self alloc] init];
}

+ (instancetype)effectPresetWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preset {
    return [[self alloc] initWithCUIShapeEffectPreset:preset];
}

- (instancetype)initWithCUIShapeEffectPreset:(CUIShapeEffectPreset *)preset {
    if (!preset) {
        return nil;
    }
    if ((self = [super init])) {
        self.scaleFactor = preset.effectScale;
        self.effects = [[TKEffect effectsWithCUIShapeEffectPreset:preset] mutableCopy];
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.effects = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Protocols

- (id)copyWithZone:(NSZone *)zone {
    TKEffectPreset *wrapper = [TKEffectPreset effectPreset];
    
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        [wrapper insertEffect:[self.effects[x] copy] atIndex:x];
    }
    
    return wrapper;
}

- (BOOL)isEqual:(TKEffectPreset *)object {
    return [self.effects isEqualToArray:object.effects];
}

#pragma mark - KVC Compliance

- (void)insertObject:(TKEffect *)object inEffectsAtIndex:(NSUInteger)index {
    if (![object isKindOfClass:[TKEffect class]]) {
        [NSException raise:@"Invalid Argument" format:@"You must pass a TKEffect into -insertEffect:atIndex:"];
    }
    
    [self.effects insertObject:object atIndex:index];
}

- (void)removeObjectFromEffectsAtIndex:(NSUInteger)index {
    [self.effects removeObjectAtIndex:index];
}

- (void)replaceObjectInEffectsAtIndex:(NSUInteger)index withObject:(TKEffect *)object {
    if (![object isKindOfClass:[TKEffect class]]) {
        [NSException raise:@"Invalid Argument" format:@"You must pass a TKEffect into -insertEffect:atIndex:"];
    }
    
    [self.effects removeObjectAtIndex:index];
    [self.effects insertObject:object atIndex:index];
}

#pragma mark - Managing Effects

- (TKEffect *)effectWithType:(CUIEffectType)type {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"type == %ld", type];
    NSArray *filtered = [self.effects filteredArrayUsingPredicate:pred];
    return filtered.firstObject;
}

- (void)addEffect:(TKEffect *)effect {
    [self insertEffect:effect atIndex:self.effects.count];
}

- (void)insertEffect:(TKEffect *)effect atIndex:(NSUInteger)index {
    [[self mutableArrayValueForKey:TKKey(effects)] insertObject:effect atIndex:index];
}

- (void)removeEffect:(TKEffect *)effect {
    [self removeEffectAtIndex:[self.effects indexOfObject:effect]];
}

- (void)removeEffectAtIndex:(NSUInteger)index {
    [[self mutableArrayValueForKey:TKKey(effects)] removeObjectAtIndex:index];
}

- (void)moveEffectAtIndex:(NSUInteger)index toIndex:(NSUInteger)destination {
    __strong TKEffect *effect = self.effects[index];
    if (index < destination)
        destination--;
    
    [[self mutableArrayValueForKey:TKKey(effects)] removeObjectAtIndex:index];
    
    if (destination > self.effects.count)
        destination = self.effects.count;
    
    [[self mutableArrayValueForKey:TKKey(effects)] insertObject:effect atIndex:destination];
}

+ (NSSet *)keyPathsForValuesAffectingEffectPreset {
    return [NSSet setWithObject:@"effects"];
}

#pragma mark - CoreUI interop
- (CUIShapeEffectPreset *)effectPreset {
    CUIShapeEffectPreset *preset = [[CUIShapeEffectPreset alloc] initWithEffectScale:self.scaleFactor];
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        TKEffect *effect = self.effects[x];
        [effect commitToPreset:preset atIndex:x];
    }
    
    return preset;
}

+ (NSBitmapImageRep *)shapeImage {
    static NSBitmapImageRep *rep = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                      pixelsWide:32
                                                      pixelsHigh:32
                                                   bitsPerSample:8
                                                 samplesPerPixel:4
                                                        hasAlpha:YES
                                                        isPlanar:NO
                                                  colorSpaceName:NSDeviceRGBColorSpace
                                                     bytesPerRow:4 * 32
                                                    bitsPerPixel:32];
        NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
        
        unichar chars[2] = { 0x41, 0x61 };
        CGGlyph glyphs[2];
        CGPoint positions[2];
        CGSize advances[2];
        
        CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-Medium"), 18.0, NULL);
        CTFontGetGlyphsForCharacters(font, chars, glyphs, 2);
        CTFontGetAdvancesForGlyphs(font, kCTFontOrientationDefault, glyphs, advances, 2);
        
        CGPoint position = CGPointZero;
        for (NSUInteger i = 0; i < 2; i++) {
            positions[i] = CGPointMake(position.x, position.y);
            CGSize advance = advances[i];
            position.x += advance.width;
            position.y += advance.height;
        }
        
        positions[0].x += rep.pixelsWide / 2 - position.x / 2;
        positions[0].y += rep.pixelsHigh / 2 - position.y / 2 - 6;
        positions[1].x += rep.pixelsWide / 2 - position.x / 2;
        positions[1].y += rep.pixelsHigh / 2 - position.y / 2 - 6;
        
        CTFontDrawGlyphs(font, glyphs, positions, 2, ctx.graphicsPort);
    });
    
    return rep;
}

- (NSBitmapImageRep *)proccesedImage:(NSBitmapImageRep *)image {
    CUIShapeEffectStack *stack = [[CUIShapeEffectStack alloc] initWithEffectPreset:self.effectPreset];
    return [[NSBitmapImageRep alloc] initWithCGImage:[stack newFlattenedImageFromShapeCGImage:image.CGImage withScale:self.scaleFactor] ?: image.CGImage];
}

@end
