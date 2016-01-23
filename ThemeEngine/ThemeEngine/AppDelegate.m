//
//  AppDelegate.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "AppDelegate.h"
#import "NSDocumentController+Untitled.h"

@interface AppDelegate ()
@property (readwrite) TEDocumentController *documentController;
@end

// Prefs:
// 1. Draw Checkers
// 2. Humanize Names (Experimental)
// 3. Always hide inspectors
// 4. Per-document undo context vs per asset

@implementation AppDelegate
@dynamic darkMode;

- (id)init {
    if ((self = [super init])) {
        self.documentController = [TEDocumentController sharedDocumentController];

    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.welcomeController  = [[TEWelcomeController alloc] initWithWindowNibName:@"Welcome"];

    self.darkMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"];
    [self bind:@"darkMode"
      toObject:[NSUserDefaultsController sharedUserDefaultsController]
   withKeyPath:@"values.darkMode"
       options:nil];

    [self showWelcome:self];
    
    __weak typeof(self.welcomeController) weakWelcome = self.welcomeController;
    [[NSNotificationCenter defaultCenter] addObserverForName:TEDocumentDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * __nonnull note) {
                                                      [weakWelcome.window performClose:self];
                                                  }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldOpenUntitledFile:(nonnull NSApplication *)sender {
    [self showWelcome:self];
    return NO;
}

- (BOOL)applicationShouldHandleReopen:(nonnull NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [self showWelcome:self];
        return NO;
    }
    return YES;
}

- (IBAction)showWelcome:(id)sender {
    [self.welcomeController showWindow:self];
}

- (BOOL)darkMode {
    return [[[NSAppearance currentAppearance] name] isEqualToString:NSAppearanceNameVibrantDark];
}

- (void)setDarkMode:(BOOL)darkMode {
    [NSAppearance setCurrentAppearance:[NSAppearance appearanceNamed:darkMode ? NSAppearanceNameVibrantDark : NSAppearanceNameAqua]];
    for (NSWindow *window in [NSApp windows]) {
        if (window != self.welcomeController.window)
            window.appearance = [NSAppearance currentAppearance];
    }
}

- (IBAction)mergeFrontDocuments:(id)sender {
    // Get the asset storage
    // Match rendition hashes to each other
    // overwrite images/data
}


- (BOOL)validateMenuItem:(nonnull NSMenuItem *)menuItem {
    if (menuItem.action == @selector(mergeFrontDocuments:)) {
        NSArray <Document *>*docs = [[TEDocumentController sharedDocumentController] documents];
        return docs.count >= 2;
    }
    
    return YES;
}

@end
