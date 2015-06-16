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
@interface TKGradient : NSObject
@property (assign, getter=isRadial) BOOL radial;
@property (assign) CGFloat angle;
@property (assign, getter=isDithered) BOOL dithered;
@property (assign) CGFloat smoothingCoefficient;
@property (assign) CGFloat fillCoefficient;
@property (strong) NSColor *fillColor;
@property (assign) CGBlendMode blendMode;

@property (readonly, strong) NSSet<__kindof TKGradientColorStop *> *colorStops;
@property (readonly, strong) NSSet<__kindof TKGradientOpacityStop *> *opacityStops;
@property (readonly, strong) NSSet<NSNumber *> *colorMidpoints;
@property (readonly, strong) NSSet<NSNumber *> *opacityMidpoints;

+ (instancetype)gradientWithColorStops:(NSSet<__kindof TKGradientColorStop *> *)colorStops
                          opacityStops:(NSSet<__kindof TKGradientOpacityStop *> *)opacityStops
                colorMidPointLocations:(NSSet<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSSet<NSNumber *> *)opacityMidPointLocations
                                radial:(BOOL)radial
                                 angle:(CGFloat)angle
                              dithered:(BOOL)dithered;

- (NSColor *)interpolatedColorAtLocation:(CGFloat)location;

- (void)addColorStopsObject:(TKGradientColorStop *)object;
- (void)addColorMidpointsObject:(NSNumber *)object;

- (void)removeColorStopsObject:(TKGradientColorStop *)object;
- (void)removeColorMidpointsObject:(NSNumber *)object;

- (void)addOpacityStopsObject:(TKGradientOpacityStop *)object;
- (void)addOpacityMidpointsObject:(NSNumber *)object;

- (void)removeOpacityStopsObject:(TKGradientOpacityStop *)object;
- (void)removeOpacityMidpointsObject:(NSNumber *)object;

// The gradient renderer
- (void)resetShaders;

// Radial gradients assume a relative center position in the middle of the rectangle
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition;
- (void)drawInRect:(CGRect)rect withContext:(CGContextRef)contex;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition withContext:(CGContextRef)contex;

@end
