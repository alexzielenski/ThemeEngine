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
                  smoothingCoefficient:(CGFloat)smoothing
                       fillCoefficient:(CGFloat)fill {
    
    return [[self alloc] initWithColorStops:colorStops opacityStops:opacityStops
                     colorMidPointLocations:colorMidPointLocations
                   opacityMidPointLocations:opacityMidPointLocations
                                     radial:radial
                                      angle:angle
                       smoothingCoefficient:smoothing
                            fillCoefficient:fill];
}

- (instancetype)initWithColorStops:(NSArray<TKGradientColorStop *> *)colorStops
                      opacityStops:(NSArray<TKGradientOpacityStop *> *)opacityStops
            colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
          opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
                            radial:(BOOL)radial
                             angle:(CGFloat)angle
              smoothingCoefficient:(CGFloat)smoothing
                   fillCoefficient:(CGFloat)fill {
    CUIPSDGradientEvaluator *evaluator = [[TKClass(CUIPSDGradientEvaluator) alloc] initWithColorStops:[colorStops valueForKey:@"backingStop"]
                                                                                       colorMidpoints:colorMidPointLocations
                                                                                         opacityStops:[opacityStops valueForKey:@"backingStop"]
                                                                                     opacityMidpoints:opacityMidPointLocations
                                                                                 smoothingCoefficient:smoothing
                                                                                      fillCoefficient:fill];
    CUIThemeGradient *grad = [[CUIThemeGradient alloc] _initWithGradientEvaluator:evaluator
                                                                       colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]];
    
    if ((self = [self initWithCUIGradient:grad angle:angle style:radial ? CUIGradientStyleRadial : CUIGradientStyleLinear])) {
        // reinforce this value
        // it doesnt seem to stick for some reason
        self.opacityMidpoints = opacityMidPointLocations;
    }
    
    return self;
}

+ (instancetype)gradientWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style {
    return [[self alloc] initWithCUIGradient:gradient angle:angle style:style];
}

- (instancetype)initWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style {
    if ((self = [self init])) {
        self.gradient  = gradient;
        self.evaluator = TKIvar(gradient, CUIPSDGradientEvaluator *, gradientEvaluator);
        self.angle     = angle;
        self.radial    = style == CUIGradientStyleRadial;
        
        self.colorStops   = [NSMutableArray array];
        self.opacityStops = [NSMutableArray array];
        
        for (CUIPSDGradientColorStop *colorStop in self.evaluator.colorStops) {
            TKGradientColorStop *stop = [TKGradientColorStop gradientStopWithCUIPSDGradientStop:colorStop];
            stop.gradient = self;
            [(NSMutableArray *)self.colorStops addObject:stop];
        }
        
        for (CUIPSDGradientOpacityStop *opacityStop in self.evaluator.opacityStops) {
            TKGradientOpacityStop *stop = [TKGradientOpacityStop gradientStopWithCUIPSDGradientStop:opacityStop];
            stop.gradient = self;
            [(NSMutableArray *)self.opacityStops addObject:stop];
        }
        
        self.colorMidpoints = self.evaluator.colorMidpointLocations.mutableCopy;
        self.opacityMidpoints = self.evaluator.opacityMidpointLocations.mutableCopy;
    }
    
    return self;
}

- (id)initWithCoder:(nonnull NSCoder *)coder {
    NSArray *colorStops       = [coder decodeObjectForKey:TKKey(colorStops)];
    NSArray *colorMidpoitns   = [coder decodeObjectForKey:TKKey(colorMidpoints)];
    NSArray *opacityStops     = [coder decodeObjectForKey:TKKey(opacityStops)];
    NSArray *opacityMidpoints = [coder decodeObjectForKey:TKKey(opacityMidpoints)];
    CGFloat angle             = [coder decodeDoubleForKey:TKKey(angle)];
    CGFloat smoothing         = [coder decodeDoubleForKey:TKKey(smoothingCoefficient)];
    CGFloat fill              = [coder decodeDoubleForKey:TKKey(fillCoefficient)];
    BOOL dithered             = [coder decodeBoolForKey:TKKey(isDithered)];
    BOOL radial               = [coder decodeBoolForKey:TKKey(isRadial)];
    
    if ((self = [self initWithColorStops:colorStops
                            opacityStops:opacityStops
                  colorMidPointLocations:colorMidpoitns
                opacityMidPointLocations:opacityMidpoints
                                  radial:radial
                                   angle:angle
                    smoothingCoefficient:smoothing
                         fillCoefficient:fill])) {
        self.dithered = dithered;
    }
    
    return self;
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.colorStops forKey:TKKey(colorStops)];
    [coder encodeObject:self.colorMidpoints forKey:TKKey(colorMidpoints)];
    [coder encodeObject:self.opacityStops forKey:TKKey(opacityStops)];
    [coder encodeObject:self.opacityMidpoints forKey:TKKey(opacityMidpoints)];
    [coder encodeDouble:self.angle forKey:TKKey(angle)];
    [coder encodeBool:self.isRadial forKey:TKKey(isRadial)];
    [coder encodeDouble:self.fillCoefficient forKey:TKKey(fillCoefficient)];
    [coder encodeDouble:self.smoothingCoefficient forKey:TKKey(smoothingCoefficient)];
    [coder encodeBool:self.isDithered forKey:TKKey(isDithered)];
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
    [self.evaluator setColorStops:[[self.colorStops valueForKey:TKKey(backingStop)] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]]
                        midpoints:_colorMidpoints];
}

