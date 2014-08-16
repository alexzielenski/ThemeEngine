//
//  CFTAsset+Coding.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/16/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTAsset+Coding.h"
#import "CFTEffectWrapper+Pasteboard.h"
#import "CFTGradient+Pasteboard.h"

@implementation CFTAsset (Coding)

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [self init])) {
        self.gradient = [[CFTGradient alloc] initWithPasteboardPropertyList:[decoder decodeObjectForKey:@"gradient"] ofType:kCFTGradientPboardType];
        self.effectPreset = [[CFTEffectWrapper alloc] initWithPasteboardPropertyList:[decoder decodeObjectForKey:@"effectPreset"] ofType:kCFTEffectWrapperPboardType];
        self.color = [[NSColor alloc] initWithPasteboardPropertyList:[decoder decodeObjectForKey:@"color"] ofType:kCFTColorPboardType];
        self.slices = [decoder decodeObjectForKey:@"slices"];
        self.metrics = [decoder decodeObjectForKey:@"metrics"];
        self.rawData = [decoder decodeObjectForKey:@"rawData"];
        self.image = [[NSBitmapImageRep alloc] initWithData:[decoder decodeObjectForKey:@"image"]];
        self.layout = [decoder decodeIntegerForKey:@"layout"];
        self.type = [decoder decodeIntegerForKey:@"type"];
        self.scale = [decoder decodeDoubleForKey:@"scale"];
        [self setValue:[decoder decodeObjectForKey:@"name"] forKey:@"name"];
        self.utiType = [decoder decodeObjectForKey:@"utiType"];
        self.blendMode = (CGBlendMode)[decoder decodeIntegerForKey:@"blendMode"];
        self.opacity = [decoder decodeDoubleForKey:@"opacity"];
        self.exifOrientation = [decoder decodeIntegerForKey:@"exifOrientation"];
        self.colorSpaceID = [decoder decodeIntForKey:@"colorSpaceID"];
        self.excludedFromContrastFilter = [decoder decodeBoolForKey:@"excludedFromContrastFilter"];
        self.renditionFPO = [decoder decodeBoolForKey:@"renditionFPO"];
        self.vector = [decoder decodeBoolForKey:@"vector"];
        self.opaque = [decoder decodeBoolForKey:@"opaque"];
        [self setValue:[decoder decodeObjectForKey:@"keywords"] forKey:@"keywords"];
        self.key = [decoder decodeObjectForKey:@"key"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self.gradient pasteboardPropertyListForType:kCFTGradientPboardType] forKey:@"gradient"];
    [coder encodeObject:[self.effectPreset pasteboardPropertyListForType:kCFTEffectWrapperPboardType] forKey:@"effectPreset"];
    [coder encodeObject:[self.color pasteboardPropertyListForType:kCFTColorPboardType] forKey:@"color"];
    [coder encodeObject:self.slices forKey:@"slices"];
    [coder encodeObject:self.metrics forKey:@"metrics"];
    [coder encodeObject:self.rawData forKey:@"rawData"];
    [coder encodeObject:[self.image representationUsingType:NSPNGFileType properties:nil] forKey:@"image"];
    [coder encodeInteger:self.layout forKey:@"layout"];
    [coder encodeInteger:self.type forKey:@"type"];
    [coder encodeDouble:self.scale forKey:@"scale"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.utiType forKey:@"utiType"];
    [coder encodeInteger:self.blendMode forKey:@"blendMode"];
    [coder encodeDouble:self.opacity forKey:@"opacity"];
    [coder encodeInteger:self.exifOrientation forKey:@"exifOrientation"];
    [coder encodeInt:(int)self.colorSpaceID forKey:@"colorSpaceID"];
    [coder encodeBool:self.isExcludedFromContrastFilter forKey:@"excludedFromContrastFiler"];
    [coder encodeBool:self.isRenditionFPO forKey:@"renditionFPO"];
    [coder encodeBool:self.isVector forKey:@"vector"];
    [coder encodeBool:self.isOpaque forKey:@"opaque"];
    [coder encodeObject:self.keywords forKey:@"keywords"];
    [coder encodeObject:self.key forKey:@"key"];
}

@end
