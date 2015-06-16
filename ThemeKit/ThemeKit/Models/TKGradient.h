//
//  TKGradient.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

// Specialized gradient class for CoreUI gradients
// that have bonus features
@interface TKGradient : NSObject
@property (assign, getter=isRadial) BOOL radial;
@property (assign) CGFloat angle;
@property (assign, getter=isDithered) BOOL dithered;
@property (assign) CGFloat smoothingCoefficient;
@property (assign) CGFloat fillCoefficient;

+ (instancetype)gradientWithColorStops:(NSArray *)colorStops
                          opacityStops:(NSArray *)opacityStops
                colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
                                radial:(BOOL)radial
                                 angle:(CGFloat)angle
                              dithered:(BOOL)dithered;

- (NSColor *)interpolatedColorAtLocation:(CGFloat)location;

// Radial gradients assume a relative center position in the middle of the rectangle
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition;
- (void)drawInRect:(CGRect)rect withContext:(CGContextRef)contex;
- (void)drawInRect:(CGRect)rect relativeCenterPosition:(CGPoint)relativeCenterPosition withContext:(CGContextRef)contex;

@end
