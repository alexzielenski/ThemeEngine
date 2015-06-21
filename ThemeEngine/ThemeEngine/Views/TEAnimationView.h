//
//  TEAnimationView.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/20/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TEAnimationView : NSView
@property (strong) NSBitmapImageRep *image;
@property CGFloat frameWidth;
@property NSUInteger framesPerSecond;
@end
