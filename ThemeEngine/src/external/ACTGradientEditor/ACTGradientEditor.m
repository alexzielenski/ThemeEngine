//
//  ACTGradientEditor.m
//  ACTGradientEditor
//
//  Created by Alex on 14/09/2011.
//  Copyright 2011 ACT Productions. All rights reserved.
//

#import "ACTGradientEditor.h"

static BOOL pointsWithinDistance(NSPoint p1, NSPoint p2, CGFloat d) {
    return pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2) <= pow(d, 2); 
}

// ------------

@interface ACTGradientEditor (Private)
- (void)_addColorAtLocation: (CGFloat)colorLocation;
- (void)_setLocation: (CGFloat)newColorLocation forKnobAtIndex: (NSInteger)knobIndex;
- (void)_setColor: (NSColor*)newColor forKnobAtIndex: (NSInteger)knobIndex;
- (void)_deleteColorAtIndex: (NSInteger)knobIndex;

- (void)_setGradientWarningTarget: (NSGradient*)gr;

- (NSRect)_gradientBounds;
- (NSPoint)_viewPointFromGradientLocation: (CGFloat)location;
- (CGFloat)_gradientLocationFromViewPoint: (NSPoint)point;
@end

// ------------

@implementation ACTGradientEditor
@dynamic gradient, drawsChessboardBackground;
@synthesize target, action, editable;

- (id)initWithFrame: (NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gradient = [[NSGradient alloc] initWithColorsAndLocations: [NSColor lightGrayColor], 0.2, [NSColor grayColor], 0.8, nil];
        self.editable = TRUE;
//        self.gradientHeight = kKnobDiameter + kKnobBorderWidth + 6;
        self.drawsChessboardBackground = YES;
        
        _draggingKnobAtIndex = -1;
        _editingKnobAtIndex = -1;
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowWillClose:) name: @"NSWindowWillCloseNotification" object: nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)drawRect: (NSRect)dirtyRect
{
    [NSGraphicsContext saveGraphicsState];

    NSRect viewRect = [self _gradientBounds];
    
    NSBezierPath* viewOutline = [NSBezierPath bezierPathWithRoundedRect: viewRect xRadius: kViewCornerRoundness yRadius: kViewCornerRoundness];
    [viewOutline setLineWidth: kViewBorderWidth];
    
    // DRAW BG
    if (drawsChessboardBackground) {
        NSColor* bgColor = [NSColor chessboardColorWithFirstColor: kChessboardBGColor1 secondColor: kChessboardBGColor2 squareWidth: kChessboardBGWidth];
        [bgColor set];
        [viewOutline fill];
    }
    
    // DRAW GRADIENT AREA
    [self.gradient drawInBezierPath: viewOutline angle: 0];
    
    // DRAW VIEW BORDER
    [kViewBorderColor set];
    [viewOutline stroke];
    
    // DRAW KNOBS
    int i;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: i];
        
        // These are drwan in the end so they are always above the others
        if (i == _draggingKnobAtIndex || i == _editingKnobAtIndex) { continue; }
        
        [self drawKnobForColor: color atPoint: [self _viewPointFromGradientLocation: location]
                      selected: _draggingKnobAtIndex == i editing: _editingKnobAtIndex == i];
    }
    
    if (_editingKnobAtIndex > -1) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: _editingKnobAtIndex];
        [self drawKnobForColor: color
                       atPoint: [self _viewPointFromGradientLocation: location]
                      selected: _draggingKnobAtIndex == _editingKnobAtIndex
                       editing: YES];
    }
    
    if (_draggingKnobAtIndex > -1 && _draggingKnobAtIndex != _editingKnobAtIndex) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: _draggingKnobAtIndex];
        [self drawKnobForColor: color
                       atPoint: [self _viewPointFromGradientLocation: location]
                      selected: YES
                       editing: NO];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}
