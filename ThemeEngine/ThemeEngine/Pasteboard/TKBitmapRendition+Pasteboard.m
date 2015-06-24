//
//  TKBitmapRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKBitmapRendition+Pasteboard.h"
#import "TKRendition+Pasteboard.h"

NSString *const TEBitmapPasteboardType = @"com.alexzielenski.themekit.rendition.bitmap";

static NSString *const TEBitmapKeyLayoutInformation = @"layout";
static NSString *const TEBitmapKeyUTType            = @"uti";
static NSString *const TEBitmapKeyBlendMode         = @"blendMode";
static NSString *const TEBitmapKeyExifOrientation   = @"exifOrientation";
static NSString *const TEBitmapKeyOpacity           = @"opacity";
static NSString *const TEBitmapKeyPayload           = @"payload";

@implementation TKBitmapRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEBitmapPasteboardType;
}

- (NSArray *)readableTypes {
    return [[[super readableTypes] arrayByAddingObjectsFromArray:
            [self writableTypesForPasteboard:[NSPasteboard generalPasteboard]]]
            arrayByAddingObjectsFromArray:@[
                                            (__bridge NSString *)kUTTypeURL
                                            ]];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if (IS(kUTTypePNG) || IS(kUTTypeImage)) {
        return [self.image representationUsingType:NSPNGFileType properties:@{}];
        
    } else if (IS(kUTTypeTIFF)) {
        return [self.image representationUsingType:NSTIFFFileType properties:@{ NSImageCompressionMethod: @(NSTIFFCompressionLZW) }];
        
    } else if ([type isEqualToString:TEBitmapPasteboardType]) {
        // Layout information
        // UTIs, blendMode
        // exifOrientation, opacity
        // image itself
        NSMutableDictionary *dictionary          = [NSMutableDictionary dictionary];
        dictionary[TEBitmapKeyBlendMode]         = @(self.blendMode);
        dictionary[TEBitmapKeyExifOrientation]   = @(self.exifOrientation);
        dictionary[TEBitmapKeyOpacity]           = @(self.opacity);
        dictionary[TEBitmapKeyPayload]           = [self pasteboardPropertyListForType:(__bridge NSString *)kUTTypePNG];
        dictionary[TEBitmapKeyUTType]            = self.utiType;
        dictionary[TEBitmapKeyLayoutInformation] = self.layoutInformation.dicitonaryRepresentation;
        
        return [NSPropertyListSerialization dataWithPropertyList:dictionary
                                                          format:NSPropertyListXMLFormat_v1_0
                                                         options:0
                                                           error:nil];
    }
    
    return [super pasteboardPropertyListForType:type];
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    NSString *available = [item availableTypeFromArray:
                           [[@[ TEBitmapPasteboardType ] arrayByAddingObjectsFromArray:[NSBitmapImageRep imageTypes]]
                            arrayByAddingObjectsFromArray:@[ (__bridge NSString *)kUTTypeURL, (__bridge NSString *)kUTTypeFileURL ]]
                           ];
    
    if ([available isEqualToString:TEBitmapPasteboardType]) {
        
        NSDictionary *dict = [item propertyListForType:TEBitmapPasteboardType];
        
        if (dict) {
            self.blendMode         = [dict[TEBitmapKeyBlendMode] unsignedIntValue];
            self.exifOrientation   = [dict[TEBitmapKeyExifOrientation] unsignedIntegerValue];
            self.opacity           = [dict[TEBitmapKeyOpacity] doubleValue];
            self.image             = [[NSBitmapImageRep alloc] initWithData:dict[TEBitmapKeyPayload]];
            self.utiType           = dict[TEBitmapKeyUTType];
            self.layoutInformation = [[TKLayoutInformation alloc] initWithDictionaryRepresentation:dict[TEBitmapKeyLayoutInformation]];
            
            return YES;
        }
        
        return NO;
        
    } else if ([available isEqualToString:(__bridge NSString *)kUTTypeURL] ||
               [available isEqualToString:(__bridge NSString *)kUTTypeFileURL]) {
        
        //!TODO: somehow support asynchronous operations for network requests
        NSString *str = [item stringForType:available];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:data];
        if (rep)
            self.image = rep;
        return rep != nil;
        
    // Then it must be bitmap
    } else {
        NSData *data = [item dataForType:available];
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:data];
        if (rep)
            self.image = rep;
        return rep != nil;
    }
    
    return NO;
}

@end
