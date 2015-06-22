//
//  TKGradient+Pasteboard.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/ThemeKit.h>
#import "TKGradientStop+Pasteboard.h"

extern NSString *const TEGradientPBoardType;

@interface TKGradient (Pasteboard) <NSPasteboardReading, NSPasteboardWriting>

@end
