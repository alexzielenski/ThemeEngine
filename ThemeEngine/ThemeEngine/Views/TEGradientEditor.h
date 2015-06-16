//
//  TEGradientEditor.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/ThemeKit.h>

@interface TEGradientEditor : NSView
@property (readonly, strong) TKGradientStop *selectedStop;
@property (strong) TKGradient *gradient;
@end
