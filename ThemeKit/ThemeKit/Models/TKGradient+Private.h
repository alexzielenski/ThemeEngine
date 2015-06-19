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

@interface TKGradient ()

// The gradient renderer
- (void)resetShaders;
+ (instancetype)gradientWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style;
- (instancetype)initWithCUIGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(CUIGradientStyle)style;

@end
