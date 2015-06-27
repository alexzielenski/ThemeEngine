//
//  Document.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/ThemeKit.h>
#import "TEDocumentViewController.h"

extern NSString *const TEDocumentDidShowNotification;

@interface Document : NSDocument
@property (strong) TKMutableAssetStorage *assetStorage;
@property (strong) IBOutlet NSArrayController *elementsArrayController;
@property (strong) IBOutlet TEDocumentViewController *documentViewController;


- (IBAction)toggleInspector:(NSMenuItem *)sender;
- (IBAction)toggleElements:(NSMenuItem *)sender;


@end

