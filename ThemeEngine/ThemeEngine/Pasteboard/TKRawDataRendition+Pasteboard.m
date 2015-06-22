//
//  TKRawDataRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRawDataRendition+Pasteboard.h"
NSString *const TERawDataPasteboardType = @"com.alexzielenski.themekit.rendition.rawdata";

@implementation TKRawDataRendition (Pasteboard)

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    
    return [[super writableTypesForPasteboard:pasteboard] arrayByAddingObjectsFromArray:
            @[
              self.mainDataType
              ]];
}

- (NSArray *)readableTypes {
    return [[super readableTypes] arrayByAddingObjectsFromArray:@[
                                                                  self.mainDataType,
                                                                  (__bridge NSString *)kUTTypeFileURL
                                                                  ]];
}

- (NSString *)mainDataType {
    return self.utiType;
}

- (NSString *)mainDataExtension {
   if ([self.mainDataType isEqualToString:TKUTITypeCoreAnimationArchive])
       return @"caar";
    return [super mainDataExtension];
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if ([type isEqualToString:self.mainDataType]) {
        return self.rawData;
    }
    
    return [super pasteboardPropertyListForType:type];
}

+ (NSString *)pasteboardType {
    return TERawDataPasteboardType;
}


@end
