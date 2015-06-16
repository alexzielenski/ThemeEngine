//
//  TEInspectorController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TEInspectorDetailController.h"
@interface TEInspectorController : NSViewController
@property (strong) IBOutlet TEInspectorDetailController *attributesInspector;
@end
