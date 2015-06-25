//
//  TEExportController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEExportController : NSObject
/**
 *  Application to which you want to export the document
 */
@property (copy) NSString *exportBundleIdentifier;

/**
 *  Shared Instance of TEExportController
 */
+ (instancetype)sharedExportController;


@end
