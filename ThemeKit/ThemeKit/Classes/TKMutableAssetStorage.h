//
//  TKMutableAssetStorage.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKAssetStorage.h>
#import <ThemeKit/TKTypes.h>

@interface TKMutableAssetStorage : TKAssetStorage
- (void)writeToDiskUpdatingChangeCounts:(BOOL)update;
@end
