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

@interface TKGradient ()
@property (strong) CUIThemeGradient *gradient;
@end

@implementation TKGradient

+ (instancetype)gradientWithColorStops:(NSArray *)colorStops
                          opacityStops:(NSArray *)opacityStops
                colorMidPointLocations:(NSArray<NSNumber *> *)colorMidPointLocations
              opacityMidPointLocations:(NSArray<NSNumber *> *)opacityMidPointLocations
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
        self.gradient = gradient;
        self.angle = angle;
        self.radial = style == CUIGradientStyleRadial;
    }
    
    return self;
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
