//
//  NSURL+Paths.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/23/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKTemporaryDirectory) {
    TKTemporaryDirectoryDrags     = 0,
    TKTemporaryDirectoryPreviews  = 1,
    TKTemporaryDirectoryDocuments = 2,
    TKTemporaryDirectoryExports   = 3
};

@interface NSURL (Paths)
+ (NSURL *)temporaryURLInSubdirectory:(TKTemporaryDirectory)directory;
@end
