//
//  TEInspectorDetailController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TEInspectorController;
@interface TEInspectorDetailController : NSViewController
@property (weak) TEInspectorController *inspector;
@property (nonatomic, strong) IBOutlet NSView *inspectorView;

- (IBAction)toggleHide:(NSButton *)sender;

@end
