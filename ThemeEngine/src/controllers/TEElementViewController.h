//
//  CHElementViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTElement.h"
#import <Quartz/Quartz.h>

IB_DESIGNABLE
@interface TEElementViewController : NSViewController <NSDraggingDestination>
@property (weak) IBOutlet IKImageBrowserView *imageBrowserView;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSSearchField *search;
@property (weak) IBOutlet NSArrayController *assetsArrayController;
@property (weak) IBOutlet NSArrayController *elementsArrayController;
@property (weak) CFTElementStore *elementStore;
- (IBAction)searchChanged:(NSSearchField *)sender;

- (IBAction)paste:(id)sender;
- (IBAction)sendToPhotoshop:(id)sender;
- (IBAction)removeAsset:(id)sender;
- (IBAction)receiveFromPhotoshop:(id)sender;

@end
