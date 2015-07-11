//
//  TESliceImageView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESliceImageView.h"
#import "NSColor+TE.h"

@import QuartzCore.CATransaction;

static NSEdgeInsets TEIntegralInsets(NSEdgeInsets insets) {
    return NSEdgeInsetsMake(round(insets.top), round(insets.left), round(insets.bottom), round(insets.right));
}

static const CGFloat sliceSpaceWidth = 2.0;

@interface TESliceImageView ()
@property (strong) CALayer *leftHandle;
@property (strong) CALayer *topHandle;
@property (strong) CALayer *bottomHandle;
@property (strong) CALayer *rightHandle;

@property (strong) CALayer *handleLayer;

@property (weak) CALayer *dragHandle;
@property NSEdgeInsets dragInsets;
@property NSPoint dragPoint;

- (void)_initialize;
- (void)_toggleDisplay;
- (void)addHandleWithName:(NSString *)name vertical:(BOOL)vertical right:(BOOL)right;
- (void)_repositionHandles;
- (void)_generateSliceRectsFromInsets;
@end

@implementation TESliceImageView
@dynamic leftHandlePosition, topHandlePosition, bottomHandlePosition, rightHandlePosition, hideHandles;

#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        [self _initialize];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.drawsChecker = self.drawsChecker;
}

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];

    self.layer.frame = self.bounds;
    self.image = [[NSBitmapImageRep alloc] initWithCGImage:[[NSImage imageNamed:@"NSApplicationIcon"] CGImageForProposedRect:NULL context:nil hints:nil]];
    self.renditionType = CoreThemeTypeOnePart;
    self.sliceInsets = NSEdgeInsetsZero;
    self.sliceRects = @[  ];
    
    [self setNeedsDisplay:YES];
    [self setNeedsLayout:YES];
    
    [self.layer setNeedsDisplay];
    [self.layer setNeedsLayout];
    self.drawsChecker = self.drawsChecker;

}

- (void)_initialize {
    self.layer          = [CALayer layer];
    self.layer.delegate = self;
    self.wantsLayer     = YES;
    self.drawsChecker = YES;
    self.handleLayer = [CALayer layer];
    self.handleLayer.frame = self.layer.bounds;
    self.handleLayer.autoresizingMask = kCALayerMaxXMargin | kCALayerMaxYMargin | kCALayerMinXMargin | kCALayerMinYMargin | kCALayerWidthSizable | kCALayerHeightSizable;
    [self.layer addSublayer:self.handleLayer];
    
    [self addHandleWithName:@"leftHandle" vertical:YES right:NO];
    [self addHandleWithName:@"rightHandle" vertical:YES right:YES];
    [self addHandleWithName:@"topHandle" vertical:NO right:NO];
    [self addHandleWithName:@"bottomHandle" vertical:NO right:YES];
}

- (void)updateTrackingAreas {
    for (NSInteger x = self.trackingAreas.count - 1; x >= 0; x--) {
        [self removeTrackingArea:self.trackingAreas[x]];
    }
    
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInActiveApp | NSTrackingMouseMoved owner:self userInfo:nil]];
}

- (void)addHandleWithName:(NSString *)name vertical:(BOOL)vertical right:(BOOL)right {
    CALayer *handle         = [CALayer layer];

    handle.name             = name;
    handle.borderWidth      = 0.0;
    handle.backgroundColor  = [[NSColor grayColor] CGColor];
//    handle.backgroundColor  = [[NSColor whiteColor] CGColor];

    if (vertical) {
        handle.frame = CGRectMake(0, 0, 1.0, self.bounds.size.height);
        handle.autoresizingMask = kCALayerHeightSizable | kCALayerMinYMargin | kCALayerMaxYMargin;
        handle.anchorPoint      = CGPointMake(right ? 1.0 : 0.0, 0.0);
        
    } else {
        handle.frame            = CGRectMake(0, 0, self.bounds.size.width, 1.0);
        handle.anchorPoint      = CGPointMake(0.0, right ? 1.0 : 0.0);
        handle.autoresizingMask = kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMaxXMargin;

    }
    
    [self setValue:handle forKey:name];
    [self.handleLayer addSublayer:handle];
}

