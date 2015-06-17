//
//  TKGradient.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradient.h"
#import "TKGradient+Private.h"
#import "TKGradientStop+Private.h"

#import "NSColor+CoreUI.h"
#import "TKHelpers.h"

#import "CUIPSDGradientEvaluator.h"

@interface TKGradient ()
@property (readwrite, strong) NSArray<__kindof TKGradientColorStop *> *colorStops;
@property (readwrite, strong) NSArray<__kindof TKGradientOpacityStop *> *opacityStops;

@property (strong) CUIThemeGradient *gradient;
@property (strong) CUIPSDGradientEvaluator *evaluator;

- (void)syncColorStops;
- (void)syncOpacityStops;
@end

@implementation TKGradient
@dynamic dithered, smoothingCoefficient, fillCoefficient, fillColor, blendMode;
+ (instancetype)gradientWithColorStops:(NSArray<TKGradientColorStop *> *)colorStops
                          opacityStops:(NSArray<TKGradientOpacityStop *> *)opacityStops
                colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
                                radial:(BOOL)radial
                                 angle:(CGFloat)angle
                              dithered:(BOOL)dithered {
    
    struct _psdGradientColor fill;
    fill.alpha = 0.0;
    
    
    CUIPSDGradientEvaluator *evaluator = [[TKClass(CUIPSDGradientEvaluator) alloc] initWithColorStops:[colorStops valueForKey:@"backingStop"]
                                                                                       colorMidpoints:colorMidPointLocations
                                                                                         opacityStops:[opacityStops valueForKey:@"backingStop"]
                                                                                     opacityMidpoints:opacityMidPointLocations
                                                                                 smoothingCoefficient:1.0
                                                                                      fillCoefficient:1.0];
    
    return [self gradientWithCUIGradient:[[CUIThemeGradient alloc] _initWithGradientEvaluator:evaluator
                                                                                   colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]]
                                   angle:angle
                                   style:radial ? CUIGradientStyleRadial : CUIGradientStyleLinear];
}

+ (instancetype)gradientWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style {
    return [[self alloc] initWithCUIGradient:gradient angle:angle style:style];
}

- (instancetype)initWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style {
    if ((self = [self init])) {
        self.gradient  = gradient;
        self.evaluator = TKIvar(self.gradient, CUIPSDGradientEvaluator *, gradientEvaluator);
        self.angle     = angle;
        self.radial    = style == CUIGradientStyleRadial;
        
        self.colorStops   = [NSMutableArray array];
        self.opacityStops = [NSMutableArray array];
        
        for (CUIPSDGradientColorStop *colorStop in self.evaluator.colorStops) {
            [(NSMutableArray *)self.colorStops addObject:[TKGradientColorStop gradientStopWithCUIPSDGradientStop:colorStop]];
        }
        
        for (CUIPSDGradientOpacityStop *opacityStop in self.evaluator.opacityStops) {
            [(NSMutableArray *)self.opacityStops addObject:[TKGradientColorStop gradientStopWithCUIPSDGradientStop:opacityStop]];
        }
        
        self.colorMidpoints = self.evaluator.colorMidpointLocations.mutableCopy;
        self.opacityMidpoints = self.evaluator.opacityMidpointLocations.mutableCopy;
    }
    
    return self;
}

- (void)resetShaders {
    CGFunctionRef *shader = &TKIvar(self.gradient, CGFunctionRef, colorShader);
    if (shader != NULL && *shader != NULL) {
        CGFunctionRelease(*shader);
        *shader = NULL;
    }
    
    [self syncColorStops];
    [self syncOpacityStops];
}

- (void)syncColorStops {
    [self.evaluator setColorStops:[self.colorStops valueForKey:TKKey(backingStop)]
                        midpoints:_colorMidpoints];
}

- (void)syncOpacityStops {
    [self.evaluator setOpacityStops:[self.opacityStops valueForKey:TKKey(backingStop)]
                          midpoints:_opacityMidpoints];
}

#pragma mark - Stop Management

- (void)addColorStopsObject:(TKGradientColorStop *)object {
    [self insertObject:object inColorStopsAtIndex:self.colorStops.count];
}

- (void)insertObject:(TKGradientColorStop *)object inColorStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorStops insertObject:object atIndex:index];
    [self syncColorStops];
}

- (void)addColorMidpointsObject:(NSNumber *)object {
    [self insertObject:object inOpacityMidpointsAtIndex:self.colorMidpoints.count];
}

- (void)insertObject:(NSNumber *)object inColorMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorMidpoints insertObject:object atIndex:index];
    [self syncColorStops];;
}

- (void)removeColorStopsObject:(TKGradientColorStop *)object {
    [self removeObjectFromColorStopsAtIndex:[self.colorStops indexOfObject:object]];
}

