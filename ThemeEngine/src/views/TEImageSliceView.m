//
//  CHImageSliceView.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEImageSliceView.h"

@interface TEImageSliceView ()
@property (strong) CALayer *sliceLayer;
@property (strong) CALayer *leftHandle;
@property (strong) CALayer *rightHandle;
@property (strong) CALayer *topHandle;
@property (strong) CALayer *bottomHandle;

@property (assign) NSPoint currentPosition;
@property (weak) CALayer *currentDragHandle;
@property (assign) NSEdgeInsets currentInsets;

- (void)_initialize;
- (void)_repositionHandles;
- (void)_generateInsetsFromSlices;
- (void)_toggleDisplay;
- (void)_generateSlicesFromInsets;
@end

@interface IKImageView (Private)
- (CALayer *)imageLayer;
@end

@implementation TEImageSliceView

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        [self _initialize];
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

- (void)setZoomFactor:(CGFloat)zoomFactor {
    [super setZoomFactor:zoomFactor];
    self.frameSize = NSMakeSize(self.imageSize.width * zoomFactor, self.imageSize.height * self.zoomFactor);
    self.sliceLayer.frame = self.imageLayer.frame;
    [self _repositionHandles];
}

- (void)setImage:(CGImageRef)image imageProperties:(NSDictionary *)metaData {
    [super setImage:image imageProperties:metaData];
    self.zoomFactor = self.zoomFactor;
}

- (void)setBounds:(NSRect)bounds {
    [super setBounds:bounds];
}

static void *kTypeContext;
static void *kSliceRectContext;
static void *kSlicingContext;
static void *kInsetsContext;
#define kHandleSize 3
#define kSliceBuffer 1

- (void)_initialize {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.sliceLayer = [CALayer layer];
    self.sliceLayer.frame = self.bounds;
    self.sliceLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMinXMargin | kCALayerMaxXMargin | kCALayerMinYMargin | kCALayerMaxYMargin;
    
    // Fix weird imagekit bug
    [self setImageWithURL:nil];
    
    [self addObserver:self forKeyPath:@"themeType" options:0 context:&kTypeContext];
    [self addObserver:self forKeyPath:@"sliceRects" options:0 context:&kSliceRectContext];
    [self addObserver:self forKeyPath:@"slicing" options:0 context:&kSlicingContext];
    [self addObserver:self forKeyPath:@"edgeInsets" options:0 context:&kInsetsContext];
    
    [self setOverlay:self.sliceLayer forType:IKOverlayTypeImage];
    
    self.leftHandle = [CALayer layer];
    self.leftHandle.autoresizingMask = kCALayerHeightSizable | kCALayerMinYMargin | kCALayerMaxYMargin;
    self.leftHandle.anchorPoint = CGPointMake(0.5, 0.0);
    self.leftHandle.name = @"lefthandle";
    self.leftHandle.borderWidth = 1.0;
    self.leftHandle.borderColor = [[[NSColor blackColor] colorWithAlphaComponent:0.4] CGColor];
    self.leftHandle.backgroundColor = [[NSColor whiteColor] CGColor];
    [self.sliceLayer addSublayer:self.leftHandle];
    
    self.rightHandle = [CALayer layer];
    self.rightHandle.autoresizingMask = kCALayerHeightSizable | kCALayerMinYMargin | kCALayerMaxYMargin;
    self.rightHandle.anchorPoint = CGPointMake(0.5, 0.0);
    self.rightHandle.name = @"righthandle";
    self.rightHandle.borderWidth = 1.0;
    self.rightHandle.borderColor = self.leftHandle.borderColor;
    self.rightHandle.backgroundColor = self.leftHandle.backgroundColor;
    [self.sliceLayer addSublayer:self.rightHandle];
    
    self.topHandle = [CALayer layer];
    self.topHandle.autoresizingMask = kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMaxXMargin;
    self.topHandle.anchorPoint = CGPointMake(0.0, 0.5);
    self.topHandle.name = @"tophandle";
    self.topHandle.borderWidth = 1.0;
    self.topHandle.borderColor = self.leftHandle.borderColor;
    self.topHandle.backgroundColor = self.leftHandle.backgroundColor;
    [self.sliceLayer addSublayer:self.topHandle];
    
    self.bottomHandle = [CALayer layer];
    self.bottomHandle.autoresizingMask = kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMaxXMargin;
    self.bottomHandle.anchorPoint = CGPointMake(0.0, 0.5);
    self.bottomHandle.name = @"bottomhandle";
    self.bottomHandle.borderWidth = 1.0;
    self.bottomHandle.borderColor = self.leftHandle.borderColor;
    self.bottomHandle.backgroundColor = self.leftHandle.backgroundColor;
    [self.sliceLayer addSublayer:self.bottomHandle];
    
    [self _toggleDisplay];
    self.slicing = YES;
}

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInActiveApp | NSTrackingMouseMoved owner:self userInfo:nil]];
}

