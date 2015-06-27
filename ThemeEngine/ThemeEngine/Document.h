//
//  Document.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/ThemeKit.h>

extern NSString *const TEDocumentDidShowNotification;

@interface Document : NSDocument
@property (strong) TKMutableAssetStorage *assetStorage;
@property (strong) IBOutlet NSArrayController *elementsArrayController;
@end

