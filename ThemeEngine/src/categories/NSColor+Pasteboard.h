//
//  NSColor+Pasteboard.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kCFTColorPboardType @"private.cftcolor"

@interface NSColor (Pasteboard)
- (id)_replaced_initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type;
- (id)_replaced_pasteboardPropertyListForType:(NSString *)type;
+ (NSArray *)_replaced_readableTypesForPasteboard:(NSPasteboard *)pasteboard;
- (NSArray *)_replaced_writableTypesForPasteboard:(NSPasteboard *)pasteboard;
@end