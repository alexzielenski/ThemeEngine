//
//  NSDocumentController+Untitled.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/23/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSDocumentController+Untitled.h"

@implementation NSDocumentController (Untitled)

//- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
//
//}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {
    *outError = [NSError errorWithDomain:NSBundle.mainBundle.bundleIdentifier
                                    code:-2
                                userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Cannot create new documents" }];
    return nil;
}
#pragma clang diagnostic pop
@end