#pragma mark - Logistics

- (void)_generateSliceRectsFromInsets {
    NSEdgeInsets insets = self.sliceInsets;
    NSSize imageSize = NSMakeSize(self.image.pixelsWide, self.image.pixelsHigh);
    
    if (self.renditionType == CoreThemeTypeThreePartHorizontal) {
        NSRect left = NSMakeRect(0, 0, insets.left, imageSize.height);
        NSRect middle = NSMakeRect(insets.left, 0, imageSize.width - insets.left - insets.right, imageSize.height);
        NSRect right = NSMakeRect(imageSize.width - insets.right, 0, insets.right, imageSize.height);
        
        self.sliceRects = @[ [NSValue valueWithRect:left], [NSValue valueWithRect:middle], [NSValue valueWithRect:right] ];
    } else if (self.renditionType == CoreThemeTypeThreePartVertical) {
        NSRect top = NSMakeRect(0, imageSize.height - insets.top, imageSize.width, insets.top);
        NSRect middle = NSMakeRect(0, insets.bottom, imageSize.width, imageSize.height - insets.top - insets.bottom);
        NSRect bottom = NSMakeRect(0, 0, imageSize.width, insets.bottom);
        
        self.sliceRects = @[ [NSValue valueWithRect:top], [NSValue valueWithRect:middle], [NSValue valueWithRect:bottom] ];
    } else if (self.renditionType == CoreThemeTypeNinePart) {
        NSRect topLeft = NSMakeRect(0, imageSize.height - insets.top, insets.left, insets.top);
        NSRect topEdge = NSMakeRect(insets.left, topLeft.origin.y, imageSize.width - insets.left - insets.right, self.edgeInsets.top);
        NSRect topRight = NSMakeRect(imageSize.width - insets.right, topLeft.origin.y, insets.right, insets.top);
        NSRect leftEdge = NSMakeRect(0, insets.bottom, insets.left, imageSize.height - insets.top - insets.bottom);
        NSRect center = NSMakeRect(insets.left, insets.bottom, imageSize.width - insets.left - insets.right, imageSize.height - insets.top - insets.bottom);
        NSRect rightEdge = NSMakeRect(imageSize.width - insets.right, insets.bottom, insets.right, imageSize.height - insets.top - insets.bottom);
        NSRect bottomLeft = NSMakeRect(0, 0, insets.left, self.edgeInsets.bottom);
        NSRect bottomEdge = NSMakeRect(insets.left, 0, imageSize.width - insets.left - insets.right, insets.bottom);
        NSRect bottomRight = NSMakeRect(imageSize.width - insets.right, 0, insets.right, insets.bottom);
        
        self.sliceRects = @[ [NSValue valueWithRect:topLeft],
                             [NSValue valueWithRect:topEdge],
                             [NSValue valueWithRect:topRight],
                             [NSValue valueWithRect:leftEdge],
                             [NSValue valueWithRect:center],
                             [NSValue valueWithRect:rightEdge],
                             [NSValue valueWithRect:bottomLeft],
                             [NSValue valueWithRect:bottomEdge],
                             [NSValue valueWithRect:bottomRight]];
    }
}

