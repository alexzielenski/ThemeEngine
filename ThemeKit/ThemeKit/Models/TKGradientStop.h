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

@interface TKGradientStop : NSObject <NSCoding>
@property (readonly, getter=isColorStop) BOOL colorStop;
@property (readonly, getter=isOpacityStop) BOOL opacityStop;
@property (nonatomic, assign, getter=isDoubleStop) BOOL doubleStop;
@property (readonly, getter=isMidpointStop) BOOL midpointStop;

@property (assign) CGFloat location;

@property (nonatomic, strong) NSColor *leadOutColor;
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, assign) CGFloat leadOutOpacity;
@property (nonatomic, assign) CGFloat opacity;

+ (TKGradientColorStop *)colorStopWithLocation:(CGFloat)location color:(NSColor *)color;
+ (TKGradientOpacityStop *)opacityStopWithLocation:(CGFloat)location opacity:(CGFloat)opacity;
+ (instancetype)midpointStopWithLocation:(CGFloat)location;

@end

@interface TKGradientColorStop : TKGradientStop
- (instancetype)initWithLocation:(CGFloat)location color:(NSColor *)color;
@end


@interface TKGradientOpacityStop : TKGradientStop
- (instancetype)initWithLocation:(CGFloat)location opacity:(CGFloat)opacity;
@end

