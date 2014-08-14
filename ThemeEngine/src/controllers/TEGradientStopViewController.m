//
//  TEGradientStopViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEGradientStopViewController.h"

@interface TEGradientStopViewController ()
- (void)gradientChanged:(CFTGradientEditor *)editor;
@end

@implementation TEGradientStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.gradientPreview bind:@"angle" toObject:self withKeyPath:@"angle" options:nil];
    [self.gradientPreview bind:@"radial" toObject:self withKeyPath:@"radial" options:nil];
    
    // Do view setup here.
    self.gradientEditor.target = self;
    self.gradientEditor.action = @selector(gradientChanged:);

    [self addObserver:self forKeyPath:@"gradientEditor.selectedStop" options:0 context:nil];
    [self addObserver:self forKeyPath:@"gradientEditor.gradient" options:0 context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"gradientEditor.gradient"];
    [self removeObserver:self forKeyPath:@"gradientEditor.selectedStop"];
    [self.gradientPreview unbind:@"angle"];
    [self.gradientPreview unbind:@"radial"];
}

- (void)gradientChanged:(CFTGradientEditor *)editor {
    self.gradientPreview.gradient = editor.gradient;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"gradientEditor.gradient"]) {
        self.gradientPreview.gradient = self.gradientEditor.gradient;
    } else if ([keyPath isEqualToString:@"gradientEditor.selectedStop"]) {
        self.doubleSidedCheckbox.state = self.gradientEditor.selectedStop.isDoubleStop ? NSOnState : NSOffState;
    }
}

- (IBAction)changeDoubleSided:(NSButton *)checkBox {
    if (!self.gradientEditor.selectedStop || self.gradientEditor.selectedStop.isMidpointStop)
        return;

    [self.gradientEditor setStop:self.gradientEditor.selectedStop doubleSided:checkBox.state == NSOnState];
    checkBox.state = self.gradientEditor.selectedStop.isDoubleStop ? NSOnState : NSOffState;
}

@end
