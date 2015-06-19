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
@property (strong) NSData *rawData;
@end

@implementation TKPDFRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        CGPDFDocumentRef *pdf = TKIvarPointer(rendition, "_pdfDocument");
        if (pdf != NULL)
            CGPDFDocumentRelease(*pdf);
        
        *pdf = NULL;
        
        unsigned int listOffset = offsetof(struct csiheader, infolistLength);
        unsigned int listLength = 0;
        [csiData getBytes:&listLength range:NSMakeRange(listOffset, sizeof(listLength))];
        listOffset += listLength + sizeof(unsigned int) * 4;
        
        unsigned int type = 0;
        [csiData getBytes:&type range:NSMakeRange(listOffset, sizeof(type))];

        listOffset += 8;
        unsigned int dataLength = 0;
        [csiData getBytes:&dataLength range:NSMakeRange(listOffset, sizeof(dataLength))];
        
        listOffset += sizeof(dataLength);
        self.rawData = [csiData subdataWithRange:NSMakeRange(listOffset, dataLength)];
        
    }
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.rawData) {
        NSPDFImageRep *rep  = [[NSPDFImageRep alloc] initWithData:self.rawData];
        self._previewImage = [[NSImage alloc] init];
        [self._previewImage addRepresentation:rep];
        
    } else {
        [super computePreviewImageIfNecessary];
    }
}

@end