- (void)_generateInsetsFromSlices {
    if (self.renditionType == CoreThemeTypeThreePartVertical && self.sliceRects.count == 3) {
        CGRect topRect = [self.sliceRects[0] rectValue];
        CGRect bottomRect = [self.sliceRects[2] rectValue];
        
        _sliceInsets = TEIntegralInsets(NSEdgeInsetsMake(topRect.size.height, 0, bottomRect.size.height, 0));
        
    } else if (self.renditionType == CoreThemeTypeNinePart && self.sliceRects.count == 9) {
        CGRect topLeftRect = [self.sliceRects[0] rectValue];
        CGRect bottomRightRect = [self.sliceRects[8] rectValue];
        
        _sliceInsets = TEIntegralInsets(NSEdgeInsetsMake(topLeftRect.size.height, topLeftRect.size.width,
                                        bottomRightRect.size.height, bottomRightRect.size.width));
        
    } else if (self.renditionType == CoreThemeTypeThreePartHorizontal && self.sliceRects.count == 3) {
        CGRect leftRect = [self.sliceRects[0] rectValue];
        CGRect rightRect = [self.sliceRects[2] rectValue];
        
        _sliceInsets = TEIntegralInsets(NSEdgeInsetsMake(0, leftRect.size.width, 0, rightRect.size.width));
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self _repositionHandles];
    [CATransaction commit];
}

#pragma mark - Mouse Actions

- (void)mouseMoved:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *handle = [self.layer hitTest:viewPoint];
    
    if (handle == self.leftHandle || handle == self.rightHandle) {
        [[NSCursor resizeLeftRightCursor] push];
    } else if (handle == self.topHandle || handle == self.bottomHandle) {
        [[NSCursor resizeUpDownCursor] push];
    } else {
        [NSCursor pop];
    }
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *handle = [self.layer hitTest:viewPoint];
    if (handle == self.layer)
        return;
    
    self.dragHandle = handle;
    self.dragInsets = self.sliceInsets;
    self.dragPoint = viewPoint;
}

- (void)mouseDragged:(NSEvent *)event {
    if (!self.dragHandle)
        return;

    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    
    viewPoint.x = MAX(NSMinX(self.layer.frame), MIN(NSMaxX(self.layer.frame), viewPoint.x));
    viewPoint.y = MAX(NSMinY(self.layer.frame), MIN(NSMaxY(self.layer.frame), viewPoint.y));

    CGPoint delta = CGPointMake(viewPoint.x - self.dragPoint.x, viewPoint.y - self.dragPoint.y);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    NSEdgeInsets insets = self.dragInsets;
    if (self.dragHandle == self.leftHandle) {
        insets.left += delta.x;
        insets.left = MAX(0, MIN(self.image.pixelsWide - insets.right, insets.left));
        
    } else if (self.dragHandle == self.rightHandle) {
        insets.right -= delta.x;
        insets.right = MAX(0, MIN(self.image.pixelsWide - insets.left, insets.right));
        
    } else if (self.dragHandle == self.topHandle) {
        insets.top += delta.y;
        insets.top = MAX(0, MIN(self.image.pixelsHigh - insets.bottom, insets.top));
        
    } else if (self.dragHandle == self.bottomHandle) {
        insets.bottom -= delta.y;
        insets.bottom = MAX(0, MIN(self.image.pixelsHigh - insets.top, insets.bottom));
        
    }
    
    _sliceInsets = TEIntegralInsets(insets);
    [self _repositionHandles];
    
    [CATransaction commit];
    
    self.dragInsets = insets;
    self.dragPoint = viewPoint;
}

- (void)mouseUp:(NSEvent *)event {
    if (!self.dragHandle)
        return;
    
    NSEdgeInsets insets = _sliceInsets;
    self.sliceInsets = TEIntegralInsets(insets);
    
    self.dragHandle = nil;
    self.dragPoint = CGPointZero;
}

#pragma mark - Display

