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

}

- (void)dealloc {
    [self.gradientPreview unbind:@"angle"];
    [self.gradientPreview unbind:@"radial"];
}

- (void)gradientChanged:(CFTGradientEditor *)editor {
    
    self.gradientPreview.gradient = editor.gradient;
}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"stop"]) {
//        if (self.stop.isOpacityStop) {
//            self.opacityField.enabled = YES;
//            self.gradientColorWell.enabled = NO;
//            self.leadOutColorWell.enabled = NO;
//            self.doubleSidedCheckbox.enabled = YES;
//        } else if (self.stop.isColorStop) {
//            self.opacityField.enabled = NO;
//            self.gradientColorWell.enabled = YES;
//            self.leadOutColorWell.enabled = self.stop.isDoubleStop;
//            self.doubleSidedCheckbox.enabled = YES;
//        } else {
//            self.opacityField.enabled = NO;
//            self.gradientColorWell.enabled = NO;
//            self.leadOutColorWell.enabled = NO;
//            self.doubleSidedCheckbox.enabled = NO;
//        }
//    }
//}

- (IBAction)changeDoubleSided:(NSButton *)checkBox {
    
}

@end
