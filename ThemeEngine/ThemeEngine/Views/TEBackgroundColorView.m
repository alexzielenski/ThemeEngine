//
//  TEBackgroundColorView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/20/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEBackgroundColorView.h"


@implementation TEBackgroundColorView

- (void)drawRect:(NSRect)dirtyRect {
    [self.backgroundColor set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

- (void)viewDidMoveToSuperview {
    self.wantsLayer = YES;
    [super viewDidMoveToSuperview];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay:YES];
}

@end
