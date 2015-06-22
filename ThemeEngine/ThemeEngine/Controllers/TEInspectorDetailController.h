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
@property (strong) TEInspectorController *inspector;
@property (nonatomic, strong) IBOutlet NSView *inspectorView;

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects;
- (NSStackViewGravity)gravity;
- (IBAction)toggleHide:(NSButton *)sender;

@end
