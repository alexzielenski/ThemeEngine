//
//  CHAssetDetailViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CHImageSliceView.h"
#import "CFTAsset.h"
#import "ZKInspector.h"

@interface CHAssetDetailViewController : NSViewController
@property (weak) IBOutlet CHImageSliceView *imageSliceView;
@property (weak) IBOutlet NSSegmentedControl *typeSegment;
@property (weak) IBOutlet ZKInspector *inspector;
@property (strong) CFTAsset *asset;
@property (weak) IBOutlet NSTextField *sizeField;

@property (weak) IBOutlet NSView *attributesPanel;
@property (weak) IBOutlet NSView *infoPanel;

@property (assign) CGFloat opacity;
@property (assign) CFTEXIFOrientation exifOrientation;
@property (assign) CGBlendMode blendMode;
@property (copy) NSString *utiType;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
