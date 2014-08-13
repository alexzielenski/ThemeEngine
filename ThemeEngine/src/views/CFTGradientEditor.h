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
#import "CUIThemeGradient.h"

@interface CFTGradientEditor : NSView
@property (weak) CUIPSDGradientStop *selectedStop;
@property (strong) CUIThemeGradient *gradient;
@property (strong) NSArray *colorStops;
@property (strong) NSArray *opacityStops;
@property (strong) NSArray *colorMidpointStops;
@property (strong) NSArray *opacityMidpointStops;

@property (strong) NSArray *colorMidpointLocations;
@property (strong) NSArray *opacityMidpointLocations;

@end
