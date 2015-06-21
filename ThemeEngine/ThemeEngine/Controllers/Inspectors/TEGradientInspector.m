//
//  TEGradientInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEGradientInspector.h"
#import <ThemeKit/TKGradientRendition.h>

@interface TEGradientInspector ()

@end

@implementation TEGradientInspector

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.gradientEditor bind:@"gradient"
                     toObject:self
                  withKeyPath:@"inspector.contentController.selection.gradient"
                      options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];
}

- (void)dealloc {
    [self.gradientEditor unbind:@"gradient"];
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    if (objects.count != 1) {
        return NSStackViewVisibilityPriorityNotVisible;
    }
    
    id object = objects[0];
    return [object isKindOfClass:[TKGradientRendition class]] ? NSStackViewVisibilityPriorityMustHold : NSStackViewVisibilityPriorityNotVisible;
}

@end
