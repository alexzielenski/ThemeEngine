//
//  TKRawPixelRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 7/6/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRawPixelRendition.h"
#import "TKRendition+Private.h"

@interface TKRawPixelRendition ()
@property (strong) NSData *rawData;
@end

@implementation TKRawPixelRendition

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [super _initWithCUIRendition:rendition csiData:csiData key:key])) {
        
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
        
        self.image = [[NSBitmapImageRep alloc] initWithData:self.rawData];
    }
    
    return self;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.image) {
        // Just get the image of the rendition
        self._previewImage = [[NSImage alloc] initWithSize:self.image.size];
        [self._previewImage addRepresentation:self.image];
    }
}


@end
