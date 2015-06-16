//
//  TKGradientStop.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientStop.h"
#import "TKGradientStop+Private.h"
#import "TKStructs.h"
#import "NSColor+CoreUI.h"

@interface TKGradientStop ()
- (instancetype)initWithCUIPSDGradientStop:(CUIPSDGradientStop *)stop;
@end

@implementation TKGradientOpacityStop
@dynamic opacity, leadOutOpacity;
- (instancetype)init {
    if ((self = [super init])) {
        self.opacityStop = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CGFloat)location opacity:(CGFloat)opacity {
    if ((self = [self init])) {
        self.backingStop = (CUIPSDGradientStop *)[TKClass(CUIPSDGradientOpacityStop)
                            opacityStopWithLocation:location opacity:opacity];
    }
    
    return self;
}

- (void)setDoubleStop:(BOOL)doubleStop {
    if (_doubleStop == doubleStop)
        return;
    
    _doubleStop = doubleStop;

    CUIPSDGradientStop *newBacking = nil;
    if (doubleStop) {
        newBacking = [TKClass(CUIPSDGradientDoubleOpacityStop)
                      doubleOpacityStopWithLocation:self.backingStop.location
                      leadInOpacity:((CUIPSDGradientOpacityStop *)self.backingStop).opacity
                      leadOutOpacity:((CUIPSDGradientOpacityStop *)self.backingStop).opacity];
    } else {
        newBacking = [CUIPSDGradientOpacityStop opacityStopWithLocation:self.backingStop.location
                                                                opacity:((CUIPSDGradientDoubleOpacityStop *)self.backingStop).opacity];
    }
    
    self.backingStop = newBacking;
}

- (CGFloat)opacity {
    return ((CUIPSDGradientOpacityStop *)self.backingStop).opacity;
}

- (void)setOpacity:(CGFloat)opacity {
    [self.backingStop setValue:@(opacity) forKey:TKKey(opacity)];
}

- (CGFloat)leadOutOpacity {
    return ((CUIPSDGradientDoubleOpacityStop *)self.backingStop).leadOutOpacity;
}

- (void)setLeadOutOpacity:(CGFloat)leadOutOpacity {
    [self.backingStop setValue:@(leadOutOpacity) forKey:TKKey(leadOutOpacity)];
}

@end

@implementation TKGradientColorStop
@dynamic color;
- (instancetype)init {
    if ((self = [super init])) {
        self.colorStop = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CGFloat)location color:(NSColor *)color {
    if ((self = [self init])) {
        struct _psdGradientColor psdColor;
        [color getPSDColor:&psdColor];
        self.backingStop = (CUIPSDGradientStop *)[CUIPSDGradientColorStop
                                                  colorStopWithLocation:location gradientColor:psdColor];
    }
    
    return self;
}

- (void)setDoubleStop:(BOOL)doubleStop {
    if (_doubleStop == doubleStop)
        return;
    
    _doubleStop = doubleStop;
    CUIPSDGradientStop *newBacking = nil;
    if (doubleStop) {
        newBacking = [TKClass(CUIPSDGradientDoubleColorStop)
                      doubleColorStopWithLocation:self.backingStop.location
                      leadInColor:((CUIPSDGradientColorStop *)self.backingStop).gradientColor
                      leadOutColor:((CUIPSDGradientColorStop *)self.backingStop).gradientColor];
    } else {
        newBacking = [TKClass(CUIPSDGradientColorStop)
                      colorStopWithLocation:self.backingStop.location
                      gradientColor:((CUIPSDGradientDoubleColorStop *)self.backingStop).gradientColor];
    }
    
    self.backingStop = newBacking;
}

- (NSColor *)color {
    return [NSColor colorWithPSDColor:((CUIPSDGradientColorStop *)self.backingStop).gradientColor];
}

- (void)setColor:(NSColor *)color {
    struct _psdGradientColor *original = (struct _psdGradientColor *)TKIvarPointer(self.backingStop, "gradientColor");
    if (original != NULL) {
        [color getPSDColor:original];;
    }
}

- (NSColor *)leadOutColor {
    return [NSColor colorWithPSDColor:((CUIPSDGradientDoubleColorStop *)self.backingStop).leadOutColor];
}

- (void)setLeadOutColor:(NSColor *)leadOutColor {
    struct _psdGradientColor *original = (struct _psdGradientColor *)TKIvarPointer(self.backingStop, "leadOutColor");
    if (original != NULL) {
        [leadOutColor getPSDColor:original];
    }
}

@end

@implementation TKGradientStop
@dynamic location;

+ (id)gradientStopWithCUIPSDGradientStop:(CUIPSDGradientStop *)stop {
    if (stop.isColorStop) {
        return [[TKGradientColorStop alloc] initWithCUIPSDGradientStop:stop];
    } else if (stop.isOpacityStop) {
        return [[TKGradientOpacityStop alloc] initWithCUIPSDGradientStop:stop];
    }
    
    return nil;
}

- (instancetype)initWithCUIPSDGradientStop:(CUIPSDGradientStop *)stop {
    if ((self = [self init])) {
        self.backingStop = stop;
    }
    
    return self;
}

+ (TKGradientColorStop *)colorStopWithLocation:(CGFloat)location color:(NSColor *)color {
    TKGradientColorStop *stop = [[TKGradientColorStop alloc] init];
    stop.color = color;
    stop.location = location;
    return stop;
}

+ (TKGradientOpacityStop *)opacityStopWithLocation:(CGFloat)location opacity:(CGFloat)opacity {
    TKGradientOpacityStop *stop = [[TKGradientOpacityStop alloc] init];
    stop.opacity = opacity;
    stop.location = location;
    return stop;
}

+ (instancetype)midpointStopWithLocation:(CGFloat)location {
    TKGradientStop *stop = [[TKGradientStop alloc] init];
    stop.location = location;
    return stop;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.midpointStop = YES;
    }
    
    return self;
}

// Midpoints don't support this feature
- (void)setDoubleStop:(BOOL)doubleStop {}

- (CGFloat)location {
    return self.backingStop.location;
}

- (void)setLocation:(CGFloat)location {
    self.backingStop.location = location;
}

@end
