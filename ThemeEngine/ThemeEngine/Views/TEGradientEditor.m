//
//  TEGradientEditor.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEGradientEditor.h"
#import "TEGradientStopLayer.h"

@interface TEGradientEditor ()
@property (strong) CALayer *gradientLayer;

@property (strong) NSMutableArray *colorStopLayers;
@property (strong) NSMutableArray *opacityStopLayers;
@property (strong) NSMutableArray *colorMidpointStopLayers;
@property (strong) NSMutableArray *opacityMidpointStopLayers;

@property (weak) TEGradientStopLayer *draggedLayer;
@property (weak) TEGradientStopLayer *beforeLayer;
@property (weak) TEGradientStopLayer *afterLayer;

@property (readwrite, strong) TKGradientStop *selectedStop;

- (void)_initialize;
- (void)_repositionStops;
- (void)_invalidateGradient;

- (void)_startObservingStop:(TKGradientStop *)stop;
- (void)_stopObservingStop:(TKGradientStop *)stop;

- (TEGradientStopLayer *)_addStop:(TKGradientStop *)stop colorStop:(BOOL)isColorStop;
- (void)_removeStopLayer:(TEGradientStopLayer *)layer;
- (TEGradientStopLayer *)layerForStop:(TKGradientStop *)stop;

- (void)createLayersForStops:(NSArray<TKGradientStop *> *)stops colors:(BOOL)colors;
- (void)createLayersForMidpoints:(NSArray<NSNumber *> *)midpoints colors:(BOOL)colors;

- (void)colorChanged:(NSColorPanel *)colorPanel;
@end

static const CGFloat kTEGradientEditorStopSize = 16.0;

const void *kTEGradientEditorSelectionContext  = &kTEGradientEditorSelectionContext;
const void *kTEGradientEditorInvalidateContext = &kTEGradientEditorInvalidateContext;
const void *kTEGradientEditorLayoutContext     = &kTEGradientEditorLayoutContext;

@implementation TEGradientEditor

#pragma mark - Initialization

- (void)_initialize {
    [self addObserver:self forKeyPath:@"gradient" options:0 context:&kTEGradientEditorLayoutContext];
    [self addObserver:self forKeyPath:@"selectedStop" options:NSKeyValueObservingOptionOld context:&kTEGradientEditorSelectionContext];
    
    self.colorStopLayers           = [NSMutableArray array];
    self.colorMidpointStopLayers   = [NSMutableArray array];
    self.opacityStopLayers         = [NSMutableArray array];
    self.opacityMidpointStopLayers = [NSMutableArray array];
    
    self.layer      = [CALayer layer];
    self.wantsLayer = YES;
    
    NSImage *checkerImage = [NSImage imageWithSize:NSMakeSize(24, 24)
                                           flipped:YES
                                    drawingHandler:^BOOL(NSRect dstRect) {
                                        CGFloat size = dstRect.size.width / 2;
                                        [[NSColor lightGrayColor] set];
                                        NSRectFill(NSMakeRect(0, 0, size, size));
                                        NSRectFill(NSMakeRect(size, size, size, size));
                                        
                                        [[NSColor whiteColor] set];
                                        NSRectFill(NSMakeRect(size, 0, size, size));
                                        NSRectFill(NSMakeRect(0, size, size, size));
                                        
                                        return YES;
                                    }];
    
    
    self.gradientLayer                  = [CALayer layer];
    self.gradientLayer.cornerRadius     = 8.0;
    self.gradientLayer.backgroundColor  = [[NSColor colorWithPatternImage:checkerImage] CGColor];
    self.gradientLayer.delegate         = self;
    self.gradientLayer.frame            = self.layer.bounds;
    self.gradientLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable |
                                          kCALayerMaxXMargin | kCALayerMaxYMargin |
                                          kCALayerMinXMargin | kCALayerMinYMargin;
    [self.layer addSublayer:self.gradientLayer];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary *)change
                       context:(nullable void *)context {
    
    if (context == &kTEGradientEditorSelectionContext) {
        TKGradientStop *oldStop = change[NSKeyValueChangeOldKey];
        
        if ([oldStop isKindOfClass:[NSNull class]])
            oldStop = nil;
        
        [self layerForStop:oldStop].selected = NO;
        [self layerForStop:self.selectedStop].selected = YES;
        
    } else if (context == &kTEGradientEditorLayoutContext) {
        [self _repositionStops];
        
    } else if (context == &kTEGradientEditorInvalidateContext) {
        [self _invalidateGradient];
        [self.gradientLayer setNeedsDisplay];
    }
}

