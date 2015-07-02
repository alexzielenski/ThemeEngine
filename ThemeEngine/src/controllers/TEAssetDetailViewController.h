//
//  CHAssetDetailViewController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TEImageSliceView.h"
#import "CFTAsset.h"
#import "ZKInspector.h"

#import "TEGradientView.h"
#import "TEGradientStopViewController.h"
#import "TEAnimationView.h"
#import "TELayerEffectsViewController.h"

@interface TEAssetDetailViewController : NSViewController
@property (strong) CFTAsset *asset;
@property (weak) IBOutlet NSView *contentView;

// Content Views
@property (weak) IBOutlet NSView *bitmapView;
@property (weak) IBOutlet NSView *pdfView;
@property (weak) IBOutlet NSView *colorView;
@property (weak) IBOutlet NSView *animationView;

// Inspector Panels
@property (weak) IBOutlet NSView *attributesPanel;
@property (weak) IBOutlet NSView *infoPanel;
@property (weak) IBOutlet NSView *colorPanel;
@property (weak) IBOutlet NSView *gradientPanel;
@property (weak) IBOutlet NSView *effectPanel;
@property (weak) IBOutlet NSView *slicePanel;
@property (weak) IBOutlet NSView *animationPanel;

// Attributes
@property (assign) CGFloat opacity;
@property (assign) CFTEXIFOrientation exifOrientation;
@property (assign) CGBlendMode blendMode;
@property (copy) NSString *utiType;

// Bitmap
@property (weak) IBOutlet TEImageSliceView *imageSliceView;
@property (weak) IBOutlet NSSegmentedControl *typeSegment;
@property (weak) IBOutlet ZKInspector *inspector;
@property (weak) IBOutlet NSTextField *sizeField;
@property (assign) CGFloat topInset;
@property (assign) CGFloat leftInset;
@property (assign) CGFloat rightInset;
@property (assign) CGFloat bottomInset;

// Color
@property (weak) IBOutlet NSView *colorPreview;
@property (copy) NSColor *color;

// PDF
@property (strong) PDFDocument *pdf;
@property (weak) IBOutlet PDFView *pdfPreview;

// Gradients
@property (weak) IBOutlet TEGradientStopViewController *gradientViewController;
@property (copy) CFTGradient *gradient;

// Effects
@property (weak) IBOutlet TELayerEffectsViewController *effectsViewController;

// Animations
@property (weak) IBOutlet TEAnimationView *animationImageView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
