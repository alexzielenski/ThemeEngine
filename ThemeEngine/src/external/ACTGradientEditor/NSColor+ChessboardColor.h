//
//  NSColor+ChessboardColor.m
//  ACTGradientEditor
//
//  Created by Alex on 14/09/2011.
//  Copyright 2011 ACT Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (ChessboardColor)

+ (NSColor*)chessboardColorWithFirstColor: (NSColor*)firstColor secondColor: (NSColor*)secondColor squareWidth: (CGFloat)width;

@end
