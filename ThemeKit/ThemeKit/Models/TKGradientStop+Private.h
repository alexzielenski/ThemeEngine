//
//  TKGradientStop+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/ThemeKit.h>
#import <CoreUI/Rendering/CUIThemeGradient.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradient.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientEvaluator.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientStop.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientColorStop.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientDoubleColorStop.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientOpacityStop.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradientDoubleOpacityStop.h>

@class TKGradient;
@interface TKGradientStop () {
@protected
    BOOL _doubleStop;
}
@property (readwrite, getter=isColorStop) BOOL colorStop;
@property (readwrite, getter=isOpacityStop) BOOL opacityStop;
@property (readwrite, getter=isMidpointStop) BOOL midpointStop;
@property (strong) CUIPSDGradientStop *backingStop;
@property (weak) TKGradient *gradient;

+ (id)gradientStopWithCUIPSDGradientStop:(CUIPSDGradientStop *)stop;

@end
