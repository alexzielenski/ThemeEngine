//
//  TKColorRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKColorRendition+Pasteboard.h"
#import "NSColor+Pasteboard.h"

NSString *const TEColorPasteboardType = @"com.alexzielenski.themekit.rendition.color";

@implementation TKColorRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEColorPasteboardType;
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return [[super writableTypesForPasteboard:pasteboard] arrayByAddingObjectsFromArray:
  @[
    NSPasteboardTypeColor
    ]];
}

- (NSArray *)readableTypes {
    return [[super readableTypes] arrayByAddingObjectsFromArray:
  @[
    NSPasteboardTypeColor
    ]];
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if ([type isEqualToString:TEColorPasteboardType]) {
        return [self.color dictionaryRepresentation];
        
    } else if ([type isEqualToString:NSPasteboardTypeColor]) {
        // For colors we simply take our HSB and put it in a dict
        return [self.color pasteboardPropertyListForType:NSPasteboardTypeColor];
    }
    
    return [super pasteboardPropertyListForType:type];
}


- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    if ([item.types containsObject:[self.class pasteboardType]]) {
        self.color = [NSColor colorWithDictionary:[item propertyListForType:TEColorPasteboardType]];
        return YES;
        
    } else if ([item.types containsObject:NSPasteboardTypeColor]) {
        self.color = [[NSColor alloc] initWithPasteboardPropertyList:[item dataForType:NSPasteboardTypeColor] ofType:NSPasteboardTypeColor];
        
        return YES;
    }
    
    return NO;
}

@end
