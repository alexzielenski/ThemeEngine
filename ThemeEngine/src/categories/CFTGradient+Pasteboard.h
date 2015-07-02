//
//  CFTGradient+Pasteboard.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradient.h"
#import "NSColor+Pasteboard.h"
#define kCFTGradientPboardType @"private.cftgradient"

@interface CFTGradient (Pasteboard) <NSPasteboardReading, NSPasteboardWriting>
+ (instancetype)gradientFromPasteboard:(NSPasteboard *)pb;
@end
