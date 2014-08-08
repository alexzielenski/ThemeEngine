//
//  main.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFElementStore.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *path = @(argv[1]);
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/SystemAppearance.car copy" toPath:path error:nil];
        
        CFElementStore *store = [CFElementStore storeWithPath:path];
        CFElement *element = [store elementWithName:@"ScrollBarOverlay_ExpandedThumb"];
        NSLog(@"%@", [[element assetsWithScale:2] valueForKeyPath:@"rendition.name"]);
    }
    return 0;
}
