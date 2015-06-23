//
//  TEGradientEditor.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEGradientEditor.h"
#import "TEGradientStopLayer.h"
#import "NSColor+TE.h"

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
- (void)_synchronizeMidpoints;

- (TEGradientStopLayer *)_addStop:(TKGradientStop *)stop colorStop:(BOOL)isColorStop;
- (void)_removeStopLayer:(TEGradientStopLayer *)layer;
- (TEGradientStopLayer *)layerForStop:(TKGradientStop *)stop;

- (void)createLayersForStops:(NSArray<TKGradientStop *> *)stops colors:(BOOL)colors;
- (void)createLayersForMidpoints:(NSArray<NSNumber *> *)midpoints colors:(BOOL)colors;

- (void)colorChanged:(NSColorPanel *)colorPanel;
- (void)noteStopChanged:(TKGradientStop *)stop;
@end

static const CGFloat kTEGradientEditorStopSize = 16.0;

const void *kTEGradientEditorSelectionContext  = &kTEGradientEditorSelectionContext;
const void *kTEGradientEditorLayoutContext     = &kTEGradientEditorLayoutContext;

@implementation TEGradientEditor

- (instancetype)initWithCoder:(NSCoder *)coder {
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

- (instancetype)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"gradient" context:&kTEGradientEditorLayoutContext];
    [self removeObserver:self forKeyPath:@"gradient.colorStops" context:&kTEGradientEditorLayoutContext];
    [self removeObserver:self forKeyPath:@"gradient.opacityStops" context:&kTEGradientEditorLayoutContext];
    [self removeObserver:self forKeyPath:@"gradient.colorMidpoints" context:&kTEGradientEditorLayoutContext];
    [self removeObserver:self forKeyPath:@"gradient.opacityMidpoints" context:&kTEGradientEditorLayoutContext];
    
    [self removeObserver:self forKeyPath:@"selectedStop" context:&kTEGradientEditorSelectionContext];
}

#pragma mark - Initialization

- (void)noteStopChanged:(TKGradientStop *)stop {
    [self setNeedsLayout:YES];

    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"gradient" options:0 context:&kTEGradientEditorLayoutContext];
    [self addObserver:self forKeyPath:@"gradient.colorStops" options:0 context:&kTEGradientEditorLayoutContext];
    [self addObserver:self forKeyPath:@"gradient.opacityStops" options:0 context:&kTEGradientEditorLayoutContext];
    [self addObserver:self forKeyPath:@"gradient.colorMidpoints" options:0 context:&kTEGradientEditorLayoutContext];
    [self addObserver:self forKeyPath:@"gradient.opacityMidpoints" options:0 context:&kTEGradientEditorLayoutContext];
    
    [self addObserver:self forKeyPath:@"selectedStop" options:NSKeyValueObservingOptionOld context:&kTEGradientEditorSelectionContext];
    
    self.colorStopLayers           = [NSMutableArray array];
    self.colorMidpointStopLayers   = [NSMutableArray array];
    self.opacityStopLayers         = [NSMutableArray array];
    self.opacityMidpointStopLayers = [NSMutableArray array];
    
    self.layer      = [CALayer layer];
    self.wantsLayer = YES;
    
    self.gradientLayer                  = [CALayer layer];
    self.gradientLayer.cornerRadius     = 8.0;
    self.gradientLayer.backgroundColor  = [[NSColor checkerPattern] CGColor];
    self.gradientLayer.delegate         = self;
    self.gradientLayer.frame            = self.layer.bounds;
    self.gradientLayer.autoresizingMask = kCALayerNotSizable;
    
    [self.layer addSublayer:self.gradientLayer];
    
    TKGradientColorStop *stop1 = [TKGradientColorStop colorStopWithLocation:0.0 color:NSColor.redColor];
    TKGradientColorStop *stop2 = [TKGradientColorStop colorStopWithLocation:1.0 color:NSColor.blueColor];
    TKGradientOpacityStop *opac1 = [TKGradientOpacityStop opacityStopWithLocation:0.0 opacity:1.0];
    TKGradientOpacityStop *opac2 = [TKGradientOpacityStop opacityStopWithLocation:1.0 opacity:1.0];
    
    self.gradient = [TKGradient gradientWithColorStops:@[ stop1, stop2 ]
                                          opacityStops:@[ opac1, opac2 ]
                                colorMidPointLocations:@[ @(0.5) ]
                              opacityMidPointLocations:@[  ]
                                                radial:NO
                                                 angle:-90
                                  smoothingCoefficient:1.0
                                       fillCoefficient:1.0];
    
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
        if ([keyPath isEqualToString:@"gradient"])
            self.selectedStop = nil;
        [self _repositionStops];
        
    }
}