- (void)_toggleDisplay {
    
    // Keep our frame exactly the same size as the image
    NSSize frameSize = NSMakeSize(self.image.pixelsWide, self.image.pixelsHigh);
    NSRect frame = self.frame;
    frame.size = frameSize;
    
    switch (self.renditionType) {
        case CoreThemeTypeThreePartHorizontal: {
            self.topHandle.hidden    = YES;
            self.bottomHandle.hidden = YES;
            self.leftHandle.hidden   = NO;
            self.rightHandle.hidden  = NO;
            frame.size.width += 3.0 * sliceSpaceWidth;
            break;
        }
        case CoreThemeTypeThreePartVertical: {
            self.topHandle.hidden    = NO;
            self.bottomHandle.hidden = NO;
            self.leftHandle.hidden   = YES;
            self.rightHandle.hidden  = YES;
            frame.size.height += 3.0 * sliceSpaceWidth;
            break;
        }
        case CoreThemeTypeNinePart: {
            self.topHandle.hidden    = NO;
            self.bottomHandle.hidden = NO;
            self.leftHandle.hidden   = NO;
            self.rightHandle.hidden  = NO;
            frame.size.width  += 3.0 * sliceSpaceWidth;
            frame.size.height += 3.0 * sliceSpaceWidth;
            break;
        }
//        case CoreThemeTypeSixPart: {
//
//            break;
//        }
        default: {
            self.leftHandle.hidden   = YES;
            self.rightHandle.hidden  = YES;
            self.topHandle.hidden    = YES;
            self.bottomHandle.hidden = YES;
            break;
        }
    }
    
    self.frame = frame;
}

- (void)drawLayer:(nonnull CALayer *)layer inContext:(nonnull CGContextRef)ctx {
    if (layer == self.layer) {
        // draw our image sliced out
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:ctx flipped:self.layer.geometryFlipped]];
        
        NSEdgeInsets insets = self.sliceInsets;
        NSBitmapImageRep *image = self.image;
        
        if (self.renditionType == CoreThemeTypeThreePartHorizontal) {
            CGFloat widths[] = { insets.left, image.pixelsWide - insets.left - insets.right, insets.right };
            CGFloat currentSliceX = 0;
            CGFloat currentX      = 0;
            for (NSInteger i = 0; i < 3; i++) {
                CGFloat currentWidth  = widths[i];
                
                [image drawInRect:NSMakeRect(currentSliceX, 0, currentWidth, image.pixelsHigh)
                         fromRect:NSMakeRect(currentX, 0, currentWidth, image.pixelsHigh)
                        operation:NSCompositeSourceOver
                         fraction:1.0
                   respectFlipped:YES
                            hints:nil];
                
                currentSliceX += currentWidth + sliceSpaceWidth;
                currentX      += currentWidth;
            }
            
        } else if (self.renditionType == CoreThemeTypeThreePartVertical) {
            CGFloat heights[] = { insets.top,  image.pixelsHigh - insets.top - insets.bottom, insets.bottom};
            CGFloat currentSliceY = 0;
            CGFloat currentY      = 0;
            
            for (NSInteger i = 0; i < 3; i++) {
                CGFloat currentHeight = heights[i];
                
                [image drawInRect:NSMakeRect(0, currentSliceY, image.pixelsWide, currentHeight)
                         fromRect:NSMakeRect(0, currentY, image.pixelsWide, currentHeight)
                        operation:NSCompositeSourceOver
                         fraction:1.0
                   respectFlipped:YES
                            hints:nil];
                
                currentY      += currentHeight;
                currentSliceY += currentHeight + sliceSpaceWidth;
            }
            
        } else if (self.renditionType == CoreThemeTypeNinePart) {
            CGFloat widths[] = { insets.left, image.pixelsWide - insets.left - insets.right, insets.right };
            CGFloat heights[] = { insets.top,  image.pixelsHigh - insets.top - insets.bottom, insets.bottom};

            CGFloat currentSliceY = 0;
            CGFloat currentY      = 0;
            for (NSInteger y = 0; y < 3; y++) {
                CGFloat currentHeight = heights[y];
                
                CGFloat currentSliceX = 0;
                CGFloat currentX      = 0;
                for (NSInteger x = 0; x < 3; x++) {
                    CGFloat currentWidth = widths[x];
                    
                    [image drawInRect:NSMakeRect(currentSliceX, currentSliceY, currentWidth, currentHeight)
                             fromRect:NSMakeRect(currentX, currentY, currentWidth, currentHeight)
                            operation:NSCompositeSourceOver
                             fraction:1.0
                       respectFlipped:YES
                                hints:nil];
                    
                    currentSliceX += currentWidth + sliceSpaceWidth;
                    currentX      += currentWidth;
                }
                
                currentSliceY += currentHeight + sliceSpaceWidth;
                currentY      += currentHeight;
            }
            
            
        } else {
            [self.image drawInRect:layer.bounds
                          fromRect:NSZeroRect
                         operation:NSCompositeSourceOver
                          fraction:1.0
                    respectFlipped:YES
                             hints:nil];
        }
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (void)layoutSublayersOfLayer:(nonnull CALayer *)layer {
    // reposition the handles to keep in sync with the frame
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.handleLayer.frame = self.layer.bounds;
    
    if (layer == self.layer) {
        CGRect frame            = self.leftHandle.frame;
        frame.size.height       = self.bounds.size.height;
        frame.origin.y          = 0;
        self.leftHandle.frame   = frame;
        
        frame                   = self.rightHandle.frame;
        frame.origin.y          = 0;
        frame.size.height       = self.bounds.size.height;
        self.rightHandle.frame  = frame;
        
        frame                   = self.topHandle.frame;
        frame.origin.x          = 0;
        frame.size.width        = self.bounds.size.width;
        self.topHandle.frame    = frame;
        
        frame                   = self.bottomHandle.frame;
        frame.origin.x          = 0;
        frame.size.width        = self.bounds.size.width;
        self.bottomHandle.frame = frame;
    }
    [CATransaction commit];
}

