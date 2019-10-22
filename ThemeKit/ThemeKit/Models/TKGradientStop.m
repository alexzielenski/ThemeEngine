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
#import "TKGradient+Private.h"

@interface TKGradientStop ()
- (instancetype)initWithCUIPSDGradientStop:(CUIPSDGradientStop *)stop;
@end

@implementation TKGradientOpacityStop
- (instancetype)init {
    if ((self = [super init])) {
        self.opacityStop = YES;
        self.backingStop = (CUIPSDGradientOpacityStop *)[TKClass(CUIPSDGradientOpacityStop) opacityStopWithLocation:0.0 opacity:1.0];
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

- (BOOL)isDoubleStop {
    return [self.backingStop isKindOfClass:[TKClass(CUIPSDGradientDoubleOpacityStop) class]];
}

- (void)setDoubleStop:(BOOL)doubleStop {
    if (self.isDoubleStop == doubleStop)
        return;

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
    
    [self.gradient resetShaders];
}

- (CGFloat)opacity {
    return ((CUIPSDGradientOpacityStop *)self.backingStop).opacity;
}

- (void)setOpacity:(CGFloat)opacity {
    [self.backingStop setValue:@(opacity) forKey:TKKey(opacity)];
    [self.gradient resetShaders];
}

- (CGFloat)leadOutOpacity {
    if (self.isDoubleStop)
        return ((CUIPSDGradientDoubleOpacityStop *)self.backingStop).leadOutOpacity;
    return 1.0;
}

- (void)setLeadOutOpacity:(CGFloat)leadOutOpacity {
    if (self.isDoubleStop)
        [self.backingStop setValue:@(leadOutOpacity) forKey:TKKey(leadOutOpacity)];
    [self.gradient resetShaders];
}

@end

@implementation TKGradientColorStop
- (instancetype)init {
    if ((self = [super init])) {
        self.colorStop = YES;
        struct _psdGradientColor color;
        color.alpha = 1.0;
        self.backingStop = [[TKClass(CUIPSDGradientColorStop) alloc] initWithLocation:0.0 gradientColor:color];
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

- (BOOL)isDoubleStop {
    return [self.backingStop isKindOfClass:[TKClass(CUIPSDGradientDoubleColorStop) class]];
}

- (void)setDoubleStop:(BOOL)doubleStop {
    if (self.isDoubleStop == doubleStop)
        return;

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
    [self.gradient resetShaders];
}

- (NSColor *)color {
    if (self.isDoubleStop) {
        [NSColor colorWithPSDColor:((CUIPSDGradientDoubleColorStop *)self.backingStop).leadInColor];
    }
    
    return [NSColor colorWithPSDColor:((CUIPSDGradientColorStop *)self.backingStop).gradientColor];
}

- (void)setColor:(NSColor *)color {
    struct _psdGradientColor *original = (struct _psdGradientColor *)TKIvarPointer(self.backingStop, "gradientColor");
    if (original != NULL) {
        [color getPSDColor:original];;
    }
    
    [self.gradient resetShaders];
}

- (NSColor *)leadOutColor {
    if (self.isDoubleStop)
        return [NSColor colorWithPSDColor:((CUIPSDGradientDoubleColorStop *)self.backingStop).leadOutColor];
    
    return nil;
}

- (void)setLeadOutColor:(NSColor *)leadOutColor {
    if (self.isDoubleStop) {
        struct _psdGradientColor *original = (struct _psdGradientColor *)TKIvarPointer(self.backingStop, "leadOutColor");
        if (original != NULL)
            [leadOutColor getPSDColor:original];
    }
    
    [self.gradient resetShaders];
}

@end

@implementation TKGradientStop
@dynamic location;
@dynamic color, leadOutColor;
@dynamic opacity, leadOutOpacity;
@dynamic midpointStop;

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

- (id)init {
    if ((self = [super init])) {
        self.backingStop = [[TKClass(CUIPSDGradientStop) alloc] initWithLocation:0.0];
    }
    
    return self;
}

- (id)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [self init])) {
        [self setValue:[coder decodeObjectForKey:TKKey(color)] forKey:TKKey(color)];
        [self setValue:[coder decodeObjectForKey:TKKey(leadOutColor)] forKey:TKKey(leadOutColor)];
        [self setValue:[coder decodeObjectForKey:TKKey(leadOutOpacity)] forKey:TKKey(leadOutOpacity)];
        [self setValue:[coder decodeObjectForKey:TKKey(opacity)] forKey:TKKey(opacity)];
        [self setValue:[coder decodeObjectForKey:TKKey(location)] forKey:TKKey(location)];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.color forKey:TKKey(color)];
    [coder encodeObject:self.leadOutColor forKey:TKKey(leadOutColor)];
    [coder encodeObject:@(self.leadOutOpacity) forKey:TKKey(leadOutOpacity)];
    [coder encodeObject:@(self.opacity) forKey:TKKey(opacity)];
    [coder encodeObject:@(self.location) forKey:TKKey(location)];
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

- (BOOL)isMidpointStop {
    return !self.isColorStop && !self.isOpacityStop;
}

// Midpoints don't support this feature
- (void)setDoubleStop:(BOOL)doubleStop {}

- (CGFloat)location {
    return self.backingStop.location;
}

- (void)setLocation:(CGFloat)location {
    self.backingStop.location = location;
    [self.gradient resetShaders];
}

// For subclasses
- (NSColor *)color {
    return nil;
}

- (CGFloat)opacity {
    return 0.0;
}

- (NSColor *)leadOutColor {
    return nil;
}

- (CGFloat)leadOutOpacity {
    return 0.0;
}

- (void)setColor:(NSColor *)color {}
- (void)setLeadOutColor:(NSColor *)leadOutColor {}
- (void)setLeadOutOpacity:(CGFloat)leadOutOpacity {}
- (void)setOpacity:(CGFloat)opacity {}


// Trigger KVO on these items when doubleSotp changes
+ (NSSet *)keyPathsForValuesAffectingLeadOutColor {
    return [NSSet setWithObject:@"doubleStop"];
}

+ (NSSet *)keyPathsForValuesAffectingLeadOutOpacity {
    return [NSSet setWithObject:@"doubleStop"];
}

- (void)setNilValueForKey:(nonnull NSString *)key {
    if ([key isEqualToString:TKKey(location)]) {
        self.location = 0;
        return;
    } else if ([key isEqualToString:TKKey(isDoubleStop)] || [key isEqualToString:@"doubleStop"]) {
        self.doubleStop = NO;
        return;
    } else if ([key isEqualToString:TKKey(opacity)]) {
        self.opacity = 0.0;
        return;
    } else if ([key isEqualToString:TKKey(leadOutOpacity)]) {
        self.opacity = 0.0;
        return;
    }
    
    [super setNilValueForKey:key];
}

@end
