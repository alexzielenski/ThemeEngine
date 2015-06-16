//
//  TKElement.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKRendition.h>

@class TKAssetStorage;
@interface TKElement : NSObject
@property (nonnull, strong) NSSet<TKRendition *> *renditions;
@property (readonly, nonnull, copy) NSString *name;
@property (readonly, weak) TKAssetStorage *storage;
@end
