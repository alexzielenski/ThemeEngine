//
//  CFTGradient.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUIThemeGradient.h"

@interface CFTGradient : NSObject
@property (readonly, strong) NSArray *colors;
@property (readonly, strong) NSArray *locations;
@property (readonly, strong) NSArray *midPoints;
@property (readonly, assign) CGFloat angle;
@property (readonly, assign, getter=isRadial) BOOL radial;

+ (instancetype)gradientWithColors:(NSArray *)colors atLocations:(NSArray *)locations midPoints:(NSArray *)midPoints angle:(CGFloat)angle radial:(BOOL)radial;
- (instancetype)initWithColors:(NSArray *)colors atLocations:(NSArray *)locations midPoints:(NSArray *)midPoints angle:(CGFloat)angle radial:(BOOL)radial;

+ (instancetype)gradientWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style;
- (instancetype)initWithThemeGradient:(CUIThemeGradient *)gradient angle:(CGFloat)angle style:(NSUInteger)style;

- (BOOL)isEqualToThemeGradient:(CUIThemeGradient *)themeGradient;
- (CUIThemeGradient *)themeGradientRepresentation;

@end
