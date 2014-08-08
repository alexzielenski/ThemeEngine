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
        NSLog(@"%lu", (unsigned long)style);
        self.psdGradient = psdGradientFromThemeGradient(gradient, angle, (unsigned int)style);
        self.angle = angle;
        self.midPoints = self.psdGradient.evaluator.colorMidpointLocations;

        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *locations = [NSMutableArray array];
        for (CUIPSDGradientColorStop *stop in self.psdGradient.evaluator.colorStops) {
            [locations addObject:@(stop.colorLocation)];
            [colors addObject:[NSColor colorWithCalibratedRed:stop.gradientColor.red green:stop.gradientColor.green blue:stop.gradientColor.blue alpha:stop.gradientColor.alpha]];
        }
        
        self.colors = colors;
        self.locations = locations;
        
    }
    
    return self;
}

- (BOOL)isEqualToThemeGradient:(CUIThemeGradient *)themeGradient {
    return gradientsEqual(themeGradient, self.psdGradient);
}

@end
