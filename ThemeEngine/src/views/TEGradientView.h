//
//  CHGradientView.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/11/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CUIThemeGradient.h"
@interface TEGradientView : NSView
@property (strong) CUIThemeGradient *gradient;
@property (assign) CGFloat angle;
@property (assign, getter=isRadial) BOOL radial;
@end
