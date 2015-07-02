//
//  CFTGradientEditor.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradientEditor.h"
@import QuartzCore.CATransaction;
#import "ZKSwizzle.h"

#define kCFTStopSize 16.0

@interface CFTGradientStopLayer : CALayer
@property (strong) CUIPSDGradientStop *stop;
@property (assign, getter=isSelected) BOOL selected;
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
static void *kCFTStopDirtyContext;
- (void)_initialize {
    self.autoresizingMask = kCALayerNotSizable;
    self.shadowColor = [[NSColor blackColor] CGColor];
    self.shadowOpacity = 0.2;
    self.shadowOffset = CGSizeMake(0, -2.0);
    [self addObserver:self forKeyPath:@"stop" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"stop.gradientColor" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"stop.leadOutColor" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"stop.opacity" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"stop.leadOutOpacity" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"stop.location" options:0 context:&kCFTStopDirtyContext];
    [self addObserver:self forKeyPath:@"selected" options:0 context:&kCFTStopDirtyContext];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"stop"];
    [self removeObserver:self forKeyPath:@"stop.gradientColor"];
    [self removeObserver:self forKeyPath:@"stop.location"];
    [self removeObserver:self forKeyPath:@"stop.opacity"];
    [self removeObserver:self forKeyPath:@"stop.leadOutOpacity"];
    [self removeObserver:self forKeyPath:@"stop.leadOutColor"];
    [self removeObserver:self forKeyPath:@"selected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kCFTStopDirtyContext) {
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    BOOL midpoint = (!self.stop.isOpacityStop && !self.stop.isColorStop);
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:ctx flipped:YES]];
    if (midpoint) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        NSRect bounds = NSInsetRect(self.bounds, 4, 4);
        [path moveToPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds))];
        [path lineToPoint:NSMakePoint(NSMaxX(bounds), NSMidY(bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(bounds), NSMaxY(bounds))];
        [path lineToPoint:NSMakePoint(NSMinX(bounds), NSMidY(bounds))];
        [path lineToPoint:NSMakePoint(NSMidX(bounds), NSMinY(bounds))];
        [path setClip];
        
        NSColor *fillColor = [NSColor blackColor];
        if (self.stop.location == 0.5)
            fillColor = [fillColor colorWithAlphaComponent:0.5];
        
        if (self.isSelected)
            fillColor = [NSColor whiteColor];
        
        CGContextSetFillColorWithColor(ctx, [fillColor CGColor]);
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
            leadColor = self.stop.gradientColorValue;
            leadOutColor = self.stop.leadOutColorValue;
        }
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.bounds.size.width / 2 yRadius:self.bounds.size.width / 2];
        if (self.isSelected) {
            [[NSColor grayColor] set];
        } else {
            [[NSColor whiteColor] set];
        }
        [path fill];
        
        CGFloat inset = self.stop.isColorStop ? 2.0 : 4.0;
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


static void *kCFTStopContext;

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
@property (readwrite, strong) CUIPSDGradientStop *selectedStop;

- (void)_initialize;
- (void)_repositionStops;
- (void)_synchronizeEvaluatorWithStops;
- (void)_invalidateGradient;

- (void)colorChanged:(NSColorPanel *)colorPanel;

- (void)_startObservingStop:(CUIPSDGradientStop *)stop;
- (void)_stopObservingStop:(CUIPSDGradientStop *)stop;

- (CFTGradientStopLayer *)_addStop:(CUIPSDGradientStop *)stop colorStop:(BOOL)isColorStop;
- (void)_removeStopLayer:(CFTGradientStopLayer *)layer;
- (CFTGradientStopLayer *)layerForStop:(CUIPSDGradientStop *)stop;
@end

@implementation CFTGradientEditor
@dynamic evaluator, colorStops, colorMidpointStops, opacityStops, opacityMidpointStops, colorMidpointLocations, opacityMidpointLocations, gradient;

