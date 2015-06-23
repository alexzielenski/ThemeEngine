//
//  TERenditionPasteboardItem.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *TERenditionHashPBType;

#define IS(TYPE) [type isEqualToString:(__bridge NSString *)TYPE]
@protocol TERenditionPasteboardItem <NSObject, NSPasteboardWriting>
// For TKRendition to implement
+ (NSString *)pasteboardType;
- (NSString *)mainDataType;
- (NSString *)mainDataExtension;

- (NSArray *)readableTypes;
- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item;

@optional
- (NSURL *)temporaryURL;
@end
