//
//  TKEffectRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectRendition+Pasteboard.h"

NSString *const TEEffectPasteboardType = @"com.alexzielenski.themekit.rendition.effect";

@implementation TKEffectRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEEffectPasteboardType;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    
    return [super pasteboardPropertyListForType:type];
}

@end