#pragma mark - Re-evaluation

- (void)_repositionHandles {
    CGPoint pos                = self.leftHandle.position;
    pos.x                      = round(_sliceInsets.left);
    self.leftHandle.position   = pos;
    
    pos                        = self.topHandle.position;
    pos.y                      = round(_sliceInsets.top);
    self.topHandle.position    = pos;
    
    pos                        = self.rightHandle.position;
    pos.x                      = round(CGRectGetMaxX(self.layer.bounds) - _sliceInsets.right - sliceSpaceWidth);
    self.rightHandle.position  = pos;
    
    pos                        = self.bottomHandle.position;
    pos.y                      = round(CGRectGetMaxY(self.layer.bounds) - _sliceInsets.bottom - sliceSpaceWidth);
    self.bottomHandle.position = pos;
    
    [self.layer setNeedsDisplay];
}

- (void)setRenditionType:(CoreThemeType)renditionType {
    _renditionType = renditionType;
    [self _toggleDisplay];
    [self _generateInsetsFromSlices];
}

- (void)setSliceRects:(NSArray *)sliceRects {
    _sliceRects = sliceRects;
    
    [self _toggleDisplay];
    [self _generateInsetsFromSlices];
}

- (void)setImage:(NSBitmapImageRep *)image {
    if (!image) {
        // set placeholder image
    }
    _image = image;
    
    
    [self _toggleDisplay];
    [self.layer setNeedsDisplay];
    [self.layer setNeedsLayout];
    [self _generateInsetsFromSlices];
}

- (void)setEdgeInsets:(NSEdgeInsets)edgeInsets {
    _edgeInsets = TEIntegralInsets(edgeInsets);
    [self.layer setNeedsDisplay];
}

#pragma mark - Properties

//!TODO: Don't accept insets which are invalid, i.e. left inset extends past the right
- (CGFloat)leftHandlePosition {
    return self.sliceInsets.left;
}

- (void)setLeftHandlePosition:(CGFloat)leftHandlePosition {
    _sliceInsets.left = MIN(round(leftHandlePosition), self.image.pixelsWide - self.rightHandlePosition - 1.0);
    [self _repositionHandles];
    [self _generateSliceRectsFromInsets];
}

- (CGFloat)topHandlePosition {
    return self.sliceInsets.top;
}

- (void)setTopHandlePosition:(CGFloat)topHandlePosition {
    _sliceInsets.top = MIN(round(topHandlePosition), self.image.pixelsHigh - self.bottomHandlePosition - 1.0);
    [self _repositionHandles];
    [self _generateSliceRectsFromInsets];
}

