//
//  TKPDFRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKPDFRendition+Pasteboard.h"
NSString *const TEPDFPasteboardType = @"com.alexzielenski.themekit.rendition.pdf";

@implementation TKPDFRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEPDFPasteboardType;
}

- (NSString *)mainDataType {
    return (__bridge NSString *)kUTTypePDF;
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if (IS(kUTTypePDF)) {
        return self.rawData;
    }
    
    return [super pasteboardPropertyListForType:type];
}

@end
