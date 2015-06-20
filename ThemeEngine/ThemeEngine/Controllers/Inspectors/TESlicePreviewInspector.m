//
//  TESlicePreviewInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESlicePreviewInspector.h"
#import <ThemeKit/TKBitmapRendition.h>

@interface TESlicePreviewInspector ()

@end

@implementation TESlicePreviewInspector

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    if (objects.count != 1)
        return NSStackViewVisibilityPriorityNotVisible;
    
    TKBitmapRendition *first = objects.firstObject;
    if ([first isKindOfClass:[TKBitmapRendition class]]
        && first.type != CoreThemeTypeSixPart
        && first.type != CoreThemeTypeAnimation
        && first.type != CoreThemeTypeAssetPack) {
        return NSStackViewVisibilityPriorityMustHold;
    }
    
    return NSStackViewVisibilityPriorityNotVisible;
}

@end