- (CGFloat)rightHandlePosition {
    return self.sliceInsets.right;
}

- (void)setRightHandlePosition:(CGFloat)rightHandlePosition {
    _sliceInsets.right = MIN(round(rightHandlePosition), self.image.pixelsWide - self.leftHandlePosition - 1.0);
    [self _repositionHandles];
    [self _generateSliceRectsFromInsets];
}

- (CGFloat)bottomHandlePosition {
    return self.sliceInsets.bottom;
}

- (void)setBottomHandlePosition:(CGFloat)bottomHandlePosition {
    _sliceInsets.bottom = MIN(round(bottomHandlePosition), self.image.pixelsHigh - self.topHandlePosition - 1.0);
    [self _repositionHandles];
    [self _generateSliceRectsFromInsets];
}

- (void)setSliceInsets:(NSEdgeInsets)edgeInsets {
    _sliceInsets = TEIntegralInsets(edgeInsets);
    [self _repositionHandles];
    [self _generateSliceRectsFromInsets];
}

- (CGFloat)constrainLeftValue:(CGFloat)value {
    return MIN(round(value), self.image.pixelsWide - self.rightHandlePosition - 1.0);;
}

- (CGFloat)constrainTopValue:(CGFloat)value {
    return MIN(round(value), self.image.pixelsHigh - self.bottomHandlePosition - 1.0);
}

- (CGFloat)constrainRightValue:(CGFloat)value {
    return MIN(round(value), self.image.pixelsWide - self.leftHandlePosition - 1.0);
}

- (CGFloat)constrainBottomValue:(CGFloat)value {
    return MIN(round(value), self.image.pixelsHigh - self.topHandlePosition - 1.0);
}

- (BOOL)validateValue:(inout id  __nullable __autoreleasing * __nonnull)ioValue forKeyPath:(nonnull NSString *)inKeyPath error:(out NSError * __nullable __autoreleasing * __nullable)outError {
    NSLog(@"%@", inKeyPath);
    if ([inKeyPath hasSuffix:@"HandlePosition"]) {
        CGFloat newValue;
        CGFloat oldValue = ((NSNumber *)*ioValue).doubleValue;
        if ([inKeyPath isEqualToString:@"leftHandlePosition"]) {
            newValue = [self constrainLeftValue:oldValue];
            
        } else if ([inKeyPath isEqualToString:@"topHandlePosition"]) {
            newValue = [self constrainTopValue:oldValue];
            
        } else if ([inKeyPath isEqualToString:@"rightHandlePosition"]) {
            newValue = [self constrainRightValue:oldValue];
            
        } else if ([inKeyPath isEqualToString:@"bottomHandlePosition"]) {
            newValue = [self constrainBottomValue:oldValue];
            
        }
        
        *ioValue = [NSNumber numberWithDouble:newValue];
    }
    
    return [super validateValue:ioValue forKeyPath:inKeyPath error:outError];
}

#pragma mark - Appearance Properties

- (BOOL)hideHandles {
    return self.handleLayer.hidden;
}

- (void)setHideHandles:(BOOL)hideHandles {
    self.handleLayer.hidden = hideHandles;
}

- (void)setDrawsChecker:(BOOL)drawsChecker {
    _drawsChecker = drawsChecker;
    if (_drawsChecker) {
        self.enclosingScrollView.drawsBackground = NO;
        self.backgroundView.backgroundColor = [NSColor checkerPattern];
    } else {
        self.enclosingScrollView.drawsBackground = YES;
        self.backgroundView.backgroundColor = nil;
    }
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasSuffix:@"HandlePosition"]) {
        return [NSSet setWithObjects:@"sliceInsets", @"sliceRects", nil];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

+ (NSSet *)keyPathsForValuesAffectingHideHandles {
    return [NSSet setWithObject:@"handleLayer.hidden"];
}

@end
