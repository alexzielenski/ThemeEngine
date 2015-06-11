//
//  CFTAsset+IKImageBrowserItem.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/16/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTAsset+IKImageBrowserItem.h"
@import Quartz.ImageKit.IKImageBrowserView;

@implementation CFTAsset (IKImageBrowserItem)

- (id)imageRepresentation {
    return self.previewImage;
}

- (NSString *)imageRepresentationType {
    return IKImageBrowserNSImageRepresentationType;
}

- (NSString *)imageUID {
    if (self.type == kCoreThemeTypePDF || self.type == kCoreThemeTypeRawData || self.type == kCoreThemeTypeRawPixel)
        return self.rawData.description;
    else if (self.type == kCoreThemeTypeGradient)
        return self.gradient.description;
    else if (self.type == kCoreThemeTypeEffect)
        return self.effectPreset.description;
    else if (self.type == kCoreThemeTypeColor) {
        return [NSString stringWithFormat:@"%f, %f, %f, %f", self.color.redComponent, self.color.greenComponent, self.color.blueComponent, self.color.alphaComponent];
    }

    [self computeImageIfNeeded];
    return [self.image description];
}

@end
