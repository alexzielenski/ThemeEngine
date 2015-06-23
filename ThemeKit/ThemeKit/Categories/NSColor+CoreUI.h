//
//  NSColor+CoreUI.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKStructs.h"
#import <CoreUI/Rendering/CUIColor.h>

@interface NSColor (CoreUI)
+ (instancetype)colorWithColorDef:(struct colordef)definition;
+ (instancetype)colorWithPSDColor:(struct _psdGradientColor)gradientColor;
+ (instancetype)colorWithCUIColor:(CUIColor *)color;

- (void)getPSDColor:(struct _psdGradientColor *)gradientColor;
- (void)getRGBQuad:(struct rgbquad *)quad;

@end
