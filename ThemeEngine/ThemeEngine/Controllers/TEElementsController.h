//
//  TEElementsController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TETexturedScope.h"

@interface TEElementsController : NSViewController
@property (strong) NSArray *sortDescriptors;
@property (strong) NSPredicate *filterPredicate;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet TETexturedScope *elementScope;
@property (weak) IBOutlet NSView *tableHeaderView;

- (IBAction)addElement:(id)sender;
- (IBAction)removeSelection:(id)sender;

@end
