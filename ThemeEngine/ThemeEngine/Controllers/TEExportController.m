//
//  TEExportController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEExportController.h"
#import <ThemeKit/TKBitmapRendition.h>
#import <ThemeKit/TKPDFRendition.h>

#import "NSAppleScript+Functions.h"
#import "NSURL+Paths.h"

@import Cocoa;

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
        
    }
    
    return self;
}

- (void)exportRenditions:(NSArray <TKRendition *> *)renditions {
    NSSet *types = [NSSet setWithArray:[renditions valueForKeyPath:@"className"]];
    if (types.count > 1) {
        NSLog(@"select different types");
        return;
    } else if (types.count == 0) {
        return;
    }
    
    TKRendition *rendition = renditions.firstObject;
    NSURL *tmpURL = [NSURL temporaryURLInSubdirectory:TKTemporaryDirectoryExports];
    
    if ([rendition isKindOfClass:[TKBitmapRendition class]]) {
        
        
    } else if ([rendition isKindOfClass:[TKPDFRendition class]]) {
        
        NSMutableArray *urls = [NSMutableArray array];
        for (TKPDFRendition *rend in renditions) {
            NSURL *url = [NSURL fileURLWithPath:[[NSUUID UUID] UUIDString] relativeToURL:tmpURL];
            [rend.rawData writeToURL:url atomically:NO];
            [urls addObject:url];
        }
        
        [[NSWorkspace sharedWorkspace] openURLs:urls
                        withAppBundleIdentifier:@"com.adobe.illustrator"
                                        options:NSWorkspaceLaunchDefault
                 additionalEventParamDescriptor:nil
                              launchIdentifiers:nil];
        
    } else {
        NSLog(@"no rule to export");
    }
    
}

- (void)importRenditions:(NSArray <TKRendition *> *)renditions {
    NSSet *types = [NSSet setWithArray:[renditions valueForKeyPath:@"className"]];
    if (types.count > 1) {
        NSLog(@"select different types");
        return;
    } else if (types.count == 0) {
        return;
    }
    
    NSURL *tmpURL = [NSURL temporaryURLInSubdirectory:TKTemporaryDirectoryExports];
    TKRendition *rendition = renditions.firstObject;
    if ([rendition isKindOfClass:[TKBitmapRendition class]]) {
        
    } else if ([rendition isKindOfClass:[TKPDFRendition class]]) {
        NSDataAsset *asset = [[NSDataAsset alloc] initWithName:@"ApplescriptReceiveFromIllustrator"];
        NSData *data = asset.data;
        NSString *format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
        
        NSRunningApplication *bndl = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.adobe.illustrator"].firstObject;
        NSString *name = bndl.bundleURL.lastPathComponent.stringByDeletingPathExtension;
        
        NSString *scriptText = [NSString stringWithFormat:format, name, name];
        
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
        NSURL *dst = [[tmpURL URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]] URLByAppendingPathExtension:@"pdf"];
        NSString *rtn = [script executeFunction:TEAppleScriptExportFunctionName
                                  withArguments:@[ dst.path ]
                                          error:nil];
        
        NSData *d = [NSData dataWithContentsOfURL:dst];
        
        if (d) {
            [renditions makeObjectsPerformSelector:@selector(setRawData:) withObject:d];
        }
        
        if (rtn) {
            NSLog(@"%@", rtn);
        }
    } else {
        NSLog(@"no rule to import");
    }
}

@end
