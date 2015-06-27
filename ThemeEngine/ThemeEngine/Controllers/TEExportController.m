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
        self.applicationMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (NSArray *)bundleIdentifiersForUTI:(NSString *)type {
    NSArray *identifiers = (__bridge_transfer NSArray *)LSCopyAllRoleHandlersForContentType((__bridge CFStringRef)type, kLSRolesEditor);
    return identifiers;
}

- (NSString *)bundleIdentifierForUTI:(NSString *)type {
    NSString *identifier = self.applicationMap[type];
    if (!identifier) {
        identifier = (__bridge_transfer NSString *)LSCopyDefaultRoleHandlerForContentType((__bridge CFStringRef)type, kLSRolesEditor);
    }
    
    return identifier;
}

- (void)setBundleIdentifier:(NSString *)bundleIdentifier forUTI:(NSString *)type; {
    self.applicationMap[type] = bundleIdentifier;
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
        
    } else if ([rendition isKindOfClass:[TKRawDataRendition class]]) {

        for (TKRawDataRendition *rend in renditions) {
            NSString *uti = [rend utiType];
            NSString *identifier = [self bundleIdentifierForUTI:uti];
            NSBundle *bndl = [NSBundle bundleWithIdentifier:identifier];
            NSString *name = bndl.infoDictionary[@"CFBundleDisplayName"] ?:
            bndl.infoDictionary[@"CFBundleName"];
            
            NSString *ext = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)uti, kUTTagClassFilenameExtension);
            
            NSURL *url = [tmpURL URLByAppendingPathComponent:[[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:ext]];
            [rend.rawData writeToFile:url.path
                           atomically:NO];
            
            [[NSWorkspace sharedWorkspace] openFile:url.path];
            
        }
        
    } else {
        NSLog(@"no rule to export");
    }
    
}

@end
