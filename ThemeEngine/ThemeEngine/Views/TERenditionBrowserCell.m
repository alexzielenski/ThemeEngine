//
//  TERenditionBrowserCell.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionBrowserCell.h"
#import <ThemeKit/TKRendition.h>

static NSURL *TKRenditionTemporaryDirectoryURL;

@implementation TERenditionBrowserCell
+ (void)load {
    TKRenditionTemporaryDirectoryURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/Previews", NSTemporaryDirectory(), NSBundle.mainBundle.bundleIdentifier]
                                                  isDirectory:YES];
    
    [[NSFileManager defaultManager] removeItemAtURL:TKRenditionTemporaryDirectoryURL
                                              error:nil];
    [[NSFileManager defaultManager] createDirectoryAtURL:TKRenditionTemporaryDirectoryURL
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
}


#pragma mark - QLPreviewItem

- (NSURL *)previewItemURL {
    TKRendition *rendition = self.representedItem;
    // Save the Image to a temporary directory
    NSURL *destinationURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@_%lu.tiff", rendition.name, rendition.changeCount]
                                     relativeToURL:TKRenditionTemporaryDirectoryURL];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path])
        return destinationURL;
    
    if (rendition.previewImage) {
        if ([[rendition.previewImage TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:1.0] writeToURL:destinationURL atomically:NO])
            return destinationURL;
    }
    return nil;
}

- (NSString *)previewItemTitle {
    return ((TKRendition *)self.representedItem).name;
}

@end
