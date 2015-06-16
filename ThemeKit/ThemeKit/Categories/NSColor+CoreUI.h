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
+ (instancetype)colorWithCUIColor:(CUIColor *)color;
@end
