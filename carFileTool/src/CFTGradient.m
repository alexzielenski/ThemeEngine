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
#import "CUIPSDGradientDoubleColorStop.h"
#import "CUIPSDGradientDoubleOpacityStop.h"
#import "CUIColor.h"
#import "ZKSwizzle.h"

static CUIPSDGradientEvaluator *evaluatorFromGradient(CUIThemeGradient *gradient) {
    return ZKHookIvar(gradient, CUIPSDGradientEvaluator *, "gradientEvaluator");
}

@interface CFTGradient ()
@property (readonly, strong) CUIPSDGradient *psdGradient;
@property (readonly, weak) CUIPSDGradientEvaluator *evaluator;
@end

@implementation CFTGradient
@dynamic psdGradient, colorStops, opacityStops, colorLocations, opacityLocations, fillColor, dithered, evaluator, smoothingCoefficient;

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
                                                           colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]
                                                               dither:dither];
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
        self.radial = style == CUIGradientStyleRadial;
        self.themeGradient = gradient;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class alloc] initWithColors:self.colorStops
                               colorlocations:self.colorLocations
                               colorMidpoints:self.colorMidpoints
                                    opacities:self.opacityStops
                             opacityLocations:self.opacityLocations
                             opacityMidpoints:self.opacityMidpoints
                         smoothingCoefficient:self.smoothingCoefficient
                                    fillColor:self.fillColor
                                        angle:self.angle
                                       radial:self.isRadial
                                       dither:self.isDithered];
}

- (CUIPSDGradientEvaluator *)evaluator {
    return evaluatorFromGradient(self.themeGradient);
}

- (CUIPSDGradient *)psdGradient {
    return [[CUIPSDGradient alloc] initWithEvaluator:self.evaluator
                                        drawingAngle:self.angle
                                       gradientStyle:self.radial ? CUIGradientStyleRadial : CUIGradientStyleLinear];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@%@%@:%d:%f:%f", self.evaluator.colorStops, self.evaluator.colorMidpointLocations, self.evaluator.opacityStops, self.evaluator.opacityMidpointLocations, self.evaluator.isDithered, self.evaluator.smoothingCoefficient, self.evaluator.fillCoefficient];
}

#pragma mark - Properties

- (NSArray *)colorStops {
    NSArray *colorStops = self.evaluator.colorStops;
    NSMutableArray *clrs = [NSMutableArray array];
    for (NSUInteger x = 0; x < colorStops.count; x++) {
        CUIPSDGradientColorStop *stop = colorStops[x];
        
        [clrs addObject:[NSColor colorWithRed:stop.gradientColor.red
                                        green:stop.gradientColor.green
                                         blue:stop.gradientColor.blue
                                        alpha:stop.gradientColor.alpha]];
    }

    return clrs;
}

- (NSArray *)colorLocations {
    return [self.evaluator.colorStops valueForKey:@"location"];
}

- (NSArray *)colorMidpoints {
    return self.evaluator.colorMidpointLocations;
}

- (NSArray *)opacityStops {
    NSArray *opacityStops = self.evaluator.opacityStops;
    NSMutableArray *opacities = [NSMutableArray array];
    for (NSUInteger x = 0; x < opacityStops.count; x++) {
        CUIPSDGradientOpacityStop *stop = opacityStops[x];
        [opacities addObject:@(stop.opacity)];
    }
    return opacities;
}

- (NSArray *)opacityLocations {
    return [self.evaluator.opacityStops valueForKey:@"location"];
}

- (NSArray *)opacityMidpoints {
    return self.evaluator.opacityMidpointLocations;
}

- (NSColor *)fillColor {
    return [NSColor colorWithCGColor:self.themeGradient.fillColor.CGColor];
}

- (CGFloat)smoothingCoefficient {
    return self.evaluator.smoothingCoefficient;
}

- (BOOL)isDithered {
    _gradientFlags pgeFlags = ZKHookIvar(self.evaluator, _gradientFlags, "pgeFlags");
    return pgeFlags.isDithered;
}