- (void)removeObjectFromColorStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorStops removeObjectAtIndex:index];
    [self syncColorStops];
}

- (void)removeColorMidpointsObject:(NSNumber *)object {
    [self removeObjectFromColorMidpointsAtIndex:[self.colorMidpoints indexOfObject:object]];
}

- (void)removeObjectFromColorMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorMidpoints removeObjectAtIndex:index];
    [self syncColorStops];
}

- (void)addOpacityStopsObject:(TKGradientOpacityStop *)object {
    [self insertObject:object inOpacityStopsAtIndex:self.opacityStops.count];
}

- (void)insertObject:(TKGradientOpacityStop *)object inOpacityStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityStops insertObject:object atIndex:index];
    [self syncOpacityStops];
}

- (void)addOpacityMidpointsObject:(NSNumber *)object {
    [self insertObject:object inOpacityMidpointsAtIndex:self.opacityMidpoints.count];
}

- (void)insertObject:(NSNumber *)object inOpacityMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityMidpoints insertObject:object atIndex:index];
    [self syncOpacityStops];
}

- (void)removeOpacityStopsObject:(TKGradientOpacityStop *)object {
    [self removeObjectFromOpacityStopsAtIndex:[self.opacityStops indexOfObject:object]];
}

- (void)removeObjectFromOpacityStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityStops removeObjectAtIndex:index];
    [self syncOpacityStops];

}

- (void)removeOpacityMidpointsObject:(NSNumber *)object {
    [self removeObjectFromOpacityMidpointsAtIndex:[self.opacityMidpoints indexOfObject:object]];
}

- (void)removeObjectFromOpacityMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityMidpoints removeObjectAtIndex:index];
    [self syncOpacityStops];
}

#pragma mark - Properties

- (NSArray<NSNumber *> *)colorMidpoints {
    return self.evaluator.colorMidpointLocations;
}

- (void)setColorMidpoints:(NSArray<NSNumber *> *)colorMidpoints {
    _colorMidpoints = colorMidpoints;
    [self syncColorStops];
}

- (NSArray<NSNumber *> *)opacityMidpoints {
    return self.evaluator.opacityMidpointLocations;
}

- (void)setOpacityMidpoints:(NSArray<NSNumber *> *)opacityMidpoints {
    _opacityMidpoints = opacityMidpoints;
    [self syncOpacityStops];
}

- (BOOL)isDithered {
    return self.evaluator.isDithered;
}

- (void)setDithered:(BOOL)dithered {
    struct _pgeFlags *flags = (struct _pgeFlags *)TKIvarPointer(self.evaluator, "pgeFlags");
    flags->isDithered = dithered;
}

- (CGFloat)smoothingCoefficient {
    return self.evaluator.smoothingCoefficient;
}

- (void)setSmoothingCoefficient:(CGFloat)smoothingCoefficient {
    [self.evaluator setSmoothingCoefficient:smoothingCoefficient];
}

- (CGFloat)fillCoefficient {
    return self.evaluator.fillCoefficient;
}

- (void)setFillCoefficient:(CGFloat)fillCoefficient {
    [self.evaluator setFillCoefficient:fillCoefficient];
}

- (NSColor *)fillColor {
    return [NSColor colorWithPSDColor:self.evaluator.fillColor];
}

- (void)setFillColor:(NSColor *)fillColor {
    struct _psdGradientColor *psdColor = (struct _psdGradientColor *)TKIvarPointer(self.evaluator, "fillColor");
    [fillColor getPSDColor:psdColor];
}

- (CGBlendMode)blendMode {
    return self.evaluator.blendMode;
}

- (void)setBlendMode:(CGBlendMode)blendMode {
    self.evaluator.blendMode = blendMode;
}

#pragma mark - Drawing

- (NSColor *)interpolatedColorAtLocation:(CGFloat)location {
    return [NSColor colorWithCUIColor: [self.gradient interpolatedColorAtLocation:location]];
}

- (void)drawInRect:(CGRect)rect {
    [self drawInRect:rect withContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition {
    [self drawInRect:rect relativeCenterPosition:relativeCenterPosition withContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (void)drawInRect:(CGRect)rect withContext:(CGContextRef)context {
    if (self.isRadial) {
        [self drawInRect:rect relativeCenterPosition:CGPointMake(0.5, 0.5) withContext:context];
    } else {
        [self.gradient drawInRect:rect angle:self.angle withContext:context];
    }
}

- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition withContext:(CGContextRef)context {
    if (self.isRadial) {
        [self.gradient drawRadialGradientInRect:rect relativeCenterPosition:relativeCenterPosition withContext:context];
        
    } else {
        [NSException raise:@"Invalid Target" format:@"You tried to draw a non-radial gradient with a relative center position."];
    }
}

@end