- (void)syncOpacityStops {
    [self.evaluator setOpacityStops:[[self.opacityStops valueForKey:TKKey(backingStop)] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]]
                          midpoints:_opacityMidpoints];
}

- (CUIPSDGradient *)psdGradient {
    CUIPSDGradient *grad = [[CUIPSDGradient alloc] initWithEvaluator:self.evaluator
                                                        drawingAngle:self.angle
                                                       gradientStyle:self.isRadial ? CUIGradientStyleRadial : CUIGradientStyleLinear];
    
    return grad;
}

#pragma mark - Stop Management

- (void)addColorStop:(TKGradientColorStop *)object {
    [self insertObject:object inColorStopsAtIndex:self.colorStops.count];
}

- (void)insertObject:(TKGradientColorStop *)object inColorStopsAtIndex:(NSUInteger)index {
    object.gradient = self;
    [(NSMutableArray *)self.colorStops insertObject:object atIndex:index];
    [self syncColorStops];
}

- (void)addColorMidpoint:(NSNumber *)object {
    [self insertObject:object inOpacityMidpointsAtIndex:self.colorMidpoints.count];
}

- (void)insertObject:(NSNumber *)object inColorMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorMidpoints insertObject:object atIndex:index];
    [self syncColorStops];;
}

- (void)removeColorStop:(TKGradientColorStop *)object {
    [self removeObjectFromColorStopsAtIndex:[self.colorStops indexOfObject:object]];
}

- (void)removeObjectFromColorStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorStops removeObjectAtIndex:index];
    [self syncColorStops];
}

- (void)removeColorMidpoint:(NSNumber *)object {
    [self removeObjectFromColorMidpointsAtIndex:[self.colorMidpoints indexOfObject:object]];
}

- (void)removeObjectFromColorMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.colorMidpoints removeObjectAtIndex:index];
    [self syncColorStops];
}

- (void)addOpacityStop:(TKGradientOpacityStop *)object {
    [self insertObject:object inOpacityStopsAtIndex:self.opacityStops.count];
}

- (void)insertObject:(TKGradientOpacityStop *)object inOpacityStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityStops insertObject:object atIndex:index];
    [self syncOpacityStops];
}

- (void)addOpacityMidpoint:(NSNumber *)object {
    [self insertObject:object inOpacityMidpointsAtIndex:self.opacityMidpoints.count];
}

- (void)insertObject:(NSNumber *)object inOpacityMidpointsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityMidpoints insertObject:object atIndex:index];
    [self syncOpacityStops];
}

- (void)removeOpacityStop:(TKGradientOpacityStop *)object {
    [self removeObjectFromOpacityStopsAtIndex:[self.opacityStops indexOfObject:object]];
}

- (void)removeObjectFromOpacityStopsAtIndex:(NSUInteger)index {
    [(NSMutableArray *)self.opacityStops removeObjectAtIndex:index];
    [self syncOpacityStops];

}

- (void)removeOpacityMidpoint:(NSNumber *)object {
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
    [self resetShaders];
}

- (NSArray<NSNumber *> *)opacityMidpoints {
    return self.evaluator.opacityMidpointLocations;
}

- (void)setOpacityMidpoints:(NSArray<NSNumber *> *)opacityMidpoints {
    _opacityMidpoints = opacityMidpoints;
    [self resetShaders];
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

- (void)drawInRect:(CGRect)rect atAngle:(CGFloat)angle {
    [self drawInRect:rect atAngle:self.angle withContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition {
    [self drawInRect:rect relativeCenterPosition:relativeCenterPosition withContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (void)drawInRect:(CGRect)rect withContext:(CGContextRef)context {
    if (self.isRadial) {
        [self drawInRect:rect relativeCenterPosition:CGPointMake(0.5, 0.5) withContext:context];
    } else {
        [self drawInRect:rect atAngle:self.angle withContext:context];
    }
}

- (void)drawInRect:(CGRect)rect atAngle:(CGFloat)angle withContext:(CGContextRef)context {
    [self.gradient drawInRect:rect angle:angle withContext:context];
}

- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition withContext:(CGContextRef)context {
    if (self.isRadial) {
        [self.gradient drawRadialGradientInRect:rect relativeCenterPosition:relativeCenterPosition withContext:context];
        
    } else {
        [NSException raise:@"Invalid Target" format:@"You tried to draw a non-radial gradient with a relative center position."];
    }
}

@end
