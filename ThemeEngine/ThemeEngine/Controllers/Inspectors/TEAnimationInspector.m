//
//  TEAnimationInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEAnimationInspector.h"
#import <ThemeKit/TKBitmapRendition.h>

@interface TEAnimationInspector ()

@end

@implementation TEAnimationInspector

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    
    return [[objects valueForKey:@"className"] containsObject:[TKBitmapRendition className]];
}


@end
