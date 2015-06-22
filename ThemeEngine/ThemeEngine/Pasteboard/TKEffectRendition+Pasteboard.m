//
//  TKEffectRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectRendition+Pasteboard.h"
#import "TKEffectPreset+Pasteboard.h"

NSString *const TEEffectPasteboardType = @"com.alexzielenski.themekit.rendition.effect";

@implementation TKEffectRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEEffectPasteboardType;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if ([type isEqualToString:TEEffectPasteboardType]) {
        return [self.effectPreset pasteboardPropertyListForType:TKEffectPresetPasteboardType];
    }
    
    return [super pasteboardPropertyListForType:type];
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    if ([[item availableTypeFromArray:@[ TEEffectPasteboardType ]] isEqualToString:TEEffectPasteboardType]) {
        TKEffectPreset *preset = [[TKEffectPreset alloc] initWithPasteboardPropertyList:[item propertyListForType:TEEffectPasteboardType]
                                                                                 ofType:TKEffectPresetPasteboardType];
        if (preset) {
            self.effectPreset = preset;
            return YES;
        }
    }
    
    return NO;
}

@end
