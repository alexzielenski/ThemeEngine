//
//  CUIPSDGradientStop+KVO.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CUIPSDGradientStop.h"
#import "CUIPSDGradientDoubleOpacityStop.h"
#import "CUIPSDGradientDoubleColorStop.h"

@interface CUIPSDGradientStop (KVO)
@property (readonly) BOOL isMidpointStop;
@property (readonly) BOOL isDoubleColorStop;
@property (readonly) BOOL isDoubleOpacityStop;
@property (strong) NSColor *gradientColorValue;
@property (strong) NSColor *leadOutColorValue;
@property (assign) CGFloat opacityValue;
@property (assign) CGFloat leadOutOpacityValue;
@end
