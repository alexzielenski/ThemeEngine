//
//  TKGradient.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradient.h"
#import "TKGradient+Private.h"
#import "NSColor+CoreUI.h"
#import "TKHelpers.h"
#import "TKGradientStop+Private.h"

@interface TKGradient ()
@property (readwrite, strong) NSSet<__kindof TKGradientColorStop *> *colorStops;
@property (readwrite, strong) NSSet<__kindof TKGradientOpacityStop *> *opacityStops;
@property (readwrite, strong) NSSet<NSNumber *> *colorMidpoints;
@property (readwrite, strong) NSSet<NSNumber *> *opacityMidpoints;

@property (strong) CUIThemeGradient *gradient;
@property (strong) CUIPSDGradientEvaluator *evaluator;
@end

@implementation TKGradient
@dynamic dithered, smoothingCoefficient, fillCoefficient, fillColor, blendMode;
+ (instancetype)gradientWithColorStops:(NSSet<TKGradientColorStop *> *)colorStops
                          opacityStops:(NSSet<TKGradientOpacityStop *> *)opacityStops
                colorMidPointLocations:(NSSet<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSSet<NSNumber *> *)opacityMidPointLocations
                                radial:(BOOL)radial
                                 angle:(CGFloat)angle
                              dithered:(BOOL)dithered {
    
    return nil;
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
        
        
    }
    
    return self;
}

- (void)resetShaders {
    CGFunctionRef *shader = &TKIvar(self.gradient, CGFunctionRef, colorShader);
    if (shader != NULL && *shader != NULL) {
        CGFunctionRelease(*shader);
        *shader = NULL;
    }
}

#pragma mark - Stop Management

- (void)addColorStopsObject:(TKGradientColorStop *)object {
    [(NSMutableSet *)self.colorStops addObject:object];
    [self.evaluator setColorStops:[self.colorStops valueForKey:TKKey(backingStop)]
                        midpoints:self.colorMidpoints.allObjects];
}

- (void)addColorMidpointsObject:(NSNumber *)object {
    [(NSMutableSet *)self.colorMidpoints addObject:object];
    [self.evaluator setColorStops:[self.colorStops valueForKey:TKKey(backingStop)]
                        midpoints:self.colorMidpoints.allObjects];
}

- (void)removeColorStopsObject:(TKGradientColorStop *)object {
    [(NSMutableSet *)self.colorStops removeObject:object];
    [self.evaluator setColorStops:[self.colorStops valueForKey:TKKey(backingStop)]
                        midpoints:self.colorMidpoints.allObjects];
}

- (void)removeColorMidpointsObject:(NSNumber *)object {
    [(NSMutableSet *)self.colorMidpoints removeObject:object];
    [self.evaluator setColorStops:[self.colorStops valueForKey:TKKey(backingStop)]
                        midpoints:self.colorMidpoints.allObjects];
}

- (void)addOpacityStopsObject:(TKGradientOpacityStop *)object {
    [(NSMutableSet *)self.opacityStops addObject:object];
    [self.evaluator setOpacityStops:[self.opacityMidpoints valueForKey:TKKey(backingStop)]
                          midpoints:self.opacityMidpoints.allObjects];
}

- (void)addOpacityMidpointsObject:(NSNumber *)object {
    [(NSMutableSet *)self.opacityMidpoints addObject:object];
    [self.evaluator setOpacityStops:[self.opacityMidpoints valueForKey:TKKey(backingStop)]
                          midpoints:self.opacityMidpoints.allObjects];
}

- (void)removeOpacityStopsObject:(TKGradientOpacityStop *)object {
    [(NSMutableSet *)self.opacityStops removeObject:object];
    [self.evaluator setOpacityStops:[self.opacityMidpoints valueForKey:TKKey(backingStop)]
                          midpoints:self.opacityMidpoints.allObjects];
}

- (void)removeOpacityMidpointsObject:(NSNumber *)object {
    [(NSMutableSet *)self.opacityMidpoints removeObject:object];
    [self.evaluator setOpacityStops:[self.opacityMidpoints valueForKey:TKKey(backingStop)]
                          midpoints:self.opacityMidpoints.allObjects];
}

#pragma mark - Properties

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
    return PSDColorToNSColor(self.evaluator.fillColor);
}

- (void)setFillColor:(NSColor *)fillColor {
    struct _psdGradientColor *psdColor = (struct _psdGradientColor *)TKIvarPointer(self.evaluator, "fillColor");
    NSColorToPSDColor(fillColor, psdColor);
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