#pragma mark - Initialization

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


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"gradient"];
    [self removeObserver:self forKeyPath:@"selectedStop"];
    
    for (NSInteger x = self.colorStopLayers.count - 1; x >= 0; x--) {
        [self _removeStopLayer:self.colorStopLayers[x]];
    }
    for (NSInteger x = self.opacityStopLayers.count - 1; x >= 0; x--) {
        [self _removeStopLayer:self.opacityStopLayers[x]];
    }
    for (NSInteger x = self.colorMidpointStopLayers.count - 1; x >= 0; x--) {
        [self _removeStopLayer:self.colorMidpointStopLayers[x]];
    }
    for (NSInteger x = self.opacityMidpointStopLayers.count - 1; x >= 0; x--) {
        [self _removeStopLayer:self.opacityMidpointStopLayers[x]];
    }

}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"gradient" options:0 context:nil];
    [self addObserver:self forKeyPath:@"selectedStop" options:NSKeyValueObservingOptionOld context:nil];
    
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
    
    self.gradientWrapper = [CFTGradient gradientWithThemeGradient:[[CUIThemeGradient alloc] _initWithGradientEvaluator:[[CUIPSDGradientEvaluator alloc] initWithColorStops:@[ originalStop1, originalStop2]
                                                                                                                                                            colorMidpoints:@[ @0.5 ]
                                                                                                                                                              opacityStops:@[ originalOpacity1, originalOpacity2 ]
                                                                                                                                                          opacityMidpoints:@[ @0.5 ]
                                                                                                                                                      smoothingCoefficient:1.0
                                                                                                                                                           fillCoefficient:1.0] colorSpace:[[NSColorSpace sRGBColorSpace] CGColorSpace]]
                                                            angle:90
                                                            style:CUIGradientStyleLinear];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"gradient"]) {
        [self _repositionStops];
    } else if ([keyPath isEqualToString:@"selectedStop"]) {
        CUIPSDGradientStop *oldStop = change[NSKeyValueChangeOldKey];
        if ([oldStop isKindOfClass:[NSNull class]])
            oldStop = nil;
        [self layerForStop:oldStop].selected = NO;
        [self layerForStop:self.selectedStop].selected = YES;
    } else if (context == &kCFTStopContext) {
        [self _synchronizeEvaluatorWithStops];
        [self.gradientLayer setNeedsLayout];
    }
         
}

#pragma mark - Display

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

- (CUIThemeGradient *)gradient {
    return self.gradientWrapper.themeGradient;
}

+ (NSSet *)keyPathsForValuesAffectingGradient {
    return [NSSet setWithObject:@"gradientWrapper"];
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

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self.gradient drawInRect:layer.bounds angle:0 withContext:ctx];
}

- (void)_synchronizeEvaluatorWithStops {
    CUIPSDGradientEvaluator *evaluator = self.evaluator;
    [evaluator setColorStops:self.colorStops midpoints:self.colorMidpointLocations];
    [evaluator setOpacityStops:self.opacityStops midpoints:self.opacityMidpointLocations];
    [self _invalidateGradient];
}

- (void)_invalidateGradient {
    // Remove CUIThemeGradient's cached shader so it generates a new drawing method
    CGFunctionRef *shader = &ZKHookIvar(self.gradient, CGFunctionRef, "colorShader");
    if (shader != NULL  && *shader != NULL) {
        CGFunctionRelease(*shader);
        *shader = NULL;
    }
    
    [self.gradientLayer setNeedsDisplay];
    
    if ([self.target respondsToSelector:self.action]) {
        ((void (*)(id, SEL, CFTGradientEditor *))[self.target methodForSelector:self.action])(self.target, self.action, self);
    }
}

#pragma mark - Color Stops

