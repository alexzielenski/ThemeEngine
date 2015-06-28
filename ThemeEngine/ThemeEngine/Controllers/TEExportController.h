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
@property (strong) NSMutableDictionary *applicationMap;

/**
 *  Shared Instance of TEExportController
 */
+ (instancetype)sharedExportController;

+ (NSArray *)bundleIdentifiersForUTI:(NSString *)type;
+ (NSURL *)defaultApplicationURLForUTI:(NSString *)type;

- (NSString *)bundleIdentifierForUTI:(NSString *)type;
- (void)setBundleIdentifier:(NSString *)bundleIdentifier forUTI:(NSString *)type;

- (void)exportRenditions:(NSArray <TKRendition *> *)renditions;
- (void)importRenditions:(NSArray <TKRendition *> *)renditions;

@end
