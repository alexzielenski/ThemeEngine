//
//  NSAppleScript+Functions.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/29/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TEAppleScriptGetFileFunctionName;
extern NSString *const TEAppleScriptExportFunctionName;

@interface NSAppleScript (Functions)

- (NSString *)executeFunction:(NSString *)functionName withArguments:(NSArray<NSString *> *)arguments error:(NSDictionary **)error;

@end
