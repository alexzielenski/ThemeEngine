//
//  CFTEffectWrapper+Pasteboard.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTEffectWrapper.h"

#define kCFTEffectWrapperPboardType @"private.cfteffectwrapper"

@interface CFTEffectWrapper (Pasteboard) <NSPasteboardWriting, NSPasteboardReading>

+ (instancetype)effectWrapperFromPasteboard:(NSPasteboard *)pasteboard;
- (id)initWithPasteboardPropertyList:(NSArray *)propertyList
                              ofType:(NSString *)type;

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard;
+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard;

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard;
- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard;
- (id)pasteboardPropertyListForType:(NSString *)typ;
@end
