//
//  TETexturedScope.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TETexturedScope.h"

static NSGradient *selectionGradient = nil;
#import <objc/runtime.h>

@interface TETexturedCell : NSSegmentedCell
@end

@interface NSSegmentedCell (Private)
- (long long)_applicableSegmentedCellStyle;
- (long long)_indexOfHilightedSegment;
- (void)_updateNSSegmentItemViewFramesForCellFrame:(NSRect)arg1;
- (BOOL)_resizeSegmentsForCellFrame:(NSRect)arg1;
- (void)setSegmentStyle:(long long)arg1 forceRecalc:(BOOL)arg2;
- (NSRect)rectForSegment:(NSInteger)arg1 inFrame:(NSRect)arg2;
- (void)_configureLabelCell:(id)arg1 forItem:(id)arg2 controlView:(id)arg3 imageState:(unsigned long long)arg4 backgroundStyle:(long long)arg5;
- (BOOL)_hasItemTooltips;
- (void)_setNeedsToolTipRecalc:(BOOL)arg1;
- (BOOL)_needsToolTipRecalc;
- (BOOL)_proRecalcToolTips;
- (void)_proSetRecalcToolTips:(BOOL)arg1;
@end

@implementation TETexturedScope

+ (Class)cellClass {
    return [TETexturedCell class];
}

@end
@implementation TETexturedCell
+ (void)initialize {
    selectionGradient =  [[NSGradient alloc] initWithStartingColor:[[NSColor blackColor] colorWithAlphaComponent:0.5]
                                                       endingColor:[[NSColor grayColor] colorWithAlphaComponent:0.5]];
}

- (void)_drawBackgroundWithFrame:(struct CGRect)cellFrame inView:(id)arg2 {
//    [[NSColor grayColor] set];
//    NSRectFill(NSMakeRect(0, 0, cellFrame.size.width, 1.0));

    for (NSUInteger segment = 0; segment < self.segmentCount; segment++) {
        NSRect segmentRect = NSIntegralRect([self rectForSegment:segment inFrame:cellFrame]);

        // draw separators on right side
        [[[NSColor lightGrayColor] colorWithAlphaComponent:0.3] set];
        NSRectFill(NSMakeRect(round(NSMaxX(segmentRect)), 0, 1.0, NSHeight(segmentRect)));
        
        if (segment == self.selectedSegment) {
            [[[NSColor lightGrayColor] colorWithAlphaComponent:0.3] set];
            NSRectFill(NSMakeRect(NSMinX(segmentRect) + 1.0, 0.0, segmentRect.size.width - 2.0, 1.0));
            
            NSRect gradientRect = segmentRect;
            gradientRect.size.width += 1;
            [selectionGradient drawInRect:gradientRect angle:90];
        
        } else if (segment == [self _indexOfHilightedSegment]) {
            [[[NSColor lightGrayColor] colorWithAlphaComponent:0.3] set];
            NSRectFill(NSMakeRect(NSMinX(segmentRect) + 1.0, 0.0, segmentRect.size.width - 2.0, 1.0));
            
            [[[NSColor blackColor] colorWithAlphaComponent:0.2] set];
            NSRectFillUsingOperation(segmentRect, NSCompositeSourceOver);
        }
    }
    
    [self _proRecalcToolTips];
    
}

- (NSBackgroundStyle)interiorBackgroundStyleForSegment:(NSInteger)segment {
    if (self.selectedSegment == segment) {
        return NSBackgroundStyleLowered;
    }
    return NSBackgroundStyleRaised;
}

- (BOOL)_allowsVibrancyForControlView:(id)arg1 {
    return YES;
}

+ (double)_endCapWidthForStyle:(long long)arg1 controlSize:(unsigned long long)arg2 {
    return 0;
}

- (BOOL)_isFlatOnEdge:(unsigned long long)arg1 {
    return YES;
}

+ (BOOL)_isTexturedStyle:(long long)arg1 {
    return YES;
}

- (struct CGRect)_boundsForCellFrame:(struct CGRect)arg1 {
    return arg1;
}

- (struct CGRect)drawingRectForBounds:(struct CGRect)arg1 {
    return arg1;
}

@end

