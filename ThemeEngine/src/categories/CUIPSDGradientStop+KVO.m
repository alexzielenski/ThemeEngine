//
//  CUIPSDGradientStop+KVO.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CUIPSDGradientStop+KVO.h"
#import "ZKSwizzle.h"


@interface _PSDKVO : NSObject
@property (readonly) BOOL isMidpointStop;
@property (strong) NSColor *gradientColorValue;
@property (strong) NSColor *leadOutColorValue;
@property (readonly) BOOL isDoubleColorStop;
@property (readonly) BOOL isDoubleOpacityStop;
@property (assign) CGFloat opacityValue;
@property (assign) CGFloat leadOutOpacityValue;
@end

@interface _PSDKVO (Posing)
@property BOOL isOpacityStop;
@property BOOL isColorStop;
@property BOOL isDoubleStop;
- (void)_setGradientColor:(struct _psdGradientColor)color;
- (void)_setLeadOutColor:(struct _psdGradientColor)color;
@property CGFloat opacity;
@property CGFloat leadOutOpacity;
@end

__attribute__((__constructor__)) static void INITKVO() {
    ZKSwizzle(_PSDKVO, CUIPSDGradientStop);
    ZKSwizzle(_PSDKVO, CUIPSDGradientColorStop);
    ZKSwizzle(_PSDKVO, CUIPSDGradientDoubleColorStop);
    ZKSwizzle(_PSDKVO, CUIPSDGradientOpacityStop);
    ZKSwizzle(_PSDKVO, CUIPSDGradientDoubleOpacityStop);
    
    if (![ZKClass(CUIPSDGradientColorStop) respondsToSelector:@selector(_setGradientColor:)]) {
        ZKSwizzle(_PSDGradStop, CUIPSDGradientColorStop);
    }
}

@interface _PSDGradStop : NSObject
@end

@implementation _PSDGradStop

- (void)_setGradientColor:(struct _psdGradientColor)newColor {
    struct _psdGradientColor *color = &ZKHookIvar(self, struct _psdGradientColor, "gradientColor");
    if (color != NULL) {
        memcpy(color, &newColor, sizeof(struct _psdGradientColor));
    }
}

@end

@implementation _PSDKVO
@dynamic isMidpointStop, gradientColorValue, leadOutColorValue, opacityValue, leadOutOpacityValue, isDoubleColorStop, isDoubleOpacityStop;

- (BOOL)isMidpointStop {
    return !(self.isOpacityStop || self.isColorStop);
}

- (BOOL)isDoubleOpacityStop {
    return self.isDoubleStop && self.isOpacityStop;
}

- (BOOL)isDoubleColorStop {
    return self.isDoubleStop && self.isColorStop;
}

- (NSColor *)gradientColorValue {
    if (self.isColorStop) {
        CUIPSDGradientColorStop *me = (CUIPSDGradientColorStop *)self;
        return [NSColor colorWithRed:me.gradientColor.red
                               green:me.gradientColor.green
                                blue:me.gradientColor.blue
                               alpha:me.gradientColor.alpha];
    }
    return nil;
}

- (NSColor *)leadOutColorValue {
    if (self.isDoubleColorStop) {
        CUIPSDGradientDoubleColorStop *me = (CUIPSDGradientDoubleColorStop *)self;
        return [NSColor colorWithRed:me.leadOutColor.red
                               green:me.leadOutColor.green
                                blue:me.leadOutColor.blue
                               alpha:me.leadOutColor.alpha];
    }
    return nil;
}

- (void)setGradientColorValue:(NSColor *)gradientColorValue {
    if (self.isColorStop) {
        gradientColorValue = [gradientColorValue colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        struct _psdGradientColor color;
        color.red = gradientColorValue.redComponent;
        color.blue = gradientColorValue.blueComponent;
        color.green = gradientColorValue.greenComponent;
        color.alpha = gradientColorValue.alphaComponent;
        [self willChangeValueForKey:@"gradientColor"];
        [self _setGradientColor:color];
        [self didChangeValueForKey:@"gradientColor"];
    }
}

- (void)setLeadOutColorValue:(NSColor *)leadOutColorValue {
    if (self.isDoubleColorStop) {
        leadOutColorValue = [leadOutColorValue colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        struct _psdGradientColor color;
        color.red = leadOutColorValue.redComponent;
        color.green = leadOutColorValue.greenComponent;
        color.blue = leadOutColorValue.blueComponent;
        color.alpha = leadOutColorValue.alphaComponent;
        [self willChangeValueForKey:@"leadOutColor"];
        [(CUIPSDGradientDoubleColorStop *)self _setLeadOutColor:color];
        [self didChangeValueForKey:@"leadOutColor"];
    }
}

+ (NSSet *)keyPathsForValuesAffectingGradientColorValue {
    return [NSSet setWithObject:@"gradientColor"];
}

+ (NSSet *)keyPathsForValuesAffectingLeadOutColorValue {
    return [NSSet setWithObject:@"leadOutColor"];
}

- (CGFloat)opacityValue {
    if (self.isOpacityStop) {
        return self.opacity;
    }
    return 1.0;
}

- (void)setOpacityValue:(CGFloat)opacityValue {
    if ((self.isOpacityStop)) {
        [self willChangeValueForKey:@"opacity"];
        [self setValue:@(opacityValue) forKey:@"opacity"];
        [self didChangeValueForKey:@"opacity"];
    }
}

- (CGFloat)leadOutOpacityValue {
    if (self.isDoubleOpacityStop) {
        return ((CUIPSDGradientDoubleOpacityStop *)self).leadOutOpacity;
    }
    
    return 1.0;
}

- (void)setLeadOutOpacityValue:(CGFloat)leadOutOpacityValue {
    if (self.isDoubleOpacityStop) {
        [self willChangeValueForKey:@"leadOutOpacity"];
        [self setValue:@(leadOutOpacityValue) forKey:@"leadOutOpacity"];
        [self didChangeValueForKey:@"leadOutOpacity"];
    }
}

+ (NSSet *)keyPathsForValuesAffectingOpacityValue {
    return [NSSet setWithObject:@"opacity"];
}

+ (NSSet *)keyPathsForValuesAffectingLeadOutOpacityValue {
    return [NSSet setWithObject:@"leadOutOpacity"];
}

@end
