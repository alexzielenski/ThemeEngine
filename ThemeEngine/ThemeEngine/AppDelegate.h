//
//  AppDelegate.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TEWelcomeController.h"
#import "Document.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic) BOOL darkMode;
@property (strong) TEWelcomeController *welcomeController;

- (IBAction)showWelcome:(id)sender;

@end

