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

#import "CFTGradientEditor.h"
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
@property (weak) IBOutlet NSView *slicePanel;

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
@property (assign, getter=isGradientRadial) BOOL gradientRadial;
@property (assign) CGFloat gradientAngle;
@property (strong) CUIThemeGradient *gradient;
@property (weak) IBOutlet CFTGradientEditor *gradientEditor;
@property (weak) IBOutlet TEGradientView *gradientPreview;

// Effects
@property (weak) IBOutlet NSTableView *effectTableView;
@property (copy) CFTEffectWrapper *effectWrapper;
@property (weak) IBOutlet NSColorWell *effectColorView;
@property (weak) IBOutlet NSColorWell *effectColor2View;
@property (weak) IBOutlet NSControl *effectOpacityView;
@property (weak) IBOutlet NSControl *effectOpacity2View;
@property (weak) IBOutlet NSControl *effectBlurRadiusView;
@property (weak) IBOutlet NSControl *effectOffsetView;
@property (weak) IBOutlet NSControl *effectAngleView;
@property (weak) IBOutlet NSControl *effectBlendModeView;
@property (weak) IBOutlet NSControl *effectSoftenView;
@property (weak) IBOutlet NSControl *effectSpreadView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