- (void)setColorStops:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < colors.count; idx++) {
        NSColor *color = [colors[idx] colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        CGFloat location = 0.0;
        if (idx < self.evaluator.colorStops.count)
            location = [self.evaluator.colorStops[idx] location];
        struct _psdGradientColor psd;
        psd.red = color.redComponent;
        psd.green = color.greenComponent;
        psd.blue = color.blueComponent;
        psd.alpha = color.alphaComponent;
        CUIPSDGradientColorStop *stop = [CUIPSDGradientColorStop colorStopWithLocation:location
                                                                         gradientColor:psd];
        [cgColors addObject:stop];
    }

    NSArray *__unsafe_unretained*colorStops = &ZKHookIvar(self.evaluator, NSArray *, "colorStops");
    if (*colorStops)
        AntiARCRelease(*colorStops);
    AntiARCRetain(cgColors);
    *colorStops = cgColors;
}

- (void)setColorMidpoints:(NSArray *)colorMidpoints {
    NSArray *__unsafe_unretained*midpoints = &ZKHookIvar(self.evaluator, NSArray *, "colorMidpointLocations");
    if (*midpoints)
        AntiARCRelease(*midpoints);
    AntiARCRetain(colorMidpoints);
    *midpoints = colorMidpoints;
}

- (void)setColorLocations:(NSArray *)colorLocations {
    if (colorLocations.count != self.evaluator.colorStops.count) {
        NSLog(@"Invalid number of color locations. Must be equal to color stops");
        return;
    }
    
    for (NSUInteger x = 0; x < colorLocations.count; x++ ) {
        CUIPSDGradientStop *stop = self.evaluator.colorStops[x];
        stop.location = [colorLocations[x] doubleValue];
    }
}

- (void)setDithered:(BOOL)dithered {
    _gradientFlags *pgeFlags = &ZKHookIvar(self.evaluator, _gradientFlags, "pgeFlags");
    pgeFlags->isDithered = dithered;
}

- (void)setSmoothingCoefficient:(CGFloat)smoothingCoefficient {
    double *original = &ZKHookIvar(self.evaluator, double, "smoothingCoefficient");
    *original = smoothingCoefficient;
}

- (void)setOpacityStops:(NSArray *)opacityStops {
    NSMutableArray *stops = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < opacityStops.count; idx++) {
        NSNumber *opacity  = opacityStops[idx];
        CGFloat location = 0.0;
        if (idx < self.evaluator.opacityStops.count)
            location = [self.evaluator.opacityStops[idx] location];
        CUIPSDGradientOpacityStop *stop = [CUIPSDGradientOpacityStop opacityStopWithLocation:location opacity:opacity.doubleValue];
        [stops addObject:stop];
    }
    
    NSArray *__unsafe_unretained*origStops = &ZKHookIvar(self.evaluator, NSArray *, "opacityStops");
    if (*origStops)
        AntiARCRelease(*origStops);
    AntiARCRetain(opacityStops);
    *origStops = opacityStops;
}

- (void)setOpacityLocations:(NSArray *)opacityLocations {
    if (opacityLocations.count != self.evaluator.opacityStops.count) {
        NSLog(@"Invalid number of opacity locations. Must be equal to opacity stops");
        return;
    }
    
    for (NSUInteger x = 0; x < opacityLocations.count; x++) {
        CUIPSDGradientStop *stop = self.evaluator.opacityStops[x];
        stop.location = [opacityLocations[x] doubleValue];
    }
}

- (void)setOpacityMidpoints:(NSArray *)opacityMidpoints {
    NSArray *__unsafe_unretained*midpoints = &ZKHookIvar(self.evaluator, NSArray *, "opacityMidpointLocations");
    if (*midpoints)
        AntiARCRelease(*midpoints);
    AntiARCRetain(opacityMidpoints);
    *midpoints = opacityMidpoints;
}

@end
