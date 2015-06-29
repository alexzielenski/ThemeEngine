//
//  TEExportController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKRendition.h>

@interface TEExportController : NSObject
/**
 *  Shared Instance of TEExportController
 */
+ (instancetype)sharedExportController;

- (void)exportRenditions:(NSArray <TKRendition *> *)renditions;
- (void)importRenditions:(NSArray <TKRendition *> *)renditions;

@end
