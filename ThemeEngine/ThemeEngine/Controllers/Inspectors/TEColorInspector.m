//
//  TEColorInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEColorInspector.h"
#import <ThemeKit/TKColorRendition.h>

@interface TEColorInspector ()

@end

@implementation TEColorInspector

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    return [[objects valueForKey:@"className"] containsObject:[TKColorRendition className]] ?
    NSStackViewVisibilityPriorityMustHold : NSStackViewVisibilityPriorityNotVisible;
}

@end
