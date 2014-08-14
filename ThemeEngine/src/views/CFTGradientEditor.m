//
//  CFTGradientEditor.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradientEditor.h"
@import QuartzCore.CATransaction;
#import <objc/runtime.h>

#define kCFTStopSize 16.0
static NSColor *colorFromPSDColor(struct _psdGradientColor psd) {
    return [NSColor colorWithRed:psd.red green:psd.green blue:psd.blue alpha:psd.alpha];
}

static struct _psdGradientColor psdColorFromColor(NSColor *color) {
    color = [color colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    struct _psdGradientColor psd;
    psd.red = color.redComponent;
    psd.green = color.greenComponent;
    psd.blue = color.blueComponent;
    psd.alpha = color.alphaComponent;
    return psd;
}

@interface CFTGradientStopLayer : CALayer
@property (strong) CUIPSDGradientStop *stop;
- (void)_initialize;
@end

@implementation CFTGradientStopLayer

- (instancetype)initWithLayer:(CFTGradientStopLayer *)layer {
    if ((self = [super initWithLayer:layer])) {
        [self _initialize];
        self.stop = layer.stop;
    }
    
    return self;
}

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

- (void)_initialize {
    self.autoresizingMask = kCALayerNotSizable;
    self.shadowColor = [[NSColor blackColor] CGColor];
    self.shadowOpacity = 0.2;
    self.shadowOffset = CGSizeMake(0, -2.0);
    [self addObserver:self forKeyPath:@"stop" options:0 context:nil];
    [self addObserver:self forKeyPath:@"stop.gradientColor" options:0 context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"stop"];
    [self removeObserver:self forKeyPath:@"stop.gradientColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"stop"] || [keyPath isEqualToString:@"stop.gradientColor"]) {
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    BOOL midpoint = (!self.stop.isOpacityStop && !self.stop.isColorStop);
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:ctx flipped:YES]];
    if (midpoint) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(NSMidX(self.bounds), NSMinY(self.bounds))];
        [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMidY(self.bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(self.bounds), NSMaxY(self.bounds))];
        [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMidY(self.bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(self.bounds), NSMinY(self.bounds))];
        [path setClip];
        CGContextSetFillColorWithColor(ctx, [[NSColor blackColor] CGColor]);
        CGContextFillRect(ctx, self.bounds);
    } else {
        NSColor *leadColor = nil;
        NSColor *leadOutColor = nil;
        
        if (self.stop.isOpacityStop) {
            leadColor = [NSColor colorWithWhite:1.0 - ((CUIPSDGradientOpacityStop *)self.stop).opacity alpha:1.0];
            if (self.stop.isDoubleStop) {
                leadOutColor = [NSColor colorWithWhite:1.0 - ((CUIPSDGradientDoubleOpacityStop *)self.stop).leadOutOpacity alpha:1.0];
            }
        } else if (self.stop.isColorStop) {
            struct _psdGradientColor color;
            color = ((CUIPSDGradientColorStop *)self.stop).gradientColor;
            leadColor = [NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
            if (self.stop.isDoubleStop) {
                color = ((CUIPSDGradientDoubleColorStop *)self.stop).leadOutColor;
                leadOutColor = [NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
            }
        }
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.bounds.size.width / 2 yRadius:self.bounds.size.width / 2];
        [[NSColor grayColor] set];
        [path fill];
        
        CGFloat inset = self.stop.isColorStop ? 2.0 : 4.0;
        NSRect bounds = NSInsetRect(self.bounds, inset, inset);
        path = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:bounds.size.width / 2 yRadius:bounds.size.width / 2];
        [path setClip];
        
        [leadColor set];
        [path fill];
        
        if (leadOutColor) {
            
            NSBezierPath *mask = [NSBezierPath bezierPathWithRect:NSMakeRect(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height)];
            [mask addClip];
            [leadOutColor set];
            [path fill];
        }
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

@end


@interface CFTGradientEditor ()
@property (strong) CALayer *gradientLayer;
@property (strong) NSMutableArray *colorStopLayers;
@property (strong) NSMutableArray *opacityStopLayers;
@property (strong) NSMutableArray *colorMidpointStopLayers;
@property (strong) NSMutableArray *opacityMidpointStopLayers;
@property (readonly) CUIPSDGradientEvaluator *evaluator;
@property (weak) CFTGradientStopLayer *draggedLayer;
@property (weak) CFTGradientStopLayer *beforeLayer;
@property (weak) CFTGradientStopLayer *afterLayer;

- (void)_initialize;
- (CFTGradientStopLayer *)_addColorStop:(CUIPSDGradientColorStop *)stop;
- (CFTGradientStopLayer *)_addOpacityStop:(CUIPSDGradientOpacityStop *)stop;
- (CFTGradientStopLayer *)_addOpacityMidpointStop:(CUIPSDGradientStop *)stop;
- (CFTGradientStopLayer *)_addColorMidpointStop:(CUIPSDGradientStop *)stop;

- (void)_repositionStops;
- (void)_synchronizeEvaluatorWithStops;
- (void)_invalidateGradient;

- (void)colorChanged:(NSColorPanel *)colorPanel;
@end

@implementation CFTGradientEditor
@dynamic evaluator, colorStops, colorMidpointStops, opacityStops, opacityMidpointStops, colorMidpointLocations, opacityMidpointLocations;

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)init {
    if ((self = [self init])) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"gradient" options:0 context:nil];

    self.colorStopLayers = [NSMutableArray array];
    self.colorMidpointStopLayers = [NSMutableArray array];
    self.opacityStopLayers = [NSMutableArray array];
    self.opacityMidpointStopLayers = [NSMutableArray array];
    
    self.layer = [CALayer layer];
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
    
    
    self.gradientLayer = [CALayer layer];
    self.gradientLayer.cornerRadius = 8.0;
    self.gradientLayer.backgroundColor = [[NSColor colorWithPatternImage:checkerImage] CGColor];
    self.gradientLayer.delegate = self;
    self.gradientLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMaxXMargin | kCALayerMaxYMargin | kCALayerMinXMargin | kCALayerMinYMargin;
    self.gradientLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.gradientLayer];
    
    
    struct _psdGradientColor color;
    color.red = 1.0;
    color.green = 0.0;
    color.blue = 0.0;
    color.alpha = 1.0;
    
    CUIPSDGradientColorStop *originalStop1 = [CUIPSDGradientColorStop colorStopWithLocation:0.0 gradientColor:color];
    color.red = 0.0;
    CUIPSDGradientColorStop *originalStop2 = [CUIPSDGradientColorStop colorStopWithLocation:1.0 gradientColor:color];
    
    CUIPSDGradientOpacityStop *originalOpacity1 = [CUIPSDGradientOpacityStop opacityStopWithLocation:0.0 opacity:1.0];
    CUIPSDGradientOpacityStop *originalOpacity2 = [CUIPSDGradientOpacityStop opacityStopWithLocation:0.0 opacity:0.5];
    
    self.gradient = [[CUIThemeGradient alloc] _initWithGradientEvaluator:[[CUIPSDGradientEvaluator alloc] initWithColorStops:@[ originalStop1, originalStop2]
                                                                                                              colorMidpoints:@[ @0.5 ]
                                                                                                                opacityStops:@[ originalOpacity1, originalOpacity2 ]
                                                                                                            opacityMidpoints:@[ @0.5 ]
                                                                                                        smoothingCoefficient:1.0
                                                                                                             fillCoefficient:1.0] colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"gradient"]) {
        [self _repositionStops];
    }
         
}

