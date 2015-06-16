//
//  TERenditionsController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TEInspectorController.h"

@interface TERenditionsController : NSViewController
@property (strong) NSArray *sortDescriptors;
@property (strong) NSPredicate *filterPredicate;
@property (weak) IBOutlet NSArrayController *renditionsArrayController;
@property (weak) IBOutlet IKImageBrowserView *renditionBrowser;
@property (weak) IBOutlet NSSlider *zoomSlider;
@property (weak) IBOutlet TEInspectorController *inspectorController;
- (IBAction)zoomAnchorPressed:(NSButton *)sender;
- (IBAction)searchRenditions:(NSSearchField *)sender;
- (IBAction)changeGroup:(NSPopUpButton *)sender;
@end
