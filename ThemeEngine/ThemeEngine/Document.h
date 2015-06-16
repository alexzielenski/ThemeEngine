//
//  Document.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/ThemeKit.h>

@interface Document : NSDocument
@property (strong) TKAssetStorage *assetStorage;
@property (weak) IBOutlet NSSplitView *splitView;

@property (weak) IBOutlet NSView *leftPane;
@property (weak) IBOutlet NSView *rightPane;
@property (weak) IBOutlet NSSegmentedControl *paneControl;

- (IBAction)toggleSidebar:(NSSegmentedControl *)sender;
@end

