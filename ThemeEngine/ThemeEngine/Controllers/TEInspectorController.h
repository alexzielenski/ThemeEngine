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

// representedObject must be an NSArrayController
// with updated selectionIndexes
@interface TEInspectorController : NSViewController
@property IBOutlet NSStackView *contentView;
@property (strong) NSArray *inspectorViewControllers;

@property (strong) IBOutlet TEInspectorDetailController *gradientInspector;
@property (strong) IBOutlet TEInspectorDetailController *attributesInspector;
@property (strong) IBOutlet TEBitmapInspector *bitmapInspector;
@property (strong) IBOutlet TEGradientInfoInspector *gradientInfoInspector;
@property (strong) IBOutlet TEEffectsInspector *effectsInspector;

@property IBOutlet NSView *bottomLine;
@end
