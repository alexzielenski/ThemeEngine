//
//  TKGradientRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientRendition+Pasteboard.h"
NSString *const TEGradientPasteboardType = @"com.alexzielenski.themekit.rendition.gradient";

@implementation TKGradientRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEGradientPasteboardType;
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    if ([item availableTypeFromArray:@[ TEGradientPasteboardType ]] != nil) {
        
        
        return YES;
    }
    
    return NO;
}

@end
