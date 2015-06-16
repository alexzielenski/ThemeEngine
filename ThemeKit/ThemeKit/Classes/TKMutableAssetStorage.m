//
//  TKMutableAssetStorage.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKMutableAssetStorage.h"
#import "TKAssetStorage+Private.h"
#import <CoreUI/CUIMutableCommonAssetStorage.h>

@implementation TKMutableAssetStorage

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        self.storage = [[TKClass(CUIMutableCommonAssetStorage) alloc] initWithPath:path forWriting:YES];
        [self _beginEnumeration];
    }
    
    return self;
}

@end
