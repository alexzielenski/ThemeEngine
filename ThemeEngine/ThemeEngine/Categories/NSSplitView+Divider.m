//
//  NSSplitView+Divider.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSSplitView+Divider.h"

@implementation NSSplitView (Divider)

- (NSColor *)dividerColor {
    return [NSColor lightGrayColor];
}

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

@end
