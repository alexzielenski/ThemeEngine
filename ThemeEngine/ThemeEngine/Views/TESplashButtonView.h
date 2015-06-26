//
//  TESplashButtonView.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TESplashImageView : NSImageView
@end

@interface TESplashButtonView : NSView
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSImageView *imageView;
@property (copy) IBInspectable NSColor *highlightColor;
@property (copy) IBInspectable NSColor *pressColor;
@property (assign) IBInspectable CGFloat cornerRadius;
@property (assign) IBOutlet id target;
@property (assign) SEL action;
@property (assign) IBInspectable NSString *actionName;
@end
