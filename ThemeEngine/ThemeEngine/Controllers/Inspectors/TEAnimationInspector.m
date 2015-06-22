//
//  TEAnimationInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEAnimationInspector.h"
#import <ThemeKit/TKBitmapRendition.h>
#import "NSColor+TE.h"

@interface TEAnimationInspector ()
@property TKLayoutInformation *layoutInformation;
@end

@implementation TEAnimationInspector
@dynamic frameWidth;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.animationView bind:@"frameWidth"
                    toObject:self
                 withKeyPath:@"frameWidth"
                     options:nil];
    
    [self.animationView bind:@"image"
                    toObject:self
                 withKeyPath:@"inspector.contentController.selection.image"
                     options:@{ NSRaisesForNotApplicableKeysBindingOption: @NO }];
    
    [self bind:@"layoutInformation"
      toObject:self
   withKeyPath:@"inspector.contentController.selection.layoutInformation"
       options:@{ NSRaisesForNotApplicableKeysBindingOption: @NO }];
    self.drawsChecker = YES;
}

- (void)dealloc {
    [self.animationView unbind:@"frameWidth"];
    [self.animationView unbind:@"image"];
    [self unbind:@"layoutInformation"];
}

- (void)setDrawsChecker:(BOOL)drawsChecker {
    _drawsChecker = drawsChecker;
    if (drawsChecker) {
        self.animationView.enclosingScrollView.drawsBackground = NO;
        self.backgroundView.backgroundColor = [NSColor checkerPattern];
    } else {
        self.animationView.enclosingScrollView.drawsBackground = YES;
        self.backgroundView.backgroundColor = nil;
    }
}

+ (NSSet *)keyPathsForValuesAffectingFrameWidth {
    return [NSSet setWithObject:@"layoutInformation.sliceRects"];
}

- (CGFloat)frameWidth {
    NSArray *rects = self.layoutInformation.sliceRects;
    if (rects.count >= 1) {
        NSValue *first = rects.firstObject;
        NSRect firstRect = first.rectValue;
        
        return firstRect.size.width;
    }
    return 0;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    NSMutableArray *rects = self.layoutInformation.sliceRects.mutableCopy;
    [self willChangeValueForKey:@"frameWidth"];
    if (rects.count >= 1) {
        NSValue *first = rects.firstObject;
        NSRect firstRect = first.rectValue;
        
        firstRect.size.width = frameWidth;
        
        [rects removeObjectAtIndex:0];
        [rects insertObject:[NSValue valueWithRect:firstRect] atIndex:0];
        self.layoutInformation.sliceRects = rects;
    }
    [self didChangeValueForKey:@"frameWidth"];
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
