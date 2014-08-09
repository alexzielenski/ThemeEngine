//
//  CHElementViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTElement.h"
#import <Quartz/Quartz.h>

IB_DESIGNABLE
@interface CHElementViewController : NSViewController
@property (weak) IBOutlet IKImageBrowserView *imageBrowserView;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (strong) NSArray *elements;
@end
