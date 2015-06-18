//
//  TEInspectorController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorController.h"

@interface TEFlippedClipView : NSClipView
@end

@implementation TEFlippedClipView

- (BOOL)isFlipped {
    return YES;
}

@end

@interface TEInspectorController ()
@property (strong) IBOutlet NSScrollView *scrollView;
- (void)reevaluateVisibility;
@end

const void *kTEInspectorControllerSelectionDidChange = &kTEInspectorControllerSelectionDidChange;

@implementation TEInspectorController

- (void)awakeFromNib {
    if (!self.view) {
        [self loadView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.inspectorViewControllers = @[
                                       self.gradientInspector,
                                       self.bitmapInspector,
                                       self.attributesInspector
                                       ];
    
    NSView *view = self.contentView;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    self.scrollView.documentView = view;
    [self.scrollView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(view)]];
    
    for (NSViewController *vc in self.inspectorViewControllers) {
        [self.contentView addView:vc.view inGravity:NSStackViewGravityTop];
    }
    [self.contentView addView:self.bottomLine inGravity:NSStackViewGravityTop];

    [self addObserver:self forKeyPath:@"representedObject.selection" options:0 context:&kTEInspectorControllerSelectionDidChange];
    [self reevaluateVisibility];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"representedObject.selection" context:&kTEInspectorControllerSelectionDidChange];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &kTEInspectorControllerSelectionDidChange) {
        [self reevaluateVisibility];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)reevaluateVisibility {
    for (TEInspectorDetailController *vc in self.inspectorViewControllers) {
        NSStackViewVisibilityPriority vp = [vc visibilityPriorityForInspectedObjects:[self valueForKeyPath:@"representedObject.selectedObjects"]];
        [self.contentView setVisibilityPriority:vp
                                        forView:vc.view];
    }
}

@end