#pragma mark - Display

- (TEGradientStopLayer *)layerForStop:(TKGradientStop *)stop {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop == %@", stop];
    
    if (stop.isColorStop)
        return [[self.colorStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    
    else if (stop.isOpacityStop)
        return [[self.opacityStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    
    TEGradientStopLayer *layer = [[self.colorMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];;
    if (!layer)
        layer = [[self.opacityMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];;
    return layer;
}

- (void)_invalidateGradient {
    // Remove CUIThemeGradient's cached shader so it generates a new drawing method
    
    [self.gradient resetShaders];
    [self.gradientLayer setNeedsDisplay];
}

- (void)createLayersForStops:(NSArray<TKGradientStop *> *)stops colors:(BOOL)colors {
    NSMutableArray *layers = colors ? self.colorStopLayers : self.opacityStopLayers;
    
    // Remove extra layers and re-use old ones
    while (layers.count > stops.count) {
        [self _removeStopLayer:layers[0]];
    }
    
    for (NSUInteger x = 0; x < stops.count; x++) {
        TKGradientStop *stop = stops[x];
        TEGradientStopLayer *layer = nil;
        if (x >= self.colorStopLayers.count) {
            layer = [self _addStop:stop colorStop:colors];
        } else {
            layer = layers[x];
            [self _stopObservingStop:layer.gradientStop];
            [self _startObservingStop:stop];
        }
        
        layer.gradientStop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)createLayersForMidpoints:(NSArray<NSNumber *> *)midpoints colors:(BOOL)colors {
    NSMutableArray *layers = colors ? self.colorStopLayers : self.opacityStopLayers;
    
    // Remove extra layers and re-use old ones
    while (layers.count > midpoints.count) {
        [self _removeStopLayer:layers[0]];
    }
    
    for (NSUInteger x = 0; x < midpoints.count; x++) {
        
        TKGradientStop *stop = [[TKGradientStop alloc] init];
        stop.location = [midpoints[x] doubleValue];
        
        TEGradientStopLayer *layer = nil;
        if (x >= self.colorStopLayers.count) {
            layer = [self _addStop:stop colorStop:colors];
        } else {
            layer = layers[x];
            [self _stopObservingStop:layer.gradientStop];
            [self _startObservingStop:stop];
        }
        
        layer.gradientStop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)_repositionStops {
    [self createLayersForStops:self.gradient.colorStops colors:YES];
    [self createLayersForStops:self.gradient.opacityStops colors:NO];
    // Add implicit midpoints
    NSMutableArray *midpoints = self.gradient.colorMidpoints.mutableCopy ?: [NSMutableArray array];
    if (self.gradient.colorStops.count > 0) {
        while (midpoints.count != self.gradient.colorStops.count - 1) {
            if (midpoints.count < self.gradient.colorStops.count - 1)
                [midpoints addObject:@0.5];
            else
                [midpoints removeLastObject];
        }
    } else {
        midpoints = [NSMutableArray array];
    }
    
    [self createLayersForMidpoints:midpoints colors:YES];
    
    midpoints = self.gradient.opacityMidpoints.mutableCopy ?: [NSMutableArray array];
    if (self.gradient.opacityStops.count > 0)
        while (midpoints.count != self.gradient.opacityStops.count - 1) {
            if (midpoints.count < self.gradient.opacityStops.count)
                [midpoints addObject:@0.5];
            else
                [midpoints removeLastObject];
        } else {
            midpoints = [NSMutableArray array];
        }
    
    [self createLayersForMidpoints:midpoints colors:NO];
    
    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)_startObservingStop:(TKGradientStop *)stop {
    [stop addObserver:self forKeyPath:@"color" options:0 context:&kTEGradientEditorInvalidateContext];
    [stop addObserver:self forKeyPath:@"opacity" options:0 context:&kTEGradientEditorInvalidateContext];
    [stop addObserver:self forKeyPath:@"leadOutOpacity" options:0 context:&kTEGradientEditorInvalidateContext];
    [stop addObserver:self forKeyPath:@"leadOutColor" options:0 context:&kTEGradientEditorInvalidateContext];
    [stop addObserver:self forKeyPath:@"location" options:0 context:&kTEGradientEditorInvalidateContext];
}

- (void)_stopObservingStop:(TKGradientStop *)stop {
    if (stop == self.selectedStop)
        self.selectedStop = nil;
    
    [stop removeObserver:self forKeyPath:@"color" context:&kTEGradientEditorInvalidateContext];
    [stop removeObserver:self forKeyPath:@"opacity" context:&kTEGradientEditorInvalidateContext];
    [stop removeObserver:self forKeyPath:@"leadOutOpacity" context:&kTEGradientEditorInvalidateContext];
    [stop removeObserver:self forKeyPath:@"leadOutColor" context:&kTEGradientEditorInvalidateContext];
    [stop removeObserver:self forKeyPath:@"location" context:&kTEGradientEditorInvalidateContext];
}


- (TEGradientStopLayer *)_addStop:(TKGradientStop *)stop colorStop:(BOOL)isColorStop {
    TEGradientStopLayer *layer = [TEGradientStopLayer layer];
    layer.gradientStop = stop;
    [self _startObservingStop:stop];
    layer.frame = CGRectMake(0, 0, kTEGradientEditorStopSize, kTEGradientEditorStopSize);
    
    BOOL midpoint = !stop.isColorStop && !stop.isOpacityStop;
    
    if (midpoint)
        layer.zPosition = 1;
    else
        layer.zPosition = 1000;
    
    if (isColorStop) {
        if (midpoint)
            [self.colorMidpointStopLayers addObject:layer];
        else
            [self.colorStopLayers addObject:layer];
    } else {
        if (midpoint)
            [self.opacityMidpointStopLayers addObject:layer];
        else
            [self.opacityStopLayers addObject:layer];
    }
    
    [self.gradientLayer addSublayer:layer];
    
    return layer;
}

- (void)_removeStopLayer:(TEGradientStopLayer *)layer {
    [self _stopObservingStop:layer.gradientStop];
    
    [layer removeFromSuperlayer];
    //!TODO: Filter this down based on the gradientStop
    if ([self.colorStopLayers containsObject:layer])
        [self.colorStopLayers removeObject:layer];
    if ([self.colorMidpointStopLayers containsObject:layer])
        [self.colorMidpointStopLayers removeObject:layer];
    if ([self.opacityStopLayers containsObject:layer])
        [self.opacityStopLayers removeObject:layer];
    if ([self.opacityMidpointStopLayers containsObject:layer])
        [self.opacityMidpointStopLayers removeObject:layer];
}

#pragma mark - Mouse Actions

- (void)mouseDown:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *hitLayer = [self.gradientLayer hitTest:viewPoint];
    if (hitLayer != self.gradientLayer && hitLayer) {
        self.selectedStop = ((TEGradientStopLayer *)hitLayer).gradientStop;
        
        if (event.clickCount > 1 && [self.selectedStop isKindOfClass:[TKGradientColorStop class]]) {
            NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
            colorPanel.showsAlpha = YES;
            colorPanel.continuous = YES;
            colorPanel.color = self.selectedStop.color;
            [colorPanel setTarget:self];
            [colorPanel setAction:@selector(colorChanged:)];
            [colorPanel orderFront:self];
        } else {
            self.draggedLayer = (TEGradientStopLayer *)hitLayer;
            
            if ([self.opacityMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.opacityMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.opacityStopLayers[x];
                self.afterLayer = self.opacityStopLayers[x+1];
                
            } else if ([self.colorMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.colorMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.colorStopLayers[x];
                self.afterLayer = self.colorStopLayers[x+1]
                ;
            } else {
                self.beforeLayer = nil;
                self.afterLayer = nil;
                
            }
        }
    } else if (!hitLayer) {
        // We hit the "track", add a new stop depending on where
        CGFloat location = (viewPoint.x - self.gradientLayer.bounds.origin.x) / (self.bounds.size.width - self.gradientLayer.bounds.origin.x * 2);
        NSColor *color = [self.gradient interpolatedColorAtLocation:location];
        TKGradientStop *stop = nil;
        TEGradientStopLayer *layer = nil;
        if (viewPoint.y > NSMaxY(self.gradientLayer.frame)) {
            stop = [TKGradientOpacityStop opacityStopWithLocation:location opacity:color.alphaComponent];
            layer = [self _addStop:stop colorStop:NO];
        } else if (viewPoint.y < NSMinY(self.gradientLayer.frame)) {
            stop = [TKGradientColorStop colorStopWithLocation:location color:color];
            layer = [self _addStop:stop colorStop:YES];
        }
        
        [self _invalidateGradient];
        [self _repositionStops];
        
        self.selectedStop = stop;
        self.draggedLayer = [self layerForStop:stop];
    } else  {
        [super mouseDown:event];
    }
}

- (void)mouseDragged:(NSEvent *)event {
    if (!self.draggedLayer) {
        [super mouseDragged:event];
        return;
    }
    
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    
    if (!NSPointInRect(viewPoint, NSInsetRect(self.bounds, -kTEGradientEditorStopSize, -kTEGradientEditorStopSize)) &&
        !self.beforeLayer &&
        (([self.opacityStopLayers containsObject:self.draggedLayer] && self.opacityStopLayers.count > 2) ||
         ([self.colorStopLayers containsObject:self.draggedLayer] && self.colorStopLayers.count > 2))) {
        [[NSCursor disappearingItemCursor] push];
            
    } else {
        [[NSCursor arrowCursor] set];
        if (self.afterLayer && self.beforeLayer) {
            self.draggedLayer.gradientStop.location = MAX(MIN((viewPoint.x - self.beforeLayer.position.x) / (self.afterLayer.position.x - self.beforeLayer.position.x), 1), 0);
            
        } else {
            self.draggedLayer.gradientStop.location = MAX(MIN(viewPoint.x / self.bounds.size.width, 1), 0);
        }
    }
}

- (void)mouseUp:(NSEvent *)event {
    if ([[NSCursor currentCursor] isEqual:[NSCursor disappearingItemCursor]]) {
        [self _removeStopLayer:self.draggedLayer];
        
        [self _invalidateGradient];
        [self _repositionStops];
        NSShowAnimationEffect(NSAnimationEffectPoof,
                              [NSEvent mouseLocation],
                              NSZeroSize,
                              [NSCursor arrowCursor],
                              @selector(set),
                              nil);
        [NSCursor setHiddenUntilMouseMoves:YES];
        
    }
    self.draggedLayer = nil;
    self.beforeLayer = nil;
    self.afterLayer = nil;
}

- (void)colorChanged:(NSColorPanel *)colorPanel {
    if ([self.selectedStop isKindOfClass:[TKGradientColorStop class]]) {
        self.selectedStop.color = colorPanel.color;
    }
}


@end
