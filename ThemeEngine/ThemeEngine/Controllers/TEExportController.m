//
//  TEExportController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEExportController.h"

@implementation TEExportController

+ (instancetype)sharedExportController {
    static TEExportController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TEExportController alloc] init];
    });
    
    return shared;
}

- (id)init {
    if ((self = [super init])) {
        self.applicationMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (NSArray *)bundleIdentifiersForUTI:(NSString *)type {
    NSArray *identifiers = (__bridge_transfer NSArray *)LSCopyAllRoleHandlersForContentType((__bridge CFStringRef)type, kLSRolesEditor);
    return identifiers;
}

- (NSString *)bundleIdentifierForUTI:(NSString *)type {
    return self.applicationMap[type];
}

- (void)setBundleIdentifier:(NSString *)bundleIdentifier forUTI:(NSString *)type; {
    self.applicationMap[type] = bundleIdentifier;
}

@end
