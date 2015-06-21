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
    if (objects.count != 1)
        return NSStackViewVisibilityPriorityNotVisible;
    
    TKBitmapRendition *rendition = objects[0];
    if ([rendition isKindOfClass:[TKBitmapRendition class]]) {
        return rendition.type == CoreThemeTypeAnimation;
    }
    
    return NSStackViewVisibilityPriorityNotVisible;
}


@end
