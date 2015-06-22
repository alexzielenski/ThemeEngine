//
//  TKEffectRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectRendition+Pasteboard.h"
#import "TKEffectPreset+Pasteboard.h"


@implementation TKEffectRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TKEffectPresetPBoardType;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if ([type isEqualToString:TKEffectPresetPBoardType]) {
        return [self.effectPreset pasteboardPropertyListForType:TKEffectPresetPBoardType];
    }
    
    return [super pasteboardPropertyListForType:type];
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    if ([[item availableTypeFromArray:@[ TKEffectPresetPBoardType ]] isEqualToString:TKEffectPresetPBoardType]) {
        TKEffectPreset *preset = [[TKEffectPreset alloc] initWithPasteboardPropertyList:[item propertyListForType:TKEffectPresetPBoardType]
                                                                                 ofType:TKEffectPresetPBoardType];
        if (preset) {
            self.effectPreset = preset;
            return YES;
        }
    }
    
    return NO;
}

@end
