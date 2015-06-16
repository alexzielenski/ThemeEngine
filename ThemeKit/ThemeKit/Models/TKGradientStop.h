//
//  TKGradientStop.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TKGradientColorStop;
@class TKGradientOpacityStop;

@interface TKGradientStop : NSObject
@property (readonly, getter=isColorStop) BOOL colorStop;
@property (readonly, getter=isOpacityStop) BOOL opacityStop;
@property (readonly, getter=isMidpointStop) BOOL midpointStop;

@property (nonatomic, assign, getter=isDoubleStop) BOOL doubleStop;
@property (assign) CGFloat location;

+ (TKGradientColorStop *)colorStopWithLocation:(CGFloat)location color:(NSColor *)color;
+ (TKGradientOpacityStop *)opacityStopWithLocation:(CGFloat)location opacity:(CGFloat)opacity;
+ (instancetype)midpointStopWithLocation:(CGFloat)location;

@end

@interface TKGradientColorStop : TKGradientStop
@property (nonatomic, strong) NSColor *leadOutColor;
@property (nonatomic, strong) NSColor *color;

- (instancetype)initWithLocation:(CGFloat)location color:(NSColor *)color;

@end


@interface TKGradientOpacityStop : TKGradientStop
@property (nonatomic, assign) CGFloat leadOutOpacity;
@property (nonatomic, assign) CGFloat opacity;

- (instancetype)initWithLocation:(CGFloat)location opacity:(CGFloat)opacity;

@end

