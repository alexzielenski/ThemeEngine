//
//  TECaarInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/24/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TECaarInspector.h"
#import <ThemeKit/TKRawDataRendition.h>

@interface TECaarInspector ()

@end

@implementation TECaarInspector

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    if (objects.count != 1)
        return NSStackViewVisibilityPriorityNotVisible;
    
    TKRawDataRendition *rendition = objects.firstObject;
    if ([rendition isKindOfClass:[TKRawDataRendition class]]) {
        if ([rendition.utiType isEqualToString:TKUTITypeCoreAnimationArchive]) {
            return NSStackViewVisibilityPriorityMustHold;
        }
    }
    
    return NSStackViewVisibilityPriorityNotVisible;
}
@end