- (void)drawKnobForColor: (NSColor*)knobColor atPoint: (NSPoint)knobPoint selected: (BOOL)selected editing: (BOOL)editing
{
    CGFloat knobSize = kKnobDiameter;
    CGFloat angle = selected ? 90 : 270;
    
    // PATHS
    NSBezierPath* outline = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(knobPoint.x - knobSize / 2, knobPoint.y - knobSize / 2, knobSize, knobSize)];
    NSBezierPath* color = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(knobPoint.x - knobSize / 4, knobPoint.y - knobSize / 4, knobSize / 2, knobSize / 2)];
    [outline setWindingRule: NSEvenOddWindingRule];
    [outline setLineWidth: kKnobBorderWidth];
    [color setLineWidth: kKnobBorderWidth];
    [outline appendBezierPath: color];
    
    // SHADOW
    /*NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset: NSZeroSize];
    [theShadow setShadowBlurRadius: 5.0];
    [theShadow setShadowColor: [[NSColor blackColor] colorWithAlphaComponent: 0.4]];
    [theShadow set];*/
    
    // DRAW BG
    NSGradient* bgKnobGr;
    if (editing) {
        bgKnobGr = [[NSGradient alloc] initWithStartingColor: kSelectedTopKnobColor endingColor: kSelectedBottomKnobColor];
    }
    else {
        bgKnobGr = [[NSGradient alloc] initWithStartingColor: kTopKnobColor endingColor: kBottomKnobColor];
    }
    
    [bgKnobGr drawInBezierPath: outline angle: angle];
    [kKnobBorderColor set];
    [outline stroke];
    
    //[theShadow setShadowColor: [NSColor clearColor]];
    
    // DRAW COLOR
    [knobColor set];
    [color fill];
    [kKnobInsideBorderColor set];
    [color stroke];
}

