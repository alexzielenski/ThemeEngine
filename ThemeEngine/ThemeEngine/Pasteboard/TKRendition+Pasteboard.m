//
//  TKRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRendition+Pasteboard.h"
#import "NSURL+Paths.h"

NSString *TERenditionHashPBType = @"com.alexzielenski.themeengine.rendition.hash";

@implementation TKRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return nil;
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {
    return NO;
}

- (NSArray *)readableTypes {
    return @[ self.class.pasteboardType ];
}

- (NSString *)mainDataType {
    return (__bridge NSString *)kUTTypePNG;
}

- (NSString *)mainDataExtension {
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)self.mainDataType,
                                                                         kUTTagClassFilenameExtension);
}

- (NSURL *)temporaryURL {
    NSString *sanitizedName = [[[self.name stringByReplacingOccurrencesOfString:@":" withString:@""]
                               stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByDeletingPathExtension];
    
    NSURL *location = [NSURL temporaryURLInSubdirectory:TKTemporaryDirectoryDrags];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSString stringWithFormat:@"%@_%@_%lu", sanitizedName, self.renditionHash, self.changeCount] stringByAppendingPathExtension:self.mainDataExtension]
                          relativeToURL:location];
        
    if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSData *pngData = [self pasteboardPropertyListForType:self.mainDataType];
        [pngData writeToURL:url atomically:NO];
    }
    
    return url;
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[
             (__bridge NSString *)kUTTypePNG,
             (__bridge NSString *)kUTTypeFileURL,
             (__bridge NSString *)kUTTypeImage,
             (__bridge NSString *)kUTTypeTIFF,
             TERenditionHashPBType,
             [self.class pasteboardType]
             ];
}

- (NSPasteboardWritingOptions)writingOptionsForType:(nonnull NSString *)type pasteboard:(nonnull NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if (IS(kUTTypeFileURL) || [type isEqualToString:@"com.apple.finder.node"]) {
        return [self.temporaryURL.absoluteURL pasteboardPropertyListForType:type];
        
    } else if (IS(kUTTypePNG)) {
        [self.previewImage lockFocus];
        NSBitmapImageRep *snapshot = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0,
                                                                                                  self.previewImage.size.width,
                                                                                                  self.previewImage.size.height)];
        [self.previewImage unlockFocus];
        
        return [snapshot representationUsingType:NSPNGFileType properties:@{}];
        
    } else if (IS(kUTTypeTIFF) || IS(kUTTypeImage)) {
        return [self.previewImage TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:1.0];
        
    } else if ([type isEqualToString: TERenditionHashPBType]) {
        return self.renditionHash;
        
    }
    
    return nil;
}

@end
