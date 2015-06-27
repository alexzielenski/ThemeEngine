//
//  NSURL+Paths.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/23/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSURL+Paths.h"

static NSURL *TKTemporaryLocation = nil;
static NSMutableDictionary *TKLocationCache = nil;

static NSString *TKDirectoryToString(TKTemporaryDirectory directory) {
    switch (directory) {
        case TKTemporaryDirectoryDrags: {
            return @"Drags";
            break;
        }
        case TKTemporaryDirectoryPreviews: {
            return @"Previews";
            break;
        }
        case TKTemporaryDirectoryDocuments: {
            return @"Documents";
            break;
        }
        case TKTemporaryDirectoryExports: {
            return @"Exports";
            break;
        }
        default: {
            break;
        }
    }
}

@implementation NSURL (Paths)

+ (void)load {
    TKLocationCache = [NSMutableDictionary dictionary];
    TKTemporaryLocation = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier]
                                     isDirectory:YES];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtURL:TKTemporaryLocation
                        error:nil];
    [manager createDirectoryAtURL:TKTemporaryLocation
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
}

+ (NSURL *)temporaryURLInSubdirectory:(TKTemporaryDirectory)directory {
    NSNumber *key = @(directory);
    NSURL *path = nil;
    if ((path = TKLocationCache[key])) {
        return path;
    }
    
    path = [TKTemporaryLocation URLByAppendingPathComponent:TKDirectoryToString(directory)];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:path
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
    
    TKLocationCache[key] = path;
    return path;
}

@end