- (void)_addColorAtLocation: (CGFloat)colorLocation
{
    CGFloat editingColorLocation = 0.0;
    if (_editingKnobAtIndex > -1) {
        [self.gradient getColor: nil location: &editingColorLocation atIndex: _editingKnobAtIndex];
    }
    
    NSMutableArray* newColors = [NSMutableArray arrayWithCapacity: [self.gradient numberOfColorStops] + 1];
    CGFloat locations[[self.gradient numberOfColorStops] + 1];
    
    int i;
    int colorIndex = -1;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: i];
        [newColors addObject: color];
        locations[i] = location;
        
        if (colorLocation < location && colorIndex == -1) {
            colorIndex = MAX(i - 1, 0);
        }
    }
    
    [newColors addObject: kDefaultAddColor];
    locations[[self.gradient numberOfColorStops]] = colorLocation;
    if (colorIndex == -1) { colorIndex = (int)[self.gradient numberOfColorStops] + 1; }
    
    if ((colorIndex < _editingKnobAtIndex) || (colorIndex == 0 && _editingKnobAtIndex == 0 && colorLocation < editingColorLocation)) {
        _editingKnobAtIndex++;
        [self setNeedsDisplay: YES];
    }
    if ((colorIndex < _draggingKnobAtIndex) || (colorIndex == 0 && _draggingKnobAtIndex == 0 && colorLocation < editingColorLocation)) {
        _draggingKnobAtIndex++;
        [self setNeedsDisplay: YES];
    }
    
    self.gradient = [[NSGradient alloc] initWithColors: newColors atLocations: locations colorSpace: [NSColorSpace genericRGBColorSpace]];
}
- (void)_setLocation: (CGFloat)newColorLocation forKnobAtIndex: (NSInteger)knobIndex
{
    CGFloat oldColorLocation;
    [self.gradient getColor: nil location: &oldColorLocation atIndex: knobIndex];
        
    CGFloat editingColorLocation = 0.0;
    if (_editingKnobAtIndex > -1) {
        [self.gradient getColor: nil location: &editingColorLocation atIndex: _editingKnobAtIndex];
    }
        
    // Placeholders for new values
    NSMutableArray* newColors = [NSMutableArray arrayWithCapacity: [self.gradient numberOfColorStops]];
    CGFloat locations[[self.gradient numberOfColorStops]];
    
    // Check for this color passing other colors (to change _dragging)
    int i;
    int nColorsPassed = 0;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        CGFloat location;
        [self.gradient getColor: nil location: &location atIndex: i];
                
        // Shouldn't compare the dragged color with itself
        if (i == knobIndex) { continue; }
        
        if (oldColorLocation < location && location <= newColorLocation) {
            nColorsPassed++;
        }
        else if (newColorLocation <= location && location < oldColorLocation) {
            nColorsPassed--;
        }
        
        if (location == newColorLocation) {
            // Add (or subtract depending on movement direction) just a tad to make sure the changed color is after the other color
            // since we are adding 1 to _currentlyDraggingKnobAtIndex
            if (oldColorLocation < newColorLocation) { newColorLocation += 0.01; } // Going ->
            else { newColorLocation -= 0.01; } // <-
        }
    }
    
    // Check if we moved the color to before or after _editing
    int editingIndexOffset = 0;
    if (knobIndex == _editingKnobAtIndex) {
        editingIndexOffset = nColorsPassed;
    }
    else {
        if (oldColorLocation < editingColorLocation && editingColorLocation < newColorLocation) {
            editingIndexOffset--;
        }
        else if (oldColorLocation > editingColorLocation && editingColorLocation > newColorLocation) {
            editingIndexOffset++;
        }
    }
    
    // Check boundaries
    if (newColorLocation > 1) { newColorLocation = 1; }
    if (newColorLocation < 0) { newColorLocation = 0; }
    
    // Rebuild gradient with new color location
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        NSColor* color;
        CGFloat location;
                
        [self.gradient getColor: &color location: &location atIndex: i];
        
        [newColors addObject: color];
        
        if (knobIndex == i) { locations[i] = newColorLocation; }
        else { locations[i] = location; }
    }
    
    // So we continue dragging the same color (and editing if we are editing any color)
    _editingKnobAtIndex += editingIndexOffset;
    _draggingKnobAtIndex += nColorsPassed;
    
    self.gradient = [[NSGradient alloc] initWithColors: newColors atLocations: locations colorSpace: [NSColorSpace genericRGBColorSpace]];
}
- (void)_setColor: (NSColor*)newColor forKnobAtIndex: (NSInteger)knobIndex
{
    NSMutableArray* newColors = [NSMutableArray arrayWithCapacity: [self.gradient numberOfColorStops]];
    CGFloat locations[[self.gradient numberOfColorStops]];
    
    int i;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: i];
        
        if (knobIndex == i) {
            [newColors addObject: newColor];
        }
        else {
            [newColors addObject: color];
        }
        
        locations[i] = location;
    }
    
    self.gradient = [[NSGradient alloc] initWithColors: newColors atLocations: locations colorSpace: [NSColorSpace genericRGBColorSpace]];
}
- (void)_deleteColorAtIndex: (NSInteger)colorIndex
{
    if (!([self.gradient numberOfColorStops] > 2)) { return; }
    
    NSMutableArray* newColors = [NSMutableArray arrayWithCapacity: [self.gradient numberOfColorStops] - 1];
    CGFloat locations[[self.gradient numberOfColorStops] - 1];
    
    int i;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        NSColor* color;
        CGFloat location;
        [self.gradient getColor: &color location: &location atIndex: i];
        
        if (colorIndex != i) {
            [newColors addObject: color];
            locations[[newColors count] - 1] = location;
        }
    }
    
    if (colorIndex < _editingKnobAtIndex) { _editingKnobAtIndex--; [self setNeedsDisplay: YES]; }
    else if (colorIndex == _editingKnobAtIndex) { _editingKnobAtIndex = -1; }
    
    if (colorIndex < _draggingKnobAtIndex) { _draggingKnobAtIndex--; [self setNeedsDisplay: YES]; }
    else if (colorIndex == _draggingKnobAtIndex) { _draggingKnobAtIndex = -1; }
    
    self.gradient = [[NSGradient alloc] initWithColors: newColors atLocations: locations colorSpace: [self.gradient colorSpace]];
}

