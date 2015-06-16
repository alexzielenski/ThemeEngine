//
//  TKPDFRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKPDFRendition.h"
#import "TKRendition+Private.h"
@implementation TKPDFRendition

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.rendition.pdfDocument) {
        CGImageRef image = [self.rendition createImageFromPDFRenditionWithScale:1.0];
        self._previewImage = [[NSImage alloc] initWithCGImage:image size:CGSizeMake(CGImageGetWidth(image),
                                                                                    CGImageGetHeight(image))];
    } else {
        [super computePreviewImageIfNecessary];
    }
}

@end