- (void)_repositionStops {
    [self setColorStops:self.evaluator.colorStops];
    [self setOpacityStops:self.evaluator.opacityStops];
    
    // Add implicit midpoints
    NSMutableArray *midpoints = self.evaluator.colorMidpointLocations.mutableCopy ?: [NSMutableArray array];
    if (self.evaluator.colorStops.count > 0) {
        while (midpoints.count != self.evaluator.colorStops.count - 1) {
            if (midpoints.count < self.evaluator.colorStops.count - 1)
                [midpoints addObject:@0.5];
            else
                [midpoints removeLastObject];
        }
    } else {
        midpoints = [NSMutableArray array];
    }

    [self setColorMidpointLocations:midpoints];
    
    midpoints = self.evaluator.opacityMidpointLocations.mutableCopy ?: [NSMutableArray array];
    if (self.evaluator.opacityStops.count > 0)
    while (midpoints.count != self.evaluator.opacityStops.count - 1) {
        if (midpoints.count < self.evaluator.opacityStops.count)
            [midpoints addObject:@0.5];
        else
            [midpoints removeLastObject];
    } else {
        midpoints = [NSMutableArray array];
    }
    [self setOpacityMidpointLocations:midpoints];
    
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
    self.gradientLayer.frame = NSInsetRect(self.bounds, kCFTStopSize / 2, kCFTStopSize / 2);
    
    [self.gradientLayer setNeedsLayout];
    [self.gradientLayer setNeedsDisplay];
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [self.gradientLayer setNeedsLayout];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"dealloc"];
}

