//
//  TELayerEffectsViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/15/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTEffectWrapper.h"

@interface TELayerEffectsViewController : NSViewController
@property (weak) IBOutlet NSTableView *tableView;
@property (copy) CFTEffectWrapper *effectWrapper;
@property (strong) CFTEffect *currentEffect;
@property (weak) IBOutlet NSMenu *addMenu;

@property (readonly) BOOL canEditColor1;
@property (readonly) BOOL canEditColor2;
@property (readonly) BOOL canEditOpacity1;
@property (readonly) BOOL canEditOpacity2;
@property (readonly) BOOL canEditBlurRadius;
@property (readonly) BOOL canEditBlendMode;
@property (readonly) BOOL canEditOffset;
@property (readonly) BOOL canEditAngle;
@property (readonly) BOOL canEditSoften;
@property (readonly) BOOL canEditSpread;

- (IBAction)addSelection:(NSMenuItem *)sender;

@end
