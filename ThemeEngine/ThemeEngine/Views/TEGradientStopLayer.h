//
//  TEGradientStopLayer.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <ThemeKit/ThemeKit.h>

@interface TEGradientStopLayer : CALayer
@property (strong) TKGradientStop *gradientStop;
@property (assign, getter=isSelected) BOOL selected;
@end
