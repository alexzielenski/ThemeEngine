//
//  AppDelegate.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

// Prefs:
// 1. Draw Checkers
// 2. Humanize Names (Experimental)
// 3. Always hide inspectors
// 4. Per-document undo context vs per asset

@implementation AppDelegate
@dynamic darkMode;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.darkMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"];
    [self bind:@"darkMode"
      toObject:[NSUserDefaultsController sharedUserDefaultsController]
   withKeyPath:@"values.darkMode"
       options:nil];    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldOpenUntitledFile:(nonnull NSApplication *)sender {
    return NO;
}

- (BOOL)darkMode {
    return [[[NSAppearance currentAppearance] name] isEqualToString:NSAppearanceNameVibrantDark];
}

- (void)setDarkMode:(BOOL)darkMode {
    [NSAppearance setCurrentAppearance:[NSAppearance appearanceNamed:darkMode ? NSAppearanceNameVibrantDark : NSAppearanceNameAqua]];
    for (NSWindow *window in [NSApp windows]) {
        window.appearance = [NSAppearance currentAppearance];
    }
}

@end
