//
//  TEVariableStackViewItem.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEVariableStackViewItem.h"

@implementation TEVariableStackViewItem

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    if (self.superview &&
        [self.superview isKindOfClass:[NSStackView class]])
        self.stackView = (NSStackView *)self.superview;
}

- (void)setHidden:(BOOL)hidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stackView setVisibilityPriority:hidden ? NSStackViewVisibilityPriorityNotVisible :
         NSStackViewVisibilityPriorityMustHold
                                      forView:self];
    });
}

- (BOOL)isHidden {
    return [self.stackView visibilityPriorityForView:self] == NSStackViewVisibilityPriorityNotVisible;
}

- (BOOL)canDrawSubviewsIntoLayer {
    return NO;//    return YES;
}

@end
