//
//  TKRawDataRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRawDataRendition+Pasteboard.h"
NSString *const TERawDataPasteboardType = @"com.alexzielenski.themekit.rendition.rawdata";

@implementation TKRawDataRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TERawDataPasteboardType;
}


@end
