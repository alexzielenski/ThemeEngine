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

#import "ACTGradientEditor.h"
#import "TEGradientView.h"

@interface TEAssetDetailViewController : NSViewController
@property (strong) CFTAsset *asset;
@property (weak) IBOutlet NSView *contentView;

// Content Views
@property (weak) IBOutlet NSView *bitmapView;
@property (weak) IBOutlet NSView *gradientView;
@property (weak) IBOutlet NSView *effectView;
@property (weak) IBOutlet NSView *pdfView;
@property (weak) IBOutlet NSView *colorView;

// Inspector Panels
@property (weak) IBOutlet NSView *attributesPanel;
@property (weak) IBOutlet NSView *infoPanel;
@property (weak) IBOutlet NSView *colorPanel;
@property (weak) IBOutlet NSView *gradientPanel;
@property (weak) IBOutlet NSView *effectPanel;

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

// Color
@property (weak) IBOutlet NSView *colorPreview;
@property (copy) NSColor *color;

// PDF
@property (strong) PDFDocument *pdf;
@property (weak) IBOutlet PDFView *pdfPreview;

// Gradients
@property (assign, getter=isGradientRadial) BOOL gradientRadial;
@property (assign) CGFloat gradientAngle;
@property (strong) NSGradient *gradient;
@property (weak) IBOutlet ACTGradientEditor *gradientEditor;
@property (weak) IBOutlet TEGradientView *gradientPreview;

// Effects
@property (weak) IBOutlet NSTableView *effectTableView;
@property (copy) CFTEffectWrapper *effectWrapper;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
