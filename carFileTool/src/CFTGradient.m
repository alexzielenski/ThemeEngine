//
//  CFTGradient.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradient.h"
#import "CUIPSDGradient.h"
#import "CUIPSDGradientEvaluator.h"
#import "CUIPSDGradientColorStop.h"
#import "CUIColor.h"
#import <objc/runtime.h>

static CUIPSDGradient *psdGradientFromThemeGradient(CUIThemeGradient *themeGradient, double angle, unsigned int style) {
    if (!themeGradient)
        return nil;
    
    CUIPSDGradientEvaluator *evaluator = [themeGradient valueForKey:@"gradientEvaluator"];
    return [[CUIPSDGradient alloc] initWithEvaluator:evaluator drawingAngle:angle gradientStyle:style];
}

static BOOL gradientsEqual(CUIThemeGradient *themeGradient, CUIPSDGradient *psd) {
    CUIPSDGradientEvaluator *evaluator = [themeGradient valueForKey:@"gradientEvaluator"];
    return psd.evaluator == evaluator;
}

static CUIPSDGradientEvaluator *evaluatorFromGradient(CUIThemeGradient *gradient) {
    Ivar var = class_getInstanceVariable([CUIThemeGradient class], "gradientEvaluator");
    CUIPSDGradientEvaluator *evaluator = *(CUIPSDGradientEvaluator *__unsafe_unretained*)((__bridge void *)gradient + ivar_getOffset(var));
    return evaluator;
}

@interface CFTGradient ()
@property (readwrite, assign) CGFloat angle;
@property (readwrite, assign, getter=isRadial) BOOL radial;
@property (readonly, strong) CUIPSDGradient *psdGradient;
@property (readwrite, strong) CUIThemeGradient *themeGradient;
@property (readwrite, weak) CUIPSDGradientEvaluator *evaluator;
@end

@implementation CFTGradient
@dynamic psdGradient, colorStops, opacityStops, colorLocations, opacityLocations, fillColor, dithered;

+ (instancetype)gradientWithColors:(NSArray *)colors colorlocations:(NSArray *)colorLocations colorMidpoints:(NSArray *)colorMidpoints opacities:(NSArray *)opacities opacityLocations:(NSArray *)opacityLocations opacityMidpoints:(NSArray *)opacityMidpints smoothingCoefficient:(CGFloat)smoothing fillColor:(NSColor *)fillColor angle:(CGFloat)angle radial:(BOOL)radial dither:(BOOL)dither {
    return [[self alloc] initWithColors:colors
                         colorlocations:colorLocations
                         colorMidpoints:colorMidpoints
                              opacities:opacities
                       opacityLocations:opacityLocations
                       opacityMidpoints:opacityMidpints
                   smoothingCoefficient:smoothing
                              fillColor:fillColor
                                  angle:angle
                                 radial:radial
                                 dither:dither];
}

- (instancetype)initWithColors:(NSArray *)colors colorlocations:(NSArray *)colorLocations colorMidpoints:(NSArray *)colorMidpoints opacities:(NSArray *)opacities opacityLocations:(NSArray *)opacityLocations opacityMidpoints:(NSArray *)opacityMidpints smoothingCoefficient:(CGFloat)smoothing fillColor:(NSColor *)fillColor angle:(CGFloat)angle radial:(BOOL)radial dither:(BOOL)dither {

    if ((self = [self init])) {
        if (colors.count == 0)
            return nil;

        NSMutableArray *cgColors = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < colors.count; idx++) {
            NSColor *color = colors[idx];
            [cgColors addObject:[CUIColor colorWithCGColor:[color CGColor]]];
        }
        self.angle = angle;
        self.radial = radial;
        
        self.themeGradient = [[CUIThemeGradient alloc] initWithColors:cgColors
                                                       colorlocations:colorLocations
                                                       colorMidpoints:colorMidpoints
                                                            opacities:opacities
                                                     opacityLocations:opacityLocations
                                                     opacityMidpoints:opacityMidpints
                                                 smoothingCoefficient:smoothing
                                                            fillColor:[CUIColor colorWithCGColor:[fillColor CGColor]]
                                                           colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]];
        self.evaluator = evaluatorFromGradient(self.themeGradient);
    }
    
    return self;
}

+ (instancetype)gradientWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style {
    return [[self alloc] initWithThemeGradient:gradient angle:angle style:style];
}

- (instancetype)initWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style {
    if (!gradient)
        return nil;
    
    if ((self = [self init])) {
        self.angle = angle;

        //!TODO verify this
        self.radial = style == 1;
        self.themeGradient = gradient;
        self.evaluator = evaluatorFromGradient(self.themeGradient);
    }
    
    return self;
}

- (BOOL)isEqualToThemeGradient:(CUIThemeGradient *)themeGradient {
    return gradientsEqual(themeGradient, self.psdGradient);
}

- (CUIThemeGradient *)themeGradientRepresentation {
    return self.themeGradient;
}

- (CUIPSDGradient *)psdGradient {
    //!TODO verify radial
    return [[CUIPSDGradient alloc] initWithEvaluator:self.evaluator drawingAngle:self.angle gradientStyle:self.radial];
}

- (NSGradient *)gradientRepresentation {
    NSArray *colorLocations = self.colorLocations;
    CGFloat *locations = malloc(sizeof(CGFloat) * colorLocations.count);
    for (NSUInteger x = 0; x < colorLocations.count; x++)
        locations[x] = [colorLocations[x] doubleValue];
    return [[NSGradient alloc] initWithColors:self.colorStops
                                  atLocations:locations
                                   colorSpace:[NSColorSpace sRGBColorSpace]];
}

#pragma mark - Properties

- (NSArray *)colorStops {
    NSArray *colorStops = self.themeGradient.colorStops;
    NSMutableArray *clrs = [NSMutableArray array];
    for (NSUInteger x = 0; x < colorStops.count; x++) {
        CUIColor *color = colorStops[x];
        [clrs addObject:[NSColor colorWithCGColor:color.CGColor]];
    }

    return clrs;
}

- (NSArray *)colorLocations {
    return self.themeGradient.colorLocations;
}

- (NSArray *)colorMidpoints {
    return self.evaluator.colorMidpointLocations;
}

- (NSArray *)opacityStops {
    return self.themeGradient.opacityStops;
}

- (NSArray *)opacityLocations {
    return self.themeGradient.opacityLocations;
}

- (NSArray *)opacityMidpoints {
    return self.evaluator.opacityMidpointLocations;
}

- (NSColor *)fillColor {
    return [NSColor colorWithCGColor:self.themeGradient.fillColor.CGColor];
}

- (BOOL)isDithered {
    return self.themeGradient.isDithered;
}

@end
