//
//  CHDocument.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTElementStore.h"
#import "CHElementViewController.h"

@interface CHDocument : NSDocument
@property (weak) IBOutlet NSTableView *elementTableView;
@property (readonly, strong) CFTElementStore *elementStore;
@property (readonly, strong) NSArray *sortDescriptors;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet CHElementViewController *elementViewController;
@property (weak) IBOutlet NSArrayController *elementArrayController;
@end
