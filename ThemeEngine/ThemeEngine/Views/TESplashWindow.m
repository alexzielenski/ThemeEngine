//
//  TESplashWindow.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESplashWindow.h"

@implementation TESplashWindow

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    return ([menuItem action] == @selector(performClose:) ||
            [menuItem action] == @selector(performZoom:) ||
            [menuItem action] == @selector(performMiniaturize:)) ?
    YES : [super validateMenuItem:menuItem];
}

- (BOOL)windowShouldClose:(id)sender {
    return YES;
}

- (void)performClose:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(windowShouldClose:)]) {
        if (![[self delegate] windowShouldClose:self])
            return;
        
    } else if ([self respondsToSelector:@selector(windowShouldClose:)]) {
        if (![self windowShouldClose:self])
            return;
    }
    
    [self close];
}

- (void)performMiniaturize:(id)sender {
    [self miniaturize:sender];
}

- (void)performZoom:(id)sender {
    [self zoom:sender];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return NO;
}

@end