- (CFTGradientStopLayer *)layerForStop:(CUIPSDGradientStop *)stop {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop == %@", stop];
    if (stop.isColorStop) {
        return [[self.colorStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    } else if (stop.isOpacityStop) {
        return [[self.opacityStopLayers filteredArrayUsingPredicate:predicate] firstObject];
    }
    
    CFTGradientStopLayer *layer = [[self.colorMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];;
    if (!layer) {
        layer = [[self.opacityMidpointStopLayers filteredArrayUsingPredicate:predicate] firstObject];;
    }
    return layer;
}

- (void)setColorStops:(NSArray *)colorStops {
    while (self.colorStopLayers.count > colorStops.count) {
        [self _removeStopLayer:self.colorStopLayers[0]];
    }
    
    for (NSUInteger x = 0; x < colorStops.count; x++) {
        CUIPSDGradientColorStop *stop = colorStops[x];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.colorStopLayers.count) {
            layer = [self _addStop:stop colorStop:YES];
        } else {
            layer = self.colorStopLayers[x];
            [self _stopObservingStop:layer.stop];
            [self _startObservingStop:stop];
        }
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)setOpacityStops:(NSArray *)opacityStops {
    while (self.opacityStopLayers.count > opacityStops.count) {
        [self _removeStopLayer:self.opacityStopLayers[0]];
    }
    
    for (NSUInteger x = 0; x < opacityStops.count; x++) {
        CUIPSDGradientOpacityStop *stop = opacityStops[x];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.opacityStopLayers.count) {
            layer = [self _addStop:stop colorStop:NO];
        } else {
            layer = self.opacityStopLayers[x];
            [self _stopObservingStop:layer.stop];
            [self _startObservingStop:stop];
        }
        
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
        [self _removeStopLayer:self.colorMidpointStopLayers[0]];
    }
    
    for (NSUInteger x = 0; x < locations.count; x++) {
        CUIPSDGradientStop *stop = [[NSClassFromString(@"CUIPSDGradientStop") alloc] initWithLocation:[locations[x] doubleValue]];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.colorMidpointStopLayers.count) {
            layer = [self _addStop:stop colorStop:YES];
        } else {
            layer = self.colorMidpointStopLayers[x];
            [self _stopObservingStop:layer.stop];
            [self _startObservingStop:stop];
        }
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)setOpacityMidpointLocations:(NSArray *)locations {
    while (self.opacityMidpointStopLayers.count > locations.count) {
        [self _removeStopLayer:self.opacityMidpointStopLayers[0]];
    }
    
    for (NSUInteger x = 0; x < locations.count; x++) {
        CUIPSDGradientStop *stop = [[NSClassFromString(@"CUIPSDGradientStop") alloc] initWithLocation:[locations[x] doubleValue]];
        CFTGradientStopLayer *layer = nil;
        if (x >= self.opacityMidpointStopLayers.count) {
            layer = [self _addStop:stop colorStop:NO];
        } else {
            layer = self.opacityMidpointStopLayers[x];
            [self _stopObservingStop:layer.stop];
            [self _startObservingStop:stop];
        }
        
        layer.stop = stop;
        [layer setNeedsDisplay];
    }
}

- (void)setStop:(CUIPSDGradientStop *)stop doubleSided:(BOOL)doubleSided {
    if (!stop)
        return;
    
    if (stop.isMidpointStop)
        return;
    if (stop.isDoubleStop && doubleSided)
        return;
    if (!stop.isDoubleStop && !doubleSided)
        return;
    
    CFTGradientStopLayer *layer = [self layerForStop:stop];
    CUIPSDGradientStop *newStop = nil;
    if (doubleSided) {
        if (stop.isOpacityStop) {
            CUIPSDGradientDoubleOpacityStop *opacity = [[ZKClass(CUIPSDGradientDoubleOpacityStop) alloc] initWithLocation:stop.location
                                                                                                            leadInOpacity:((CUIPSDGradientOpacityStop *)stop).opacity
                                                                                                           leadOutOpacity:((CUIPSDGradientOpacityStop *)stop).opacity];
            
            newStop = opacity;
        } else if (stop.isColorStop) {
            CUIPSDGradientDoubleColorStop *color = [[ZKClass(CUIPSDGradientDoubleColorStop) alloc] initWithLocation:stop.location
                                                                                                       leadInColor:((CUIPSDGradientColorStop *)stop).gradientColor
                                                                                                       leadOutColor:((CUIPSDGradientColorStop *)stop).gradientColor];
            newStop = color;
        }
    } else {
        if (stop.isOpacityStop) {
            CUIPSDGradientOpacityStop *opacity = [[CUIPSDGradientOpacityStop alloc] initWithLocation:stop.location
                                                                                             opacity:((CUIPSDGradientDoubleOpacityStop *)stop).opacity];
            newStop = opacity;
        } else {
            CUIPSDGradientColorStop *color = [[CUIPSDGradientColorStop alloc] initWithLocation:stop.location
                                                                                 gradientColor:((CUIPSDGradientDoubleColorStop *)stop).gradientColor];
            newStop = color;
        }
    }
    
    if (self.selectedStop == stop) {
        self.selectedStop = newStop;
    }
    
    [self _stopObservingStop:stop];
    layer.stop = newStop;
    [self _startObservingStop:newStop];
    
    [self _synchronizeEvaluatorWithStops];
}

- (void)_startObservingStop:(CUIPSDGradientStop *)stop {
    [stop addObserver:self forKeyPath:@"gradientColor" options:0 context:&kCFTStopContext];
    [stop addObserver:self forKeyPath:@"opacity" options:0 context:&kCFTStopContext];
    [stop addObserver:self forKeyPath:@"leadOutOpacity" options:0 context:&kCFTStopContext];
    [stop addObserver:self forKeyPath:@"leadOutColor" options:0 context:&kCFTStopContext];
    [stop addObserver:self forKeyPath:@"location" options:0 context:&kCFTStopContext];
}

- (void)_stopObservingStop:(CUIPSDGradientStop *)stop {
    if (stop == self.selectedStop)
        self.selectedStop = nil;
    
    
    [stop removeObserver:self forKeyPath:@"gradientColor" context:&kCFTStopContext];
    [stop removeObserver:self forKeyPath:@"opacity" context:&kCFTStopContext];
    [stop removeObserver:self forKeyPath:@"leadOutOpacity" context:&kCFTStopContext];
    [stop removeObserver:self forKeyPath:@"leadOutColor" context:&kCFTStopContext];
    [stop removeObserver:self forKeyPath:@"location" context:&kCFTStopContext];
}

- (CFTGradientStopLayer *)_addStop:(CUIPSDGradientStop *)stop colorStop:(BOOL)isColorStop {
    CFTGradientStopLayer *layer = [CFTGradientStopLayer layer];
    layer.stop = stop;
    [self _startObservingStop:stop];
    layer.frame = CGRectMake(0, 0, kCFTStopSize, kCFTStopSize);
    
    if (stop.isMidpointStop)
        layer.zPosition = 1;
    else
        layer.zPosition = 1000;
    
    if (isColorStop) {
        if (stop.isMidpointStop)
            [self.colorMidpointStopLayers addObject:layer];
        else
            [self.colorStopLayers  addObject:layer];
    } else {
        if (stop.isMidpointStop)
            [self.opacityMidpointStopLayers addObject:layer];
        else
            [self.opacityStopLayers addObject:layer];
    }
    
    [self.gradientLayer addSublayer:layer];

    return layer;
}

- (void)_removeStopLayer:(CFTGradientStopLayer *)layer {
    [self _stopObservingStop:layer.stop];
    
    [layer removeFromSuperlayer];
    if ([self.colorStopLayers containsObject:layer])
        [self.colorStopLayers removeObject:layer];
    if ([self.colorMidpointStopLayers containsObject:layer])
        [self.colorMidpointStopLayers removeObject:layer];
    if ([self.opacityStopLayers containsObject:layer])
        [self.opacityStopLayers removeObject:layer];
    if ([self.opacityMidpointStopLayers containsObject:layer])
        [self.opacityMidpointStopLayers removeObject:layer];
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

- (CUIPSDGradientEvaluator *)evaluator {
    return [self.gradient valueForKey:@"gradientEvaluator"];
}

#pragma mark - Mouse Actions

- (void)mouseDown:(NSEvent *)event {
    NSPoint windowPoint = event.locationInWindow;
    NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    CALayer *hitLayer = [self.gradientLayer hitTest:viewPoint];
    if (hitLayer != self.gradientLayer && hitLayer) {
        self.selectedStop = ((CFTGradientStopLayer *)hitLayer).stop;
        
        if (event.clickCount > 1 && [self.selectedStop isKindOfClass:[CUIPSDGradientColorStop class]]) {
            NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
            colorPanel.showsAlpha = YES;
            colorPanel.continuous = YES;
            colorPanel.color = self.selectedStop.gradientColorValue;
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
        CUIPSDGradientColorStop *stop = nil;
        CFTGradientStopLayer *layer = nil;
        if (viewPoint.y > NSMaxY(self.gradientLayer.frame)) {
            stop = [CUIPSDGradientOpacityStop opacityStopWithLocation:location opacity:color.alpha];
            layer = [self _addStop:stop colorStop:NO];
        } else if (viewPoint.y < NSMinY(self.gradientLayer.frame)) {
            stop = [CUIPSDGradientColorStop colorStopWithLocation:location gradientColor:color];
            layer = [self _addStop:stop colorStop:YES];
        }

        [self _synchronizeEvaluatorWithStops];
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
    
    if (!NSPointInRect(viewPoint, NSInsetRect(self.bounds, -kCFTStopSize, -kCFTStopSize)) && !self.beforeLayer && (([self.opacityStopLayers containsObject:self.draggedLayer] && self.opacityStopLayers.count > 2) || ([self.colorStopLayers containsObject:self.draggedLayer] && self.colorStopLayers.count > 2))) {
        [[NSCursor disappearingItemCursor] push];
    } else {
        [[NSCursor arrowCursor] set];
        if (self.afterLayer && self.beforeLayer) {
            self.draggedLayer.stop.location = MAX(MIN((viewPoint.x - self.beforeLayer.position.x) / (self.afterLayer.position.x - self.beforeLayer.position.x), 1), 0);
            
        } else {
            self.draggedLayer.stop.location = MAX(MIN(viewPoint.x / self.bounds.size.width, 1), 0);
        }
    }
}

- (void)mouseUp:(NSEvent *)event {
    if ([[NSCursor currentCursor] isEqual:[NSCursor disappearingItemCursor]]) {
        [self _removeStopLayer:self.draggedLayer];
        
        [self _synchronizeEvaluatorWithStops];
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
    if ([self.selectedStop isKindOfClass:[CUIPSDGradientColorStop class]]) {
        self.selectedStop.gradientColorValue = colorPanel.color;
    }
}

@end
