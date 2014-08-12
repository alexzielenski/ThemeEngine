//
//  ACTGradientEditor.h
//  ACTGradientEditor
//
//  Created by Alex on 14/09/2011.
//  Copyright 2011 ACT Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSColor+ChessboardColor.h"

/* TODO: 
 - NOTHING!!!
*/

// These #defines are very easy to turn into properties (with Find/Replace)
// should you need to change them progamatically

// Colors
#define kTopKnobColor [NSColor colorWithCalibratedWhite: 0.95 alpha: 1]
#define kBottomKnobColor [NSColor colorWithCalibratedWhite: 0.6 alpha: 1]
#define kSelectedTopKnobColor [NSColor alternateSelectedControlColor]
#define kSelectedBottomKnobColor [[NSColor alternateSelectedControlColor] shadowWithLevel: 0.35]

#define kKnobBorderColor [[NSColor blackColor] colorWithAlphaComponent: 0.56]
#define kKnobInsideBorderColor [[NSColor blackColor] colorWithAlphaComponent: 0.56]
#define kViewBorderColor [[NSColor blackColor] colorWithAlphaComponent: 0.56]

#define kDefaultAddColor [NSColor whiteColor]

// Chessboard BG
#define kChessboardBGWidth 5
#define kChessboardBGColor1 [NSColor whiteColor]
#define kChessboardBGColor2 [NSColor lightGrayColor]

// Knob
#define kKnobDiameter 16
#define kKnobBorderWidth 1 // inner and outer borders alike

// Gradient 'view'
#define kViewBorderWidth 1
#define kViewCornerRoundness 3
#define kViewXOffset (kKnobDiameter/2 + kKnobBorderWidth) // how much to add to origin.x of the gradient rect

// Other
#define kArrowKeysMoveOffset 0.011 // color location in gradient

// -----------

@interface ACTGradientEditor : NSView {
    id target;
    SEL action;
    
    NSGradient* gradient;
    CGFloat gradientHeight; // if (<= 0 || >= [view bounds]) { fill completely the view }
    BOOL drawsChessboardBackground;
    BOOL editable;
    
    @private
    NSInteger _draggingKnobAtIndex;
    NSInteger _editingKnobAtIndex;
}

@property (assign) IBOutlet id target;
@property (assign) SEL action;
@property (retain) NSGradient* gradient;

@property (assign) BOOL editable;
@property (assign) BOOL drawsChessboardBackground;

// Not that much functions actually:

// -- only these two everyone knows
- (id)initWithFrame: (NSRect)frame;
- (void)drawRect: (NSRect)dirtyRect;

// -- this method that DWIS (does what it says :) - It's more for subclassing and cleaner code than to be called by others though.
- (void)drawKnobForColor: (NSColor*)knobColor atPoint: (NSPoint)knobPoint selected: (BOOL)selected editing: (BOOL)editing;

// -- and the getters/setters

// For subclassing (why would you do that if you have the code?)
// you have the method drawKnobForColor:atPoint:selected:editing:

@end
