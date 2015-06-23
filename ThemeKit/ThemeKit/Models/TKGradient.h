//
//  TKGradient.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKGradientStop.h>

// Specialized gradient class for CoreUI gradients
// that have bonus features
@interface TKGradient : NSObject <NSCoding> {
    NSArray<NSNumber *> *_colorMidpoints;
    NSArray<NSNumber *> *_opacityMidpoints;
}

@property (assign, getter=isRadial) BOOL radial;
@property (assign) CGFloat angle;
@property (assign, getter=isDithered) BOOL dithered;
@property (assign) CGFloat smoothingCoefficient;
@property (assign) CGFloat fillCoefficient;
@property (strong) NSColor *fillColor;
@property (assign) CGBlendMode blendMode;

@property (readonly, strong) NSArray<__kindof TKGradientColorStop *> *colorStops;
@property (readonly, strong) NSArray<__kindof TKGradientOpacityStop *> *opacityStops;

// List of midpoints between stops. These should be ordered not related to the colorStops array
// but in order of stop location
// e.g. if you have 3 colorstops at locations, 0.5, 0, and 1.0
// midpoints @[ 0.5, 0.25 ] would have a midpoint at 0.5 between stops at 0 and 0.5, and midpoint 0.25 between
// stops at 0.5 and 1.0
@property (nonatomic, strong) NSArray<NSNumber *> *colorMidpoints;
@property (nonatomic, strong) NSArray<NSNumber *> *opacityMidpoints;

+ (instancetype)gradientWithColorStops:(NSArray<TKGradientColorStop *> *)colorStops
                          opacityStops:(NSArray<TKGradientOpacityStop *> *)opacityStops
                colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
                                radial:(BOOL)radial
                                 angle:(CGFloat)angle
                  smoothingCoefficient:(CGFloat)smoothing
                       fillCoefficient:(CGFloat)fill;

- (instancetype)initWithColorStops:(NSArray<TKGradientColorStop *> *)colorStops
                      opacityStops:(NSArray<TKGradientOpacityStop *> *)opacityStops
            colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
          opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
                            radial:(BOOL)radial
                             angle:(CGFloat)angle
              smoothingCoefficient:(CGFloat)smoothing
                   fillCoefficient:(CGFloat)fill;

- (NSColor *)interpolatedColorAtLocation:(CGFloat)location;

- (void)addColorStop:(TKGradientColorStop *)object;
- (void)addColorMidpoint:(NSNumber *)object;

- (void)removeColorStop:(TKGradientColorStop *)object;
- (void)removeColorMidpoint:(NSNumber *)object;

- (void)addOpacityStop:(TKGradientOpacityStop *)object;
- (void)addOpacityMidpoint:(NSNumber *)object;

- (void)removeOpacityStop:(TKGradientOpacityStop *)object;
- (void)removeOpacityMidpoint:(NSNumber *)object;

// Purely for KVC compliance
- (void)insertObject:(TKGradientColorStop *)object inColorStopsAtIndex:(NSUInteger)index;
- (void)insertObject:(NSNumber *)object inColorMidpointsAtIndex:(NSUInteger)index;
- (void)insertObject:(TKGradientOpacityStop *)object inOpacityStopsAtIndex:(NSUInteger)index;
- (void)insertObject:(NSNumber *)object inOpacityMidpointsAtIndex:(NSUInteger)index;

- (void)removeObjectFromColorStopsAtIndex:(NSUInteger)index;
- (void)removeObjectFromColorMidpointsAtIndex:(NSUInteger)index;
- (void)removeObjectFromOpacityStopsAtIndex:(NSUInteger)index;
- (void)removeObjectFromOpacityMidpointsAtIndex:(NSUInteger)index;

// Radial gradients assume a relative center position in the middle of the rectangle
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect atAngle:(CGFloat)angle;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition;
- (void)drawInRect:(CGRect)rect withContext:(CGContextRef)contex;
- (void)drawInRect:(CGRect)rect atAngle:(CGFloat)angle withContext:(CGContextRef)contex;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition withContext:(CGContextRef)contex;

@end
