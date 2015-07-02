//
//  CHAppDelegate.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEAppDelegate.h"
#import "NSAppearance.h"
#import "CUICatalog.h"
#import "CUIStructuredThemeStore.h"
#import "CUICommonAssetStorage.h"

@implementation TEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    NSAppearance *appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    CUICatalog *catalog = appearance._coreUICatalog;
    CUIStructuredThemeStore *themeStore = catalog._themeStore;
    CUICommonAssetStorage *assetStorage = themeStore.themeStore;
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[NSURL fileURLWithPath:assetStorage.path]
                                                                           display:YES
                                                                 completionHandler:nil];
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[NSFileManager defaultManager] removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] error:nil];
}


@end
