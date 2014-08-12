//
//  NSColor+ChessboardColor.m
//  ACTGradientEditor
//
//  Created by Alex on 14/09/2011.
//  Copyright 2011 ACT Productions. All rights reserved.
//

#import "NSColor+ChessboardColor.h"

@implementation NSColor (ChessboardColor)

+ (NSColor*)chessboardColorWithFirstColor: (NSColor*)firstColor secondColor: (NSColor*)secondColor squareWidth: (CGFloat)width
{
	NSSize patternSize = NSMakeSize(width * 2.0, width * 2.0);
	NSRect rect = NSZeroRect;
	rect.size = patternSize;
    
	NSImage* pattern = [[NSImage alloc] initWithSize: patternSize];
	rect.size = NSMakeSize(width, width);
	[pattern lockFocus];

	[firstColor set];
	NSRectFill(rect);

	rect.origin.x = width;
	rect.origin.y = width;
	NSRectFill(rect);

	[secondColor set];
	rect.origin.x = 0.0;
	rect.origin.y = width;
	NSRectFill(rect);

	rect.origin.x = width;
	rect.origin.y = 0.0;
	NSRectFill(rect);
	
	[pattern unlockFocus];
	return [NSColor colorWithPatternImage: pattern];
}

@end