#pragma mark - Layout

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self layout];
    
    [self.gradientLayer layoutIfNeeded];
    [self.gradientLayer displayIfNeeded];
    [CATransaction commit];
}

- (void)_synchronizeMidpoints {
    self.gradient.colorMidpoints = [self.colorMidpointStopLayers valueForKeyPath:@"gradientStop.location"];
    self.gradient.opacityMidpoints = [self.opacityMidpointStopLayers valueForKeyPath:@"gradientStop.location"];
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

- (void)layout {
    [super layout];
    self.gradientLayer.frame = NSInsetRect(self.bounds,
                                           kTEGradientEditorStopSize / 2,
                                           kTEGradientEditorStopSize / 2);
    
    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)layoutSublayersOfLayer:(CALayer *)superLayer {
    // Reposition stops
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    NSArray *sort = @[ [NSSortDescriptor sortDescriptorWithKey:@"gradientStop.location" ascending:YES] ];
    [self.colorStopLayers sortUsingDescriptors:sort];
    [self.opacityStopLayers sortUsingDescriptors:sort];
    
    for (TEGradientStopLayer *layer in self.colorStopLayers) {
        layer.position = CGPointMake(superLayer.bounds.size.width * layer.gradientStop.location, 0);
    }
    
    for (TEGradientStopLayer *layer in self.opacityStopLayers) {
        layer.position = CGPointMake(superLayer.bounds.size.width * layer.gradientStop.location, superLayer.bounds.size.height);
    }
    
    for (NSUInteger x = 0; x < self.colorMidpointStopLayers.count; x++) {
        TEGradientStopLayer *layer = self.colorMidpointStopLayers[x];
        TEGradientStopLayer *before = self.colorStopLayers[x];
        TEGradientStopLayer *after = self.colorStopLayers[x+1];
        
        layer.position = CGPointMake(before.position.x + (after.position.x - before.position.x) * layer.gradientStop.location, 0);
    }
    
    for (NSUInteger x = 0; x < self.opacityMidpointStopLayers.count; x++) {
        TEGradientStopLayer *layer = self.opacityMidpointStopLayers[x];
        TEGradientStopLayer *before = self.opacityStopLayers[x];
        TEGradientStopLayer *after = self.opacityStopLayers[x+1];
        
        layer.position = CGPointMake(before.position.x + (after.position.x - before.position.x) * layer.gradientStop.location, superLayer.bounds.size.height);
    }
    [CATransaction commit];
}

#pragma mark - Display

- (TEGradientStopLayer *)layerForStop:(TKGradientStop *)stop {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gradientStop == %@", stop];
    
    if (stop.isColorStop)
        return [[self.colorStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    
    else if (stop.isOpacityStop)
        return [[self.opacityStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    
    TEGradientStopLayer *layer = [[self.colorMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    if (!layer)
        layer = [[self.opacityMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    
    return layer;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self.gradient drawInRect:layer.bounds atAngle:0.0 withContext:ctx];
}

- (void)createLayersForStops:(NSArray<TKGradientStop *> *)stops colors:(BOOL)colors {
    NSMutableArray<TEGradientStopLayer *> *layers = colors ? self.colorStopLayers : self.opacityStopLayers;
    
    // Remove extra layers and re-use old ones
    while (layers.count > stops.count) {
        layers[0].gradientStop = nil;
        [self _removeStopLayer:layers[0]];
    }

    for (NSUInteger x = 0; x < stops.count; x++) {
        TKGradientStop *stop = stops[x];
        TEGradientStopLayer *layer = nil;
        if (x >= layers.count) {
            layer = [self _addStop:stop colorStop:colors];
        } else {
            layer = layers[x];
        }
        
        if (layer.gradientStop != stop)
            layer.gradientStop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)createLayersForMidpoints:(NSArray<NSNumber *> *)midpoints colors:(BOOL)colors {
    NSMutableArray<TEGradientStopLayer *> *layers = colors ? self.colorMidpointStopLayers : self.opacityMidpointStopLayers;
    
    // Remove extra layers and re-use old ones
    while (layers.count > midpoints.count) {
        layers[0].gradientStop = nil;
        [self _removeStopLayer:layers[0]];
    }
    
    for (NSUInteger x = 0; x < midpoints.count; x++) {
        
        TKGradientStop *stop = [[TKGradientStop alloc] init];
        stop.location = [midpoints[x] doubleValue];
        
        TEGradientStopLayer *layer = nil;
        if (x >= layers.count) {
            layer = [self _addStop:stop colorStop:colors];
        } else {
            layer = layers[x];
        }
        
        if (layer.gradientStop != stop)
            layer.gradientStop = stop;
        [layer setNeedsDisplay];
    }
}

- (TEGradientStopLayer *)_addStop:(TKGradientStop *)stop colorStop:(BOOL)isColorStop {
    TEGradientStopLayer *layer = [TEGradientStopLayer layer];
    layer.gradientStop         = stop;
    layer.frame                = CGRectMake(0, 0, kTEGradientEditorStopSize, kTEGradientEditorStopSize);
    layer.anchorPoint          = CGPointMake(0.5, 0.5);

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
    if (layer.gradientStop == self.selectedStop)
        self.selectedStop = nil;
    
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

    [self.window.undoManager beginUndoGrouping];
    
    if (hitLayer != self.gradientLayer && hitLayer) {
        self.selectedStop = ((TEGradientStopLayer *)hitLayer).gradientStop;
        
        if (event.clickCount > 1 && [self.selectedStop isKindOfClass:[TKGradientColorStop class]]) {
            NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
            colorPanel.showsAlpha = YES;
            colorPanel.continuous = YES;
            colorPanel.color      = self.selectedStop.color;
            
            [colorPanel setTarget:self];
            [colorPanel setAction:@selector(colorChanged:)];
            [colorPanel orderFront:self];
            
        } else {
            self.draggedLayer = (TEGradientStopLayer *)hitLayer;
            
            if ([self.opacityMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.opacityMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.opacityStopLayers[x];
                self.afterLayer = self.opacityStopLayers[x + 1];
                
            } else if ([self.colorMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.colorMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.colorStopLayers[x];
                self.afterLayer = self.colorStopLayers[x + 1];
                
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
        
        // Add a new opacity stop
        if (viewPoint.y > NSMaxY(self.gradientLayer.frame)) {
            stop = [TKGradientOpacityStop opacityStopWithLocation:location opacity:color.alphaComponent];
            [self.gradient addOpacityStop:(TKGradientOpacityStop *)stop];
        
        // Add a new color stop
        } else if (viewPoint.y < NSMinY(self.gradientLayer.frame)) {
            stop = [TKGradientColorStop colorStopWithLocation:location color:color];
            [self.gradient addColorStop:(TKGradientColorStop *)stop];
        }
        
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
        
        // limit the midpoint stop to be between its neighbors
        if (self.afterLayer && self.beforeLayer) {
            self.draggedLayer.gradientStop.location =
            MAX(MIN((viewPoint.x - self.beforeLayer.position.x) /
                    (self.afterLayer.position.x - self.beforeLayer.position.x), 0.99), 0.01);
        } else {
            // otherwise drag anywhere
            self.draggedLayer.gradientStop.location = MAX(MIN(viewPoint.x / self.bounds.size.width, 1), 0);
        }
        
        [self _synchronizeMidpoints];
    }
}

- (void)mouseUp:(NSEvent *)event {
    if ([[NSCursor currentCursor] isEqual:[NSCursor disappearingItemCursor]]) {
        // remove it
        if (self.draggedLayer.gradientStop.isColorStop)
            [self.gradient removeColorStop:(TKGradientColorStop *)self.draggedLayer.gradientStop];
        else
            [self.gradient removeOpacityStop:(TKGradientOpacityStop *)self.draggedLayer.gradientStop];
        [self _removeStopLayer:self.draggedLayer];
        
        [self _repositionStops];
        
        NSShowAnimationEffect(NSAnimationEffectPoof,
                              [NSEvent mouseLocation],
                              NSZeroSize,
                              [NSCursor arrowCursor],
                              @selector(set),
                              nil);
        [NSCursor setHiddenUntilMouseMoves:YES];
        
    }
    
    [self _synchronizeMidpoints];
    self.draggedLayer = nil;
    self.beforeLayer = nil;
    self.afterLayer = nil;
    [self.window.undoManager endUndoGrouping];
}

- (void)colorChanged:(NSColorPanel *)colorPanel {
    if ([self.selectedStop isKindOfClass:[TKGradientColorStop class]]) {
        self.selectedStop.color = colorPanel.color;
    }
}

// Animate transitions between gradients with displays
- (id <CAAction>)actionForLayer:(nonnull CALayer *)layer forKey:(nonnull NSString *)event {
    CATransition *theAnimation = nil;
    
    if ([event isEqualToString:@"contents"]) {
        
        theAnimation = [[CATransition alloc] init];
        theAnimation.duration = 0.15;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        theAnimation.type = kCATransitionFade;
    }
    return theAnimation;
}


@end
