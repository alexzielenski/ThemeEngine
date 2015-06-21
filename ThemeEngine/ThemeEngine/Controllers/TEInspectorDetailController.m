//
//  TEInspectorDetailController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface TEInspectorDetailController ()
@property (strong) IBOutlet NSView *headerView;
@property (strong) IBOutlet NSTextField *titleField;
@property (strong) NSLayoutConstraint *collapseConstraint;
@property (strong) IBOutlet NSButton *toggleButton;
@property (assign, getter=isCollapsed) BOOL collapsed;
@end

@implementation TEInspectorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.headerView.canDrawSubviewsIntoLayer = YES;
}

- (NSStackViewGravity)gravity {
    return NSStackViewGravityTop;
}

- (void)toggleHide:(NSButton *)sender {
    if (!self.collapsed)  {
        CGFloat headerDistance = NSMinY(self.view.bounds) - NSMinY(self.headerView.frame);
        
        if (!self.collapseConstraint) {
            self.collapseConstraint = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:headerDistance];
        }
        
        self.collapseConstraint.constant = headerDistance;
        [self.view addConstraint:self.collapseConstraint];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * __nonnull context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.collapseConstraint.animator.constant = 0;
            sender.title = @"Show";
        } completionHandler:^{
            _collapsed = YES;
        }];
    } else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            // Animate the constraint to fit the disclosed view again
            self.collapseConstraint.animator.constant -= self.inspectorView.frame.size.height;
            sender.title = @"Hide";
        } completionHandler:^{
            // The constraint is no longer needed, we can remove it.
            [self.view removeConstraint:self.collapseConstraint];
            _collapsed = NO;
        }];
    }
}

- (void)setInspectorView:(NSView *)inspectorView {
    if (inspectorView != _inspectorView) {
        [self.inspectorView removeFromSuperview];
        _inspectorView = inspectorView;
        
        [self.view addSubview:self.inspectorView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_inspectorView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_inspectorView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView][_inspectorView]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_headerView, _inspectorView)]];

        // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_inspectorView]-(0@600)-|"
                                                                          options:0 metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_inspectorView)]];
    }
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    return NSStackViewVisibilityPriorityDetachOnlyIfNecessary;
}

@end
