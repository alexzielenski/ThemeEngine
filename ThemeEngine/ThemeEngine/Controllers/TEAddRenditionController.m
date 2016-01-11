//
//  TEAddRenditionController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 7/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEAddRenditionController.h"

@interface TEAddRenditionController ()
- (IBAction)cancel:(id)sender;
- (IBAction)addAction:(id)sender;
@end

@implementation TEAddRenditionController

- (void)beginWithWindow:(NSWindow *)window completionHandler:(void (^)(TKRendition *rendition))handler {
    if (self.window.parentWindow)
        return;
    
    [window beginSheet:window completionHandler:^(NSModalResponse returnCode) {
        NSLog(@"fin");
    }];
}

- (IBAction)cancel:(id)sender {
    [self.window.parentWindow endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)addAction:(id)sender {
    [self.window.parentWindow endSheet:self.window returnCode:NSModalResponseOK];
}

@end
