//
//  CFTGradient.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUIThemeGradient.h"

/***
 CoreUI Gradient Format
 **/

// 80 bytes
struct gradient_header {
    unsigned int magic; // 'GRAD'
    unsigned int is_dithered;
    unsigned int info_length; // color + opacity stops, midpoints
    unsigned int style; // 'Lnr' or 'Rdl'
    unsigned int version; // hardcoded to always be 2. guessing its a version
    unsigned int blendmode; // CGBlendMode
    struct {
        double r;
        double b;
        double g;
        double a;
    } fill_color;
    float angle; // degrees
    float smoothing_coefficient;
    unsigned int num_color_stops;
    unsigned int num_color_midpoint_locations;
    unsigned int num_opacity_stops;
    unsigned int num_opacity_midpoint_locations;
};

// List of color stops, color midpoint locations, opacity stops, opacity midpoint locations

// 72 bytes
struct gradient_stop {
    unsigned int magic; // OPCT, MDPT, COLR, OPCD (lead out opacity)
    float location;
    double r;
    double b;
    double g;
    double a; // for COLR, alpha is always 1.0
    char reserved[32]; // could be used for leadout colors which I haven't been able to get data for
};

@interface CFTGradient : NSObject
@property (strong) NSArray *colorStops;
@property (strong) NSArray *opacityStops;
@property (strong) NSArray *colorLocations;
@property (strong) NSArray *opacityLocations;
@property (strong) NSColor *fillColor;
@property (strong) NSArray *colorMidpoints;
@property (strong) NSArray *opacityMidpoints;
@property (assign) CGFloat angle;
@property (assign, getter=isRadial) BOOL radial;
@property (assign, getter=isDithered) BOOL dithered;

+ (instancetype)gradientWithColors:(NSArray *)colors colorlocations:(NSArray *)colorLocations colorMidpoints:(NSArray *)colorMidpoints opacities:(NSArray *)opacities opacityLocations:(NSArray *)opacityLocations opacityMidpoints:(NSArray *)opacityMidpints smoothingCoefficient:(CGFloat)smoothing fillColor:(NSColor *)fillColor angle:(CGFloat)angle radial:(BOOL)radial dither:(BOOL)dither;

- (instancetype)initWithColors:(NSArray *)colors colorlocations:(NSArray *)colorLocations colorMidpoints:(NSArray *)colorMidpoints opacities:(NSArray *)opacities opacityLocations:(NSArray *)opacityLocations opacityMidpoints:(NSArray *)opacityMidpints smoothingCoefficient:(CGFloat)smoothing fillColor:(NSColor *)fillColor angle:(CGFloat)angle radial:(BOOL)radial dither:(BOOL)dither;

+ (instancetype)gradientWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style;
- (instancetype)initWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style;

- (NSGradient *)gradientRepresentation;
@property (readwrite, strong) CUIThemeGradient *themeGradient;

@end
