//
//  TKEffectPreset+Pasteboard.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/ThemeKit.h>

extern NSString *const TKEffectPresetPBoardType;

@interface TKEffectPreset (Pasteboard) <NSPasteboardReading, NSPasteboardWriting>

@end