- (void)setColorStops:(NSArray *)colorStops {
    while (self.colorStopLayers.count > colorStops.count) {
        [self.colorStopLayers[0] removeFromSuperlayer];
        [self.colorStopLayers removeObjectAtIndex:0];
    }
    
    for (NSUInteger x = 0; x < colorStops.count; x++) {
        CUIPSDGradientColorStop *stop = colorStops[x];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.colorStopLayers.count) {
            layer = [self _addColorStop:stop];
        } else
            layer = self.colorStopLayers[x];
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)setOpacityStops:(NSArray *)opacityStops {
    while (self.opacityStopLayers.count > opacityStops.count) {
        [self.opacityStopLayers[0] removeFromSuperlayer];
        [self.opacityStopLayers removeObjectAtIndex:0];
    }
    
    for (NSUInteger x = 0; x < opacityStops.count; x++) {
        CUIPSDGradientOpacityStop *stop = opacityStops[x];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.opacityStopLayers.count) {
            layer = [self _addOpacityStop:stop];
        } else
            layer = self.opacityStopLayers[x];
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (NSArray *)colorMidpointLocations {
    return [self.colorMidpointStopLayers valueForKeyPath:@"stop.location"];
}

- (NSArray *)opacityMidpointLocations {
    return [self.opacityMidpointStopLayers valueForKeyPath:@"stop.location"];
}

- (void)setColorMidpointLocations:(NSArray *)locations {
    while (self.colorMidpointStopLayers.count > locations.count) {
        [self.colorMidpointStopLayers[0] removeFromSuperlayer];
        [self.colorMidpointStopLayers removeObjectAtIndex:0];
    }
    
    for (NSUInteger x = 0; x < locations.count; x++) {
        CUIPSDGradientStop *stop = [[NSClassFromString(@"CUIPSDGradientStop") alloc] initWithLocation:[locations[x] doubleValue]];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.colorMidpointStopLayers.count) {
            layer = [self _addColorMidpointStop:stop];
        } else {
            layer = self.colorMidpointStopLayers[x];
        }
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)setOpacityMidpointLocations:(NSArray *)locations {
    while (self.opacityMidpointStopLayers.count > locations.count) {
        [self.opacityMidpointStopLayers[0] removeFromSuperlayer];
        [self.opacityMidpointStopLayers removeObjectAtIndex:0];
    }
    
    for (NSUInteger x = 0; x < locations.count; x++) {
        CUIPSDGradientStop *stop = [[NSClassFromString(@"CUIPSDGradientStop") alloc] initWithLocation:[locations[x] doubleValue]];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.opacityMidpointStopLayers.count) {
            layer = [self _addOpacityMidpointStop:stop];
        } else {
            layer = self.opacityMidpointStopLayers[x];
        }
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (CFTGradientStopLayer *)_addColorStop:(CUIPSDGradientColorStop *)stop {
    CFTGradientStopLayer *layer = [[CFTGradientStopLayer alloc] init];
    layer.stop = stop;
    layer.frame = CGRectMake(0, 0, kCFTStopSize, kCFTStopSize);
    [self.colorStopLayers addObject:layer];
    [self.gradientLayer addSublayer:layer];
    
    return layer;
}

- (CFTGradientStopLayer *)_addOpacityStop:(CUIPSDGradientOpacityStop *)stop {
    CFTGradientStopLayer *layer = [CFTGradientStopLayer layer];
    layer.stop = stop;
    layer.frame = CGRectMake(0, 0, kCFTStopSize, kCFTStopSize);
    [self.opacityStopLayers addObject:layer];
    [self.gradientLayer addSublayer:layer];
    
    return layer;
}

- (CFTGradientStopLayer *)_addOpacityMidpointStop:(CUIPSDGradientStop *)stop {
    CFTGradientStopLayer *layer = [CFTGradientStopLayer layer];
    layer.stop = stop;
    layer.frame = CGRectMake(0, 0, kCFTStopSize, kCFTStopSize);
    [self.opacityMidpointStopLayers addObject:layer];
    [self.gradientLayer addSublayer:layer];
    
    return layer;
}

- (CFTGradientStopLayer *)_addColorMidpointStop:(CUIPSDGradientStop *)stop {
    CFTGradientStopLayer *layer = [CFTGradientStopLayer layer];
    layer.stop = stop;
    layer.frame = CGRectMake(0, 0, kCFTStopSize, kCFTStopSize);
    [self.colorMidpointStopLayers addObject:layer];
    [self.gradientLayer addSublayer:layer];
    
    return layer;
}

- (NSArray *)colorStops {
    return [self.colorStopLayers valueForKey:@"stop"];
}

- (NSArray *)colorMidpointStops {
    return [self.colorMidpointStopLayers valueForKey:@"stop"];
}

- (NSArray *)opacityStops {
    return [self.opacityStopLayers valueForKey:@"stop"];
}

- (NSArray *)opacityMidpointStops {
    return [self.opacityMidpointStopLayers valueForKey:@"stop"];
}

- (void)layoutSublayersOfLayer:(CALayer *)superLayer {
    // Reposition stops
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    NSArray *sort = @[ [NSSortDescriptor sortDescriptorWithKey:@"stop.location" ascending:YES] ];
    [self.colorStopLayers sortUsingDescriptors:sort];
    [self.opacityStopLayers sortUsingDescriptors:sort];
    
    for (CFTGradientStopLayer *layer in self.colorStopLayers) {
        layer.position = CGPointMake(superLayer.bounds.size.width * layer.stop.location, 0);
    }
    
    for (CFTGradientStopLayer *layer in self.opacityStopLayers) {
        layer.position = CGPointMake(superLayer.bounds.size.width * layer.stop.location, superLayer.bounds.size.height);
    }

    for (NSUInteger x = 0; x < self.colorMidpointStopLayers.count; x++) {
        CFTGradientStopLayer *layer = self.colorMidpointStopLayers[x];
        CFTGradientStopLayer *before = self.colorStopLayers[x];
        CFTGradientStopLayer *after = self.colorStopLayers[x+1];
        
        layer.position = CGPointMake(before.position.x + (after.position.x - before.position.x) * layer.stop.location, 0);
    }
    
    for (NSUInteger x = 0; x < self.opacityMidpointStopLayers.count; x++) {
        CFTGradientStopLayer *layer = self.opacityMidpointStopLayers[x];
        CFTGradientStopLayer *before = self.opacityStopLayers[x];
        CFTGradientStopLayer *after = self.opacityStopLayers[x+1];
        
        layer.position = CGPointMake(before.position.x + (after.position.x - before.position.x) * layer.stop.location, superLayer.bounds.size.height);
    }
    [CATransaction commit];
}

- (CUIPSDGradientEvaluator *)evaluator {
    return [self.gradient valueForKey:@"gradientEvaluator"];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self.gradient drawInRect:layer.bounds angle:0 withContext:ctx];
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *hitLayer = [self.gradientLayer hitTest:viewPoint];
    if (hitLayer != self.gradientLayer && hitLayer) {
        self.selectedStop = ((CFTGradientStopLayer *)hitLayer).stop;
        
        if (event.clickCount > 1 && [self.selectedStop isKindOfClass:[CUIPSDGradientColorStop class]]) {
            NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
            colorPanel.continuous = YES;
            colorPanel.color = colorFromPSDColor(((CUIPSDGradientColorStop *)self.selectedStop).gradientColor);
            [colorPanel setTarget:self];
            [colorPanel setAction:@selector(colorChanged:)];
            [colorPanel orderFront:self];
        } else {
            self.draggedLayer = (CFTGradientStopLayer *)hitLayer;
            if ([self.opacityMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.opacityMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.opacityStopLayers[x];
                self.afterLayer = self.opacityStopLayers[x+1];
            } else if ([self.colorMidpointStopLayers containsObject:self.draggedLayer]) {
                NSUInteger x = [self.colorMidpointStopLayers indexOfObject:self.draggedLayer];
                self.beforeLayer = self.colorStopLayers[x];
                self.afterLayer = self.colorStopLayers[x+1];
            } else {
                self.beforeLayer = nil;
                self.afterLayer = nil;
            }
        }
    } else if (!hitLayer) {
        CGFloat location = (viewPoint.x - self.gradientLayer.bounds.origin.x) / (self.bounds.size.width - self.gradientLayer.bounds.origin.x * 2);
        struct _psdGradientColor color = [self.evaluator _smoothedGradientColorAtLocation:location];
        if (viewPoint.y > NSMaxY(self.gradientLayer.frame)) {
            CUIPSDGradientOpacityStop *stop = [CUIPSDGradientOpacityStop opacityStopWithLocation:location opacity:color.alpha];
            [self _addOpacityStop:stop];
        } else if (viewPoint.y < NSMinY(self.gradientLayer.frame)) {
            color.alpha = 1.0;
            CUIPSDGradientColorStop *stop = [CUIPSDGradientColorStop colorStopWithLocation:location gradientColor:color];
            [self _addColorStop:stop];
        }

        [self _synchronizeEvaluatorWithStops];
        [self _repositionStops];
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
    
    if (self.afterLayer && self.beforeLayer) {
        self.draggedLayer.stop.location = MAX(MIN((viewPoint.x - self.beforeLayer.position.x) / (self.afterLayer.position.x - self.beforeLayer.position.x), 1), 0);

    } else {
        self.draggedLayer.stop.location = MAX(MIN(viewPoint.x / self.bounds.size.width, 1), 0);
    }

    [self.gradientLayer setNeedsLayout];
    [self _synchronizeEvaluatorWithStops];
}

- (void)_synchronizeEvaluatorWithStops {
    CUIPSDGradientEvaluator *evaluator = self.evaluator;
    [evaluator setColorStops:self.colorStops midpoints:self.colorMidpointLocations];
    [evaluator setOpacityStops:self.opacityStops midpoints:self.opacityMidpointLocations];
    [self _invalidateGradient];
}

- (void)_invalidateGradient {
    // Remove CUIThemeGradient's cached shader so it generates a new drawing method
    Ivar var = class_getInstanceVariable([CUIThemeGradient class], "colorShader");
    CGFunctionRef *shader = (CGFunctionRef *)((__bridge void *)self.gradient + ivar_getOffset(var));
    CGFunctionRelease(*shader);
    *shader = NULL;
    [self.gradientLayer setNeedsDisplay];
}

- (void)mouseUp:(NSEvent *)theEvent {
    self.draggedLayer = nil;
    self.beforeLayer = nil;
    self.afterLayer = nil;
}

- (void)colorChanged:(NSColorPanel *)colorPanel {
    if ([self.selectedStop isKindOfClass:[CUIPSDGradientColorStop class]]) {
        [self.selectedStop willChangeValueForKey:@"gradientColor"];
        [((CUIPSDGradientColorStop *)self.selectedStop) _setGradientColor:psdColorFromColor(colorPanel.color)];
        [self.selectedStop didChangeValueForKey:@"gradientColor"];
        [self _invalidateGradient];
    }
}

@end
