//
//  TEGradientStopLayer.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEGradientStopLayer.h"

@interface NSObject ()
- (void)noteStopChanged:(TKGradientStop *)stop;
@end

@interface TEGradientStopLayer ()
- (void)_initialize;
@end

@implementation TEGradientStopLayer

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

static void *kTEStopDirtyContext;
- (void)_initialize {
    self.autoresizingMask = kCALayerNotSizable;
    self.shadowColor = [[NSColor blackColor] CGColor];
    self.shadowOpacity = 0.2;
    self.shadowOffset = CGSizeMake(0, -2.0);
    
    // Redraw when any of these properties change
    [self addObserver:self forKeyPath:@"gradientStop" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.color" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.isDoubleStop" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.leadOutColor" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.opacity" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.leadOutOpacity" options:0 context:&kTEStopDirtyContext];
    [self addObserver:self forKeyPath:@"gradientStop.location" options:0 context:&kTEStopDirtyContext];
    //[self addObserver:self forKeyPath:@"selected" options:0 context:&kTEStopDirtyContext];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"gradientStop"];
    [self removeObserver:self forKeyPath:@"gradientStop.color"];
    [self removeObserver:self forKeyPath:@"gradientStop.location"];
    [self removeObserver:self forKeyPath:@"gradientStop.opacity"];
    [self removeObserver:self forKeyPath:@"gradientStop.leadOutOpacity"];
    [self removeObserver:self forKeyPath:@"gradientStop.leadOutColor"];
    [self removeObserver:self forKeyPath:@"gradientStop.isDoubleStop"];
   // [self removeObserver:self forKeyPath:@"selected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kTEStopDirtyContext) {
        // Refresh owning gradient editor
        if ([self.superlayer.delegate respondsToSelector:@selector(noteStopChanged:)])
            [self.superlayer.delegate performSelector:@selector(noteStopChanged:) withObject:self.gradientStop];
        
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    // This is a midpoint
    BOOL midpoint = (!self.gradientStop.isOpacityStop && !self.gradientStop.isColorStop);
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:ctx flipped:YES]];
    
    if (midpoint) {
        // Draw a diamond
        // Thinking maybe I should be caching this path
        NSBezierPath *path = [NSBezierPath bezierPath];
        NSRect bounds = NSInsetRect(self.bounds, 4, 4);
        [path moveToPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds))];
        [path lineToPoint:NSMakePoint(NSMaxX(bounds), NSMidY(bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(bounds), NSMaxY(bounds))];
        [path lineToPoint:NSMakePoint(NSMinX(bounds), NSMidY(bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds))];
        [path setClip];
        
        // Midpoints are black, but if they are "automatically" generated
        // at exactly 50%, they are gray
        NSColor *fillColor = [NSColor blackColor];
        if (self.gradientStop.location == 0.5)
            fillColor = [fillColor colorWithAlphaComponent:0.5];
        
        // Midpoints are white when filled
        if (self.isSelected)
            fillColor = [NSColor whiteColor];
        
        CGContextSetFillColorWithColor(ctx, [fillColor CGColor]);
        CGContextFillRect(ctx, self.bounds);
        
    } else {
        NSColor *leadColor = nil;
        NSColor *leadOutColor = nil;
        
        if (self.gradientStop.isOpacityStop) {
            leadColor = [NSColor colorWithWhite:1.0 - self.gradientStop.opacity alpha:1.0];
            if (self.gradientStop.isDoubleStop)
                leadOutColor = [NSColor colorWithWhite:1.0 - self.gradientStop.leadOutOpacity alpha:1.0];

        } else if (self.gradientStop.isColorStop) {
            leadColor = self.gradientStop.color;
            leadOutColor = self.gradientStop.leadOutColor;
        }
        
        // Draw lead in/out colors half and half, otherwise just the leadin if its not double
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.bounds.size.width / 2 yRadius:self.bounds.size.width / 2];
        
        // Draw the border
        [self.isSelected ? [NSColor grayColor] : [NSColor whiteColor] set];
        [path fill];
        
        CGFloat inset = self.gradientStop.isColorStop ? 2.0 : 4.0;
        NSRect bounds = NSInsetRect(self.bounds, inset, inset);
        path = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:bounds.size.width / 2 yRadius:bounds.size.width / 2];
        [path setClip];
        
        [leadColor set];
        [path fill];
        
        if (leadOutColor) {
            [leadOutColor set];
            NSRectFill(NSMakeRect(NSMidX(self.bounds), 0, NSWidth(self.bounds) / 2, NSHeight(self.bounds)));
        }
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
