//
//  NSAppleScript+Functions.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/29/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSAppleScript+Functions.h"
#define kASAppleScriptSuite 'ascr'
#define kASSubroutineEvent  'psbr'
#define keyASSubroutineName 'snam'

NSString *const TEAppleScriptGetFileFunctionName = @"GetFile";
NSString *const TEAppleScriptExportFunctionName  = @"Export";

@implementation NSAppleScript (Functions)

- (NSString *)executeFunction:(NSString *)functionName withArguments:(NSArray *)arguments error:(NSDictionary **)error {
    NSAppleEventDescriptor *container = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                                 eventID:kASSubroutineEvent
                                                                        targetDescriptor:nil
                                                                                returnID:kAutoGenerateReturnID
                                                                           transactionID:kAnyTransactionID];
    
    [container setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:functionName]
                       forKeyword:keyASSubroutineName];
    
    if (arguments.count) {
        NSAppleEventDescriptor *list = [NSAppleEventDescriptor listDescriptor];
        for (NSString *arg in arguments) {
            [list insertDescriptor:[NSAppleEventDescriptor descriptorWithString:arg]
                           atIndex:list.numberOfItems + 1];
        }
        
        [container setParamDescriptor:list forKeyword:keyDirectObject];
    }
    
    NSDictionary *err = nil;
    NSAppleEventDescriptor *result = [self executeAppleEvent:container
                                                       error:&err];
    
    if (error != NULL)
        *error = err;
    
    return result.stringValue;
}

@end
