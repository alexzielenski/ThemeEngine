//
//  TKRawDataRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRawDataRendition.h"
#import "TKRendition+Private.h"
@import QuartzCore.CATransaction;

static NSString *const TKUTITypeCoreAnimationArchive = @"com.apple.coreanimation-archive";

@interface TKRawDataRendition () {
    CALayer *_rootLayer;
}
@property (strong) CALayer *rootLayer;
@end

@implementation TKRawDataRendition
@dynamic rootLayer;
- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
//    NSLog(@"%@, %@, %d", self.rendition.utiType, TKUTITypeCoreAnimationArchive, [self.rendition.utiType isEqualToString:TKUTITypeCoreAnimationArchive]);
    if ([self.rendition.utiType isEqualToString:TKUTITypeCoreAnimationArchive]) {
        __weak CALayer *layer = self.rootLayer;
        
        self._previewImage = [NSImage imageWithSize:layer.bounds.size
                                            flipped:layer.geometryFlipped
                                     drawingHandler:^BOOL(NSRect dstRect) {
                                         [CATransaction begin];
                                         [CATransaction setDisableActions: YES];
                                         [layer renderInContext:[[NSGraphicsContext currentContext] graphicsPort]];
                                         [CATransaction commit];
                                         return YES;
                                     }];
    } else {
        [super computePreviewImageIfNecessary];
    }
}

- (CALayer *)rootLayer {
    if (!_rootLayer ||
        [self.rendition.utiType isEqualToString:TKUTITypeCoreAnimationArchive]) {
        NSDictionary *archive = [NSKeyedUnarchiver unarchiveObjectWithData:self.rendition.data];
        _rootLayer = [archive objectForKey:@"rootLayer"];
        _rootLayer.geometryFlipped = [[archive objectForKey:@"geometryFlipped"] boolValue];
    }
    
    return _rootLayer;
}

- (void)setRootLayer:(CALayer *)rootLayer {
    _rootLayer = rootLayer;
    self._previewImage = nil;
}

@end
