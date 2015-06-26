//
//  NSColor+TE.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/20/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSColor+TE.h"

@implementation NSColor (TE)

+ (NSColor *)checkerPattern {
    static NSColor *pattern = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSImage *checkerImage = [NSImage imageWithSize:NSMakeSize(14, 14)
                                               flipped:YES
                                        drawingHandler:^BOOL(NSRect dstRect) {
                                            CGFloat size = dstRect.size.width / 2;
                                            [[[NSColor lightGrayColor] colorWithAlphaComponent:0.25] set];
                                            NSRectFill(NSMakeRect(0, 0, size, size));
                                            NSRectFill(NSMakeRect(size, size, size, size));
                                            
                                            [[[NSColor whiteColor] colorWithAlphaComponent:0.25] set];
                                            NSRectFill(NSMakeRect(size, 0, size, size));
                                            NSRectFill(NSMakeRect(0, size, size, size));
                                            
                                            return YES;
                                        }];
        pattern = [NSColor colorWithPatternImage:checkerImage];
    });
    
    return pattern;
}

+ (NSColor *)themeEnginePurpleColor {
    static NSColor *purple = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        purple = [NSColor colorWithCalibratedHue:0.76
                                      saturation:0.58
                                      brightness:0.65
                                           alpha:1.0];
    });
    
    return purple;
}

@end
