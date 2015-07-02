//
//  TEGradientStopViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TEGradientView.h"
#import "CFTGradientEditor.h"
#import "CUIPSDGradientDoubleColorStop.h"
#import "CUIPSDGradientDoubleOpacityStop.h"

@interface TEGradientStopViewController : NSViewController
@property (weak) IBOutlet NSColorWell *gradientColorWell;
@property (weak) IBOutlet NSColorWell *leadOutColorWell;
@property (weak) IBOutlet NSTextField *opacityField;
@property (weak) IBOutlet NSTextField *leadOutOpacityField;
@property (weak) IBOutlet NSTextField *locationField;
@property (weak) IBOutlet NSButton *doubleSidedCheckbox;
@property (weak) IBOutlet CFTGradientEditor *gradientEditor;
@property (weak) IBOutlet TEGradientView *gradientPreview;

- (void)changeDoubleSided:(NSButton *)checkBox;

@end
