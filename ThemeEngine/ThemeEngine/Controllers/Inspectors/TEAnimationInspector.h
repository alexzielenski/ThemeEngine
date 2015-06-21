//
//  TEAnimationInspector.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import "TEAnimationView.h"

@interface TEAnimationInspector : TEInspectorDetailController
@property (weak) IBOutlet TEAnimationView *animationView;
@property CGFloat frameWidth;
@end
