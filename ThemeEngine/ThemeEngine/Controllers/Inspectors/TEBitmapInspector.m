//
//  TEBitmapInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEBitmapInspector.h"
#import <ThemeKit/TKBitmapRendition.h>

@interface TEBitmapInspector ()

@end

@implementation TEBitmapInspector

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    return [[objects valueForKeyPath:@"className"] containsObject:[TKBitmapRendition className]];
}

@end
