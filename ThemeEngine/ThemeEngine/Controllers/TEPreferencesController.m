//
//  TEPreferencesController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/27/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEPreferencesController.h"

@interface TEPreferencesController ()

@end

@implementation TEPreferencesController

+ (instancetype)sharedPreferencesController {
    static TEPreferencesController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TEPreferencesController alloc] initWithWindowNibName:@"Preferences"];
    });
    
    return shared;
}

@end
