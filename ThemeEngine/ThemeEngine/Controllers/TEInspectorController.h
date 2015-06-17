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

@interface TEInspectorController : NSViewController
@property IBOutlet NSView *contentView;
@property (strong) IBOutlet TEInspectorDetailController *gradientInspector;
@property (strong) IBOutlet TEInspectorDetailController *attributesInspector;
@end
