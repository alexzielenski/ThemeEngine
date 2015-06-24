//
//  TEInspectorController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TEInspectorDetailController.h"
#import "TEGradientInspector.h"
#import "TEBitmapInspector.h"
#import "TEGradientInfoInspector.h"
#import "TEEffectsInspector.h"
#import "TEColorInspector.h"
#import "TESlicePreviewInspector.h"
#import "TEAnimationInspector.h"
#import "TECaarInspector.h"

// representedObject must be an NSArrayController
// with updated selectionIndexes
@interface TEInspectorController : NSViewController
@property IBOutlet NSStackView *contentView;
@property (strong) NSArray *inspectorViewControllers;
@property (strong) IBOutlet NSArrayController *contentController;

@property (weak) IBOutlet TEInspectorDetailController *gradientInspector;
@property (weak) IBOutlet TEInspectorDetailController *attributesInspector;
@property (weak) IBOutlet TEBitmapInspector *bitmapInspector;
@property (weak) IBOutlet TEGradientInfoInspector *gradientInfoInspector;
@property (weak) IBOutlet TEEffectsInspector *effectsInspector;
@property (weak) IBOutlet TEColorInspector *colorInspector;
@property (weak) IBOutlet TESlicePreviewInspector *sliceInspector;
@property (weak) IBOutlet TEAnimationInspector *animationInspector;
@property (weak) IBOutlet TECaarInspector *caarInspector;

@property IBOutlet NSView *bottomLine;
@end
