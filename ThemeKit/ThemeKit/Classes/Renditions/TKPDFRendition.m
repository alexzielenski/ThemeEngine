//
//  TKPDFRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKPDFRendition.h"
#import "TKRendition+Private.h"

@interface TKPDFRendition ()
@end

static const void *TKPDFRenditionRawDataChangedContext = &TKPDFRenditionRawDataChangedContext;

@implementation TKPDFRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        CGPDFDocumentRef *pdf = TKIvarPointer(rendition, "_pdfDocument");
        if (pdf != NULL)
            CGPDFDocumentRelease(*pdf);
        
        *pdf = NULL;
        self.utiType = (__bridge_transfer NSString *)kUTTypePDF;
    }
    return self;
}


- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.rawData) {
        self._previewImage = [[NSImage alloc] init];
        [self._previewImage addRepresentation:self.pdf];
        
        
    } else {
        [super computePreviewImageIfNecessary];
    }
}

- (NSData *)rawData {
    return self.pdf.PDFRepresentation;
}

- (void)setRawData:(NSData *)rawData {
    self.pdf = [NSPDFImageRep imageRepWithData:rawData];
}

+ (NSSet *)keyPathsForValuesAffectingRawData {
    return [NSSet setWithObject:@"pdf"];
}

@end
