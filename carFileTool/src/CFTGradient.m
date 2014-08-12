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

@interface CFTGradient ()
@property (readwrite, strong) NSArray *colors;
@property (readwrite, strong) NSArray *locations;
@property (readwrite, strong) NSArray *midPoints;
@property (readwrite, assign) CGFloat angle;
@property (readwrite, assign, getter=isRadial) BOOL radial;
@property (readwrite, strong) CUIPSDGradient *psdGradient;
@end

@implementation CFTGradient

+ (instancetype)gradientWithColors:(NSArray *)colors atLocations:(NSArray *)locations midPoints:(NSArray *)midPoints angle:(CGFloat)angle radial:(BOOL)radial {
    return [[self alloc] initWithColors:colors
                            atLocations:locations
                              midPoints:midPoints
                                  angle:angle
                                 radial:radial];
}

- (instancetype)initWithColors:(NSArray *)colors atLocations:(NSArray *)locations midPoints:(NSArray *)midPoints angle:(CGFloat)angle radial:(BOOL)radial {
    if ((self = [self init])) {
        self.colors = colors;
        self.locations = locations;
        self.midPoints = midPoints;
        self.angle = angle;
        self.radial = radial;
        
        NSMutableArray *cgColors = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < colors.count; idx++) {
            [cgColors addObject:(__bridge id)[colors[idx] CGColor]];
        }
        
        self.psdGradient = [CUIPSDGradient cuiPSDGradientWithColors:cgColors locations:locations midpointLocations:midPoints angle:angle isRadial:radial];
    }
    
    return self;
}

+ (instancetype)gradientWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style {
    return [[self alloc] initWithThemeGradient:gradient angle:angle style:style];
}

- (instancetype)initWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style {
    if ((self = [self init])) {
        self.psdGradient = psdGradientFromThemeGradient(gradient, angle, (unsigned int)style);
        self.angle = angle;
        self.midPoints = self.psdGradient.evaluator.colorMidpointLocations;

        //!TODO: Do something with style
        
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *locations = [NSMutableArray array];
        for (CUIPSDGradientColorStop *stop in self.psdGradient.evaluator.colorStops) {
            [locations addObject:@(stop.colorLocation)];
            
#if TARGET_OS_IPHONE
            [colors addObject:[UIColor colorWithRed:stop.gradientColor.red green:stop.gradientColor.green blue:stop.gradientColor.blue alpha:stop.gradientColor.alpha]];
#else
            [colors addObject:[NSColor colorWithCalibratedRed:stop.gradientColor.red green:stop.gradientColor.green blue:stop.gradientColor.blue alpha:stop.gradientColor.alpha]];
#endif
        }
        
        self.colors = colors;
        self.locations = locations;
        
    }
    
    return self;
}

- (BOOL)isEqualToThemeGradient:(CUIThemeGradient *)themeGradient {
    return gradientsEqual(themeGradient, self.psdGradient);
}

- (CUIThemeGradient *)themeGradientRepresentation {
    CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    CUIThemeGradient *gradient = [[CUIThemeGradient alloc] _initWithGradientEvaluator:self.psdGradient.evaluator
                                                                           colorSpace:space];
    CGColorSpaceRelease(space);
    return gradient;
}

- (NSGradient *)gradientRepresentation {
    CGFloat *locations = malloc(sizeof(CGFloat) * self.locations.count);
    for (NSUInteger x = 0; x < self.locations.count; x++)
        locations[x] = [self.locations[x] doubleValue];
    
    return [[NSGradient alloc] initWithColors:self.colors
                                  atLocations:locations
                                   colorSpace:[NSColorSpace sRGBColorSpace]];
}

@end
