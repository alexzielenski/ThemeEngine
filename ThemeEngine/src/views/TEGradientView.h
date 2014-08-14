//
//  CHGradientView.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/11/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTGradient.h"

@interface TEGradientView : NSView
@property (strong) CFTGradient *gradient;
@end
