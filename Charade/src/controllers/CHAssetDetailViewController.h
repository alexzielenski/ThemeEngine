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

@interface CHAssetDetailViewController : NSViewController
@property (weak) IBOutlet CHImageSliceView *imageSliceView;
@property (weak) IBOutlet NSSegmentedControl *typeSegment;
@property (strong) CFTAsset *asset;
@property (weak) IBOutlet NSTextField *sizeField;
@end
