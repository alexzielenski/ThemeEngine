//
//  TKHelpers.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHelpers.h"
#import "TKRendition.h"
#import "TKColorRendition.h"

void *TKIvarPointer(id self, const char *name) {
    Ivar ivar = class_getInstanceVariable(object_getClass(self), name);
    return ivar == NULL ? NULL : (__bridge void *)self + ivar_getOffset(ivar);
}

// Sanitizes the names of assets to not include any context information
// which is covered by the key
extern NSString *TKElementNameForRendition(TKRendition *rendition) {    
    static NSArray *replacements = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacements = @[
                         @"@2x",
                         @"@3x",
                         // Sizes
                         @"_Mini",
                         @"_Small",
                         @"_Regular",
                         @"_Large",
                         // Directions
                         @"_Horizontal",
                         @"_Vertical",
                         @"_PointingUp",
                         @"_PointingRight",
                         @"_PointingDown",
                         @"_PointingLeft",
                         // States
                         @"_Active",
                         @"_Inactive"
                         ];
    });
    NSMutableString *name = rendition.name.mutableCopy;
    for (NSString *token in replacements) {
        [name replaceOccurrencesOfString:token
                              withString:@""
                                 options:NSBackwardsSearch
                                   range:NSMakeRange(0, name.length)];
    }
    
    return [name stringByDeletingPathExtension];
}

extern void NSColorToPSDColor(NSColor *color, struct _psdGradientColor *psdColor) {
    color = [color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    psdColor->red   = color.redComponent;
    psdColor->green = color.greenComponent;
    psdColor->blue  = color.blueComponent;
    psdColor->alpha = color.alphaComponent;
}
extern NSColor *PSDColorToNSColor(struct _psdGradientColor color) {
    return [NSColor colorWithRed:color.red
                           green:color.green
                            blue:color.blue
                           alpha:color.alpha];
}
