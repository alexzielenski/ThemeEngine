//
//  TKColorRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKColorRendition.h"
#import "TKRendition+Private.h"
#import "NSColor+CoreUI.h"

@interface TKColorRendition ()
@property BOOL excudedFromFilter;
@end

@implementation TKColorRendition

- (instancetype)initWithColorKey:(struct colorkey)key definition:(struct colordef)definition {
    if ((self = [self init])) {
        self.name              = @(key.name);
        self.color             = [NSColor colorWithColorDef:definition];
        self.excudedFromFilter = YES;
    }
    
    return self;
}

- (void)setColor:(NSColor *)color {
    _color = color;
    self._previewImage = nil;
}

- (void)computePreviewImageIfNecessary {
    if (self._previewImage)
        return;
    
    __weak typeof(self) weakSelf = self;
    self._previewImage = [NSImage imageWithSize:NSMakeSize(1, 1) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [weakSelf.color setFill];
        NSRectFill(dstRect);
        
        return YES;
    }];
}

+ (NSDictionary *)undoProperties {
    static NSDictionary *TKColorProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKColorProperties = @{
                               TKKey(color): @"Change Color"
                               };
    });
    
    return TKColorProperties;
}

- (void)commitToStorage {
    if (!self.isDirty) {
        NSLog(@"tried to commit clean rendition %@: %@", self, self.name);
        return;
    }
    
    struct rgbquad rgb;
    [self.color getRGBQuad:&rgb];
    [self.cuiAssetStorage setColor:rgb
                           forName:[self.name UTF8String]
                 excludeFromFilter:self.excudedFromFilter];
}

@end
