//
//  TEGradientInspector.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import "TEGradientEditor.h"

@interface TEGradientInspector : TEInspectorDetailController
@property (weak) IBOutlet TEGradientEditor *gradientEditor;
@end
