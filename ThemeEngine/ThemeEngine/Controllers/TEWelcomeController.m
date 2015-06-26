//
//  TEWelcomeController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEWelcomeController.h"
#import "NSColor+TE.h"
@interface TEWelcomeController ()

@end

@implementation TEWelcomeController

- (BOOL)validateMenuItem:(nonnull NSMenuItem *)menuItem {
    if (menuItem.action == @selector(performClose:))
        return YES;
    return [super validateMenuItem:menuItem];
}

- (BOOL)windowShouldClose:(id)win {
    return YES;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.backgroundView.backgroundColor = [NSColor themeEnginePurpleColor];
    
    self.window.styleMask       = NSBorderlessWindowMask;
    self.window.backgroundColor = [NSColor clearColor];
    self.window.opaque          = NO;
    
    self.window.contentView.wantsLayer          = YES;
    self.window.contentView.layer.masksToBounds = YES;
    self.window.contentView.layer.cornerRadius  = 8.0;
}

@end
