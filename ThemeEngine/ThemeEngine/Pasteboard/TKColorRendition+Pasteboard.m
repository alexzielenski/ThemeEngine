//
//  TKColorRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKColorRendition+Pasteboard.h"
NSString *const TEColorPasteboardType = @"com.alexzielenski.themekit.rendition.color";

@implementation TKColorRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEColorPasteboardType;
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if ([type isEqualToString:TEColorPasteboardType]) {
        // For colors we simply take our HSB and put it in a dict
        return [self.color pasteboardPropertyListForType:NSPasteboardTypeColor];
    }
    
    return [super pasteboardPropertyListForType:type];
}


@end