- (void)mouseDown: (NSEvent*)theEvent
{
    if (!editable) { return; }
    
    NSPoint mouseLocation = [theEvent locationInWindow];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
    
    int i;
    for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
        CGFloat location;
        [self.gradient getColor: nil location: &location atIndex: i];
                
        if (pointsWithinDistance([self _viewPointFromGradientLocation: location], mouseLocation, kKnobDiameter)) {
            _draggingKnobAtIndex = i;
        }
    }
    
    [self setNeedsDisplay: TRUE];
}
- (void)mouseDragged: (NSEvent*)theEvent
{
    if (!editable) { return; }
    if (_draggingKnobAtIndex == -1) { return; }
    
    NSPoint mouseLocation = [theEvent locationInWindow];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
        
    [self _setLocation: [self _gradientLocationFromViewPoint: mouseLocation] forKnobAtIndex: _draggingKnobAtIndex];
    [self _setGradientWarningTarget: self.gradient];
    [self setNeedsDisplay: TRUE];
    
    // Check for being outside gradient bounds. If so then change the cursor
    int gHeight = [self _gradientBounds].size.height;
    int outBoundTop = ([self bounds].size.height + gHeight) / 2;
    int outBoundBottom = ([self bounds].size.height - gHeight) / 2;
    if ((mouseLocation.y > outBoundTop || mouseLocation.y < outBoundBottom) && [self.gradient numberOfColorStops] > 2) {
        [[NSCursor disappearingItemCursor] set];
    }
    else {
        [[NSCursor arrowCursor] set];
    }
}
- (void)mouseUp: (NSEvent*)theEvent
{
    if (!editable) { return; }
    
    NSPoint mouseLocation = [theEvent locationInWindow];
    mouseLocation = [self convertPoint: mouseLocation fromView: nil];
    
    if ([theEvent clickCount] == 2) {
        int i;
        BOOL addKnob = YES;
        for (i = 0; i < [self.gradient numberOfColorStops]; i++) {
            NSColor* color;
            CGFloat location;
            [self.gradient getColor: &color location: &location atIndex: i];
            
            if (pointsWithinDistance([self _viewPointFromGradientLocation: location], mouseLocation, kKnobDiameter)) {
                _editingKnobAtIndex = i;
                addKnob = NO;
                
                NSColorPanel* cp = [NSColorPanel sharedColorPanel];
                [cp setContinuous: YES];
                [cp setShowsAlpha: YES];
                [cp setTarget: self];
                [cp setAction: @selector(changeKnobColor:)];
                [cp setColor: color];
                [cp orderFront: nil];
            }
        }
        
        if (addKnob) {
            CGFloat colorLocation = [self _gradientLocationFromViewPoint: mouseLocation];
            [self _addColorAtLocation: colorLocation];
            [self _setGradientWarningTarget: self.gradient];
        }
    }
    else if (_draggingKnobAtIndex != -1) {
        int gHeight = [self _gradientBounds].size.height;
        int outBoundTop = ([self bounds].size.height + gHeight) / 2;
        int outBoundBottom = ([self bounds].size.height - gHeight) / 2;

        if ((mouseLocation.y > outBoundTop || mouseLocation.y < outBoundBottom) && [self.gradient numberOfColorStops] > 2) {
            NSShowAnimationEffect(NSAnimationEffectPoof, [NSEvent mouseLocation], NSZeroSize, NULL, NULL, NULL);
            
            [self _deleteColorAtIndex: _draggingKnobAtIndex];
            [self _setGradientWarningTarget: self.gradient];
        }
        
        [[NSCursor arrowCursor] set];
    }
    
    _draggingKnobAtIndex = -1;
    [self setNeedsDisplay: TRUE];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}
