//
//  TKBitmapRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKBitmapRendition+Pasteboard.h"
#import "TKRendition+Pasteboard.h"

NSString *const TEBitmapPasteboardType = @"com.alexzielenski.themekit.rendition.bitmap";

@implementation TKBitmapRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEBitmapPasteboardType;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if (IS(kUTTypePNG) || IS(kUTTypeImage)) {
        return [self.image representationUsingType:NSPNGFileType properties:@{}];
        
    } else if (IS(kUTTypeTIFF)) {
        return [self.image representationUsingType:NSTIFFFileType properties:@{ NSImageCompressionMethod: @(NSTIFFCompressionLZW) }];
        
    } else if ([type isEqualToString:TEBitmapPasteboardType]) {
    }
    
    return [super pasteboardPropertyListForType:type];
}

@end
