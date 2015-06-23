//
//  TKGradient+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradient.h"
#import "TKTypes.h"
#import <CoreUI/Rendering/CUIThemeGradient.h>
#import <CoreUI/Rendering/PSD/CUIPSDGradient.h>

@interface TKGradient ()
@property (strong) CUIThemeGradient *gradient;
@property (strong) CUIPSDGradientEvaluator *evaluator;

// The gradient renderer
- (void)resetShaders;
+ (instancetype)gradientWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style;
- (instancetype)initWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style;

- (CUIPSDGradient *)psdGradient;

@end
