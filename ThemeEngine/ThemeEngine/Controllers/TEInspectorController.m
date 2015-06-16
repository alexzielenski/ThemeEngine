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
@end

@implementation TEInspectorController

- (void)awakeFromNib {
    if (!self.view) {
        [self loadView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSView *view = self.contentView;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    self.scrollView.documentView = view;
    [self.scrollView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(view)]];
    
    [(NSStackView *)self.contentView addView:self.attributesInspector.view inGravity:NSStackViewGravityTop];
}

@end