- (void)dealloc {
    [self removeTrackingArea:self.trackingAreas[0]];
    [self removeObserver:self forKeyPath:@"themeType"];
    [self removeObserver:self forKeyPath:@"sliceRects"];
    [self removeObserver:self forKeyPath:@"slicing"];
    [self removeObserver:self forKeyPath:@"edgeInsets"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kTypeContext) {
        [self _toggleDisplay];
        [self _generateInsetsFromSlices];
    } else if (context == &kSliceRectContext) {
        [self _toggleDisplay];
        [self _generateInsetsFromSlices];
    } else if (context == &kSlicingContext) {
        [self _toggleDisplay];
    } else if (context ==&kInsetsContext) {
        [self _repositionHandles];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_toggleDisplay {
    if (self.themeType != kCoreThemeTypeNinePart &&
        self.themeType != kCoreThemeTypeThreePartHorizontal &&
        self.themeType != kCoreThemeTypeThreePartVertical)
        self.sliceLayer.hidden = YES;
    else {
        self.sliceLayer.hidden = !self.isSlicing;
    }
    
    if (self.themeType == kCoreThemeTypeThreePartVertical) {
        self.leftHandle.hidden = YES;
        self.rightHandle.hidden = YES;
        self.topHandle.hidden = NO;
        self.bottomHandle.hidden = NO;
    } else if (self.themeType == kCoreThemeTypeThreePartHorizontal) {
        self.leftHandle.hidden = NO;
        self.rightHandle.hidden = NO;
        self.topHandle.hidden = YES;
        self.bottomHandle.hidden = YES;
    } else if (self.themeType == kCoreThemeTypeNinePart) {
        self.leftHandle.hidden = NO;
        self.rightHandle.hidden = NO;
        self.topHandle.hidden = NO;
        self.bottomHandle.hidden = NO;
    }
}

- (void)_generateInsetsFromSlices {
    if (self.themeType == kCoreThemeTypeThreePartVertical && self.sliceRects.count == 3) {
        CGRect topRect = [self.sliceRects[0] rectValue];
        CGRect bottomRect = [self.sliceRects[2] rectValue];
        
        self.edgeInsets = NSEdgeInsetsMake(topRect.size.height, 0, bottomRect.size.height, 0);
    } else if (self.themeType == kCoreThemeTypeNinePart && self.sliceRects.count == 9) {
        CGRect topLeftRect = [self.sliceRects[0] rectValue];
        CGRect bottomRightRect = [self.sliceRects[8] rectValue];
        
        self.edgeInsets = NSEdgeInsetsMake(topLeftRect.size.height, topLeftRect.size.width, bottomRightRect.size.height, bottomRightRect.size.width);
    } else if (self.themeType == kCoreThemeTypeThreePartHorizontal && self.sliceRects.count == 3) {
        CGRect leftRect = [self.sliceRects[0] rectValue];
        CGRect rightRect = [self.sliceRects[2] rectValue];
        
        self.edgeInsets = NSEdgeInsetsMake(0, leftRect.size.width, 0, rightRect.size.width);
    }
}

- (void)_repositionHandles {
    self.leftHandle.bounds =  CGRectMake(0, 0, kHandleSize, self.imageSize.height);
    self.rightHandle.bounds = CGRectMake(0, 0, kHandleSize, self.imageSize.height);
    
    self.leftHandle.position =  CGPointMake(round(self.edgeInsets.left), 0);
    self.rightHandle.position = CGPointMake(round(NSMaxX(self.sliceLayer.bounds) - self.edgeInsets.right), 0);
    
    self.topHandle.bounds = CGRectMake(0, 0, self.imageSize.width, kHandleSize);
    self.bottomHandle.bounds = CGRectMake(0, 0, self.imageSize.width, kHandleSize);
    
    self.topHandle.position = CGPointMake(0, round(NSMaxY(self.sliceLayer.bounds) - self.edgeInsets.top));
    self.bottomHandle.position = CGPointMake(0, round(self.edgeInsets.bottom));
}

- (void)mouseMoved:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *handle = [self.sliceLayer hitTest:viewPoint];
    
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
    CALayer *handle = [self.sliceLayer hitTest:viewPoint];
    if (handle == self.sliceLayer)
        return;
    
    self.currentDragHandle = handle;
    self.currentInsets = self.edgeInsets;
    self.currentPosition = viewPoint;
}

- (void)mouseDragged:(NSEvent *)event {
    if (!self.currentDragHandle)
        return;
    
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    
    viewPoint.x = MAX(NSMinX(self.sliceLayer.frame), MIN(NSMaxX(self.sliceLayer.frame), viewPoint.x));
    viewPoint.y = MAX(NSMinY(self.sliceLayer.frame), MIN(NSMaxY(self.sliceLayer.frame), viewPoint.y));
    
    CGPoint delta = CGPointMake(viewPoint.x - self.currentPosition.x, viewPoint.y - self.currentPosition.y);
    delta.x /= self.zoomFactor;
    delta.y /= self.zoomFactor;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    NSEdgeInsets insets = self.currentInsets;
    if (self.currentDragHandle == self.leftHandle) {
        insets.left += delta.x;
        insets.left = MAX(0, MIN(self.imageSize.width - insets.right - kSliceBuffer, insets.left));
    } else if (self.currentDragHandle == self.rightHandle) {
        insets.right -= delta.x;
        insets.right = MAX(0, MIN(self.imageSize.width - insets.left - kSliceBuffer, insets.right));
    } else if (self.currentDragHandle == self.topHandle) {
        insets.top -= delta.y;
        insets.top = MAX(0, MIN(self.imageSize.height - insets.bottom - kSliceBuffer, insets.top));
    } else if (self.currentDragHandle == self.bottomHandle) {
        insets.bottom += delta.y;
        insets.bottom = MAX(0, MIN(self.imageSize.height - insets.top - kSliceBuffer, insets.bottom));
    }
    
    self.edgeInsets = self.currentInsets;

    [CATransaction commit];
    self.currentInsets = insets;
    self.currentPosition = viewPoint;
}

- (void)mouseUp:(NSEvent *)event {
    if (!self.currentDragHandle)
        return;
    
    [self _generateSlicesFromInsets];
    
    self.currentDragHandle = nil;
    self.currentPosition = CGPointZero;
}

- (void)_generateSlicesFromInsets {
    if (self.themeType == kCoreThemeTypeThreePartHorizontal) {
        NSRect left = NSMakeRect(0, 0, self.edgeInsets.left, self.imageSize.height);
        NSRect middle = NSMakeRect(self.edgeInsets.left, 0, self.imageSize.width - self.edgeInsets.left - self.edgeInsets.right, self.imageSize.height);
        NSRect right = NSMakeRect(self.imageSize.width - self.edgeInsets.right, 0, self.edgeInsets.right, self.imageSize.height);
        
        self.sliceRects = @[ [NSValue valueWithRect:left], [NSValue valueWithRect:middle], [NSValue valueWithRect:right] ];
    } else if (self.themeType == kCoreThemeTypeThreePartVertical) {
        NSRect top = NSMakeRect(0, self.imageSize.height - self.edgeInsets.top, self.imageSize.width, self.edgeInsets.top);
        NSRect middle = NSMakeRect(0, self.edgeInsets.bottom, self.imageSize.width, self.imageSize.height - self.edgeInsets.top - self.edgeInsets.bottom);
        NSRect bottom = NSMakeRect(0, 0, self.imageSize.width, self.edgeInsets.bottom);
        
        self.sliceRects = @[ [NSValue valueWithRect:top], [NSValue valueWithRect:middle], [NSValue valueWithRect:bottom] ];
    } else if (self.themeType == kCoreThemeTypeNinePart) {
        NSRect topLeft = NSMakeRect(0, self.imageSize.height - self.edgeInsets.top, self.edgeInsets.left, self.edgeInsets.top);
        NSRect topEdge = NSMakeRect(self.edgeInsets.left, topLeft.origin.y, self.imageSize.width - self.edgeInsets.left - self.edgeInsets.right, self.edgeInsets.top);
        NSRect topRight = NSMakeRect(self.imageSize.width - self.edgeInsets.right, topLeft.origin.y, self.edgeInsets.right, self.edgeInsets.top);
        NSRect leftEdge = NSMakeRect(0, self.edgeInsets.bottom, self.edgeInsets.left, self.imageSize.height - self.edgeInsets.top - self.edgeInsets.bottom);
        NSRect center = NSMakeRect(self.edgeInsets.left, self.edgeInsets.bottom, self.imageSize.width - self.edgeInsets.left - self.edgeInsets.right, self.imageSize.height - self.edgeInsets.top - self.edgeInsets.bottom);
        NSRect rightEdge = NSMakeRect(self.imageSize.width - self.edgeInsets.right, self.edgeInsets.bottom, self.edgeInsets.right, self.imageSize.height - self.edgeInsets.top - self.edgeInsets.bottom);
        NSRect bottomLeft = NSMakeRect(0, 0, self.edgeInsets.left, self.edgeInsets.bottom);
        NSRect bottomEdge = NSMakeRect(self.edgeInsets.left, 0, self.imageSize.width - self.edgeInsets.left - self.edgeInsets.right, self.edgeInsets.bottom);
        NSRect bottomRight = NSMakeRect(self.imageSize.width - self.edgeInsets.right, 0, self.edgeInsets.right, self.edgeInsets.bottom);
        
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

@end
