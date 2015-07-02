//
//  CFTGradientEditor.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CUIPSDGradientDoubleColorStop.h"
#import "CUIPSDGradientDoubleOpacityStop.h"
#import "CFTGradient.h"
#import "CUIPSDGradientStop+KVO.h"

@interface CFTGradientEditor : NSView
@property (readonly, strong) CUIPSDGradientStop *selectedStop;
@property (strong) CFTGradient *gradientWrapper;
@property (readonly) CUIThemeGradient *gradient;
@property (strong) NSArray *colorStops;
@property (strong) NSArray *opacityStops;
@property (strong) NSArray *colorMidpointStops;
@property (strong) NSArray *opacityMidpointStops;

@property (strong) NSArray *colorMidpointLocations;
@property (strong) NSArray *opacityMidpointLocations;

@property (weak) id target;
@property (assign) SEL action;

- (void)setStop:(CUIPSDGradientStop *)stop doubleSided:(BOOL)doubleSided;

@end
