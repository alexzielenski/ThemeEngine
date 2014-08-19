//
//  CHDocument.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTElementStore.h"
#import "TEElementViewController.h"

@interface TEDocument : NSDocument
@property (weak) IBOutlet NSTableView *elementTableView;
@property (weak) IBOutlet NSView *elementContentView;
@property (readonly, strong) CFTElementStore *elementStore;
@property (readonly, strong) NSArray *sortDescriptors;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet TEElementViewController *elementViewController;
- (IBAction)addColor:(id)sender;

@end
