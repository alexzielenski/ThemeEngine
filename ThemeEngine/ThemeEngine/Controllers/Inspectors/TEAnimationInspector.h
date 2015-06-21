//
//  TEAnimationInspector.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import "TEAnimationView.h"
#import "TEBackgroundColorView.h"

@interface TEAnimationInspector : TEInspectorDetailController
@property (weak) IBOutlet TEAnimationView *animationView;
@property (weak) IBOutlet TEBackgroundColorView *backgroundView;
@property CGFloat frameWidth;
@property (nonatomic) BOOL drawsChecker;
@end