- (void)keyDown: (NSEvent*)theEvent
{
    if (!(self.editable && _editingKnobAtIndex != -1)) { return; }
    
    if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
        [self interpretKeyEvents: [NSArray arrayWithObject: theEvent]];
    }
    else if ([[theEvent charactersIgnoringModifiers] characterAtIndex: 0] == NSDeleteCharacter) {
        [self deleteBackward: self];
    }
    else {
        [super keyDown: theEvent];
    }
}
- (IBAction)moveLeft: (id)sender
{
    CGFloat location;
    [self.gradient getColor: nil location: &location atIndex: _editingKnobAtIndex];
    
    [self _setLocation: MAX(location - kArrowKeysMoveOffset, 0) forKnobAtIndex: _editingKnobAtIndex];
    [self _setGradientWarningTarget: self.gradient];
    [self setNeedsDisplay: TRUE];
}
- (IBAction)moveRight: (id)sender
{
    CGFloat location;
    [self.gradient getColor: nil location: &location atIndex: _editingKnobAtIndex];

    [self _setLocation: MIN(location + kArrowKeysMoveOffset, 1) forKnobAtIndex: _editingKnobAtIndex];
    [self _setGradientWarningTarget: self.gradient];
    [self setNeedsDisplay: TRUE];
}
- (IBAction)deleteBackward: (id)sender
{
    [self _deleteColorAtIndex: _editingKnobAtIndex];
    [self _setGradientWarningTarget: self.gradient];
    [self setNeedsDisplay: YES];
}

- (void)changeKnobColor: (id)sender
{
    if (_editingKnobAtIndex != -1) {
        [self _setColor: [sender color] forKnobAtIndex: _editingKnobAtIndex];
        [self _setGradientWarningTarget: self.gradient];
        [self setNeedsDisplay: TRUE];
    }
}
- (void)windowWillClose: (NSNotification*)aNot
{
    if ([[aNot object] class] == [NSColorPanel class]) { //[aNot object] == [NSColorPanel sharedColorPanel]) {
        if (_editingKnobAtIndex != -1) {
            _editingKnobAtIndex = -1;
            [self setNeedsDisplay: TRUE];
        }
    }
}

- (NSGradient *)gradient {
    return gradient;
}

- (void)setGradient: (NSGradient*)gr
{
    // Not so sure about this... (let's just say I love Garbage Collection very much :)
    if (![self.gradient isEqualTo: gr]) {
        [self.gradient release];
        gradient = [gr retain];
        
        [self setNeedsDisplay: TRUE];
    }
}

- (BOOL)drawsChessboardBackground {
    return drawsChessboardBackground;
}

- (void)setDrawsChessboardBackground: (BOOL)v
{
    drawsChessboardBackground = v;
    [self setNeedsDisplay: TRUE];
}

- (void)_setGradientWarningTarget: (NSGradient*)gr
{
    self.gradient = gr;
    if (self.target && self.action) {
        [target performSelector: action withObject: self];
    }
}

- (NSRect)_gradientBounds
{
    NSRect viewRect = [self bounds];
    viewRect.origin.x += kViewXOffset;
    viewRect.size.width -= kViewXOffset * 2;
    
    if (gradientHeight > 0 && gradientHeight < [self bounds].size.height) {
        viewRect.size.height = gradientHeight;
        viewRect.origin.y += ([self bounds].size.height - gradientHeight) / 2;
    }
    
    return viewRect;
}
- (NSPoint)_viewPointFromGradientLocation: (CGFloat)location
{
    return NSMakePoint(location * [self _gradientBounds].size.width + kViewXOffset, [self bounds].size.height / 2);
}
- (CGFloat)_gradientLocationFromViewPoint: (NSPoint)point
{
    return (point.x - kViewXOffset) / [self _gradientBounds].size.width;
}

@end
