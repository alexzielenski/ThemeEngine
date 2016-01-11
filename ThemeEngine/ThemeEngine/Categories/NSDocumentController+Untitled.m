//
//  NSDocumentController+Untitled.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/23/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSDocumentController+Untitled.h"

@implementation TEDocumentController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {
    *outError = [NSError errorWithDomain:NSBundle.mainBundle.bundleIdentifier
                                    code:-2
                                userInfo:@{ NSLocalizedRecoverySuggestionErrorKey: @"Cannot create new documents" }];
    return nil;
}
#pragma clang diagnostic pop
- (NSInteger)runModalOpenPanel:(NSOpenPanel *)openPanel
                      forTypes:(NSArray *)types {
    openPanel.treatsFilePackagesAsDirectories = YES;
    
    return [super runModalOpenPanel: openPanel forTypes: types];
}

@end
