//
//  TKGradientRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientRendition.h"
#import "TKRendition+Private.h"

#import "TKGradient+Private.h"

@implementation TKGradientRendition
@dynamic gradient;
- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    if (self.gradient) {
        __weak typeof(self) weakSelf = self;
        self._previewImage = [NSImage imageWithSize:NSMakeSize(64, 64)
                                            flipped:NO
                                     drawingHandler:^BOOL(NSRect dstRect) {
                                         [weakSelf.gradient drawInRect:dstRect];
                                         return YES;
                                     }];
    }
}

- (TKGradient *)gradient {
    if (!_gradient) {
        _gradient = [TKGradient gradientWithCUIGradient:self.rendition.gradient
                                                  angle:self.rendition.gradientDrawingAngle
                                                  style:self.rendition.gradientStyle];
    }
    
    return _gradient;
}

- (void)setGradient:(TKGradient *)gradient {
    if (!gradient) {
        [NSException raise:@"Invalid Argument" format:@"TKGradientRendition: Gradient must be non-null!"];
        return;
    }
    
    _gradient = gradient;
    self._previewImage = nil;
}

@end
