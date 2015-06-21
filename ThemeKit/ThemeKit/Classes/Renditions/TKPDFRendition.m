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
        [self addObserver:self
               forKeyPath:@"rawData"
                  options:0
                  context:&TKPDFRenditionRawDataChangedContext];
        self.rawData = self.rawData;
    }
    return self;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &TKPDFRenditionRawDataChangedContext) {
        self.pdf = [NSPDFImageRep imageRepWithData:self.rawData];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"rawData" context:&TKPDFRenditionRawDataChangedContext];
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

@end
