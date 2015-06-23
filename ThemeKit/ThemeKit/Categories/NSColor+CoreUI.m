//
//  NSColor+CoreUI.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSColor+CoreUI.h"

@implementation NSColor (CoreUI)

+ (instancetype)colorWithColorDef:(struct colordef)definition {
    CGFloat r = (CGFloat)definition.value.r / 255.0;
    CGFloat g = (CGFloat)definition.value.g / 255.0;
    CGFloat b = (CGFloat)definition.value.b / 255.0;
    CGFloat a = (CGFloat)definition.value.a / 255.0;
    
    return [NSColor colorWithSRGBRed:r green:g blue:b alpha:a];
}

+ (instancetype)colorWithCUIColor:(CUIColor *)color {
    return [NSColor colorWithCGColor:color.CGColor];
}

+ (instancetype)colorWithPSDColor:(struct _psdGradientColor)color {
    return [NSColor colorWithRed:color.red
                           green:color.green
                            blue:color.blue
                           alpha:color.alpha];
}

- (void)getPSDColor:(struct _psdGradientColor *)psdColor {
    NSColor *color = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    psdColor->red   = color.redComponent;
    psdColor->green = color.greenComponent;
    psdColor->blue  = color.blueComponent;
    psdColor->alpha = color.alphaComponent;
}

- (void)getRGBQuad:(struct rgbquad *)quad {
    NSColor *color = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    quad->r = (uint8_t)(color.redComponent * 255.0);
    quad->g = (uint8_t)(color.greenComponent * 255.0);
    quad->b = (uint8_t)(color.blueComponent * 255.0);
    quad->a = (uint8_t)(color.alphaComponent * 255.0);
}

@end
