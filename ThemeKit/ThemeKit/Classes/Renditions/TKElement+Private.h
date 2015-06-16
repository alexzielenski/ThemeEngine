//
//  TKElement+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#ifndef TKElement_Private_h
#define TKElement_Private_h

#import <ThemeKit/TKElement.h>

@interface TKElement ()
+ (instancetype)elementWithRenditions:(NSSet<TKRendition *> *)renditions name:(NSString *)name storage:(TKAssetStorage *)storage;
- (instancetype)initWithRenditions:(NSSet<TKRendition *> *)renditions name:(NSString *)name storage:(TKAssetStorage *)storage;

- (void)addRenditions:(NSSet<TKRendition *> *)renditions;
- (void)addRendition:(TKRendition *)asset;
- (void)removeRenditions:(NSSet<TKRendition *> *)renditions;
- (void)removeRendition:(TKRendition *)asset;
@end

#endif /* TKElement_Private_h */
