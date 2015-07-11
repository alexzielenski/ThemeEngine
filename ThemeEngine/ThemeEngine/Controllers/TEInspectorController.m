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
                                       self.caarInspector,
                                       self.animationInspector,
                                       self.sliceInspector,
                                       self.colorInspector,
                                       self.gradientInspector,
                                       self.gradientInfoInspector,
                                       self.effectsInspector,
                                       self.bitmapInspector,
                                       self.attributesInspector
                                       ];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    self.contentView.distribution = NSStackViewDistributionFill;

    for (TEInspectorDetailController *vc in self.inspectorViewControllers) {
        vc.inspector = self;
        [self.contentView addView:vc.view inGravity:vc.gravity];
    }
    [self.contentView addView:self.bottomLine inGravity:NSStackViewGravityTop];

    [self addObserver:self forKeyPath:@"representedObject" options:0 context:&kTEInspectorControllerSelectionDidChange];
    [self reevaluateVisibility];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"representedObject" context:&kTEInspectorControllerSelectionDidChange];
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
        NSStackViewVisibilityPriority vp = [vc visibilityPriorityForInspectedObjects:[self valueForKeyPath:@"representedObject"]];
        [self.contentView setVisibilityPriority:vp
                                        forView:vc.view];
    }
}

@end
