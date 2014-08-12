//
//  CHAssetDetailViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEAssetDetailViewController.h"

@interface TEAssetDetailViewController () <ZKInspectorDelegate, NSTableViewDataSource, NSTableViewDelegate>
- (void)gradientChanged:(id)sender;
@end
 

@implementation TEAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.typeSegment setImage:[[NSCursor resizeLeftRightCursor] image] forSegment:1];
    [self.typeSegment setImage:[[NSCursor resizeUpDownCursor] image] forSegment:2];
    [self.typeSegment setImage:[NSImage imageNamed:@"Square"] forSegment:3];
    
    [self.imageSliceView bind:@"themeType" toObject:self withKeyPath:@"asset.type" options:nil];
    [self.imageSliceView bind:@"sliceRects" toObject:self withKeyPath:@"asset.slices" options:nil];
    [self.pdfPreview bind:@"document" toObject:self withKeyPath:@"pdf" options:nil];
    
    [self.gradientPreview bind:@"angle" toObject:self withKeyPath:@"gradientAngle" options:nil];
    [self.gradientPreview bind:@"radial" toObject:self withKeyPath:@"gradientRadial" options:nil];
    [self.gradientPreview bind:@"gradient" toObject:self withKeyPath:@"gradient" options:nil];
    
    //!TODO Remove observers
    [self addObserver:self forKeyPath:@"asset" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.type" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.pdfData" options:0 context:nil];
    [self addObserver:self forKeyPath:@"color" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.gradient" options:0 context:nil];
    
    //!TODO: Get scrolling in the image view to work
    //    self.imageSliceView.hasHorizontalScroller = YES;
    //    self.imageSliceView.hasVerticalScroller = YES;
    //    self.imageSliceView.autohidesScrollers = NO;
    //    self.imageSliceView.autoresizes = NO;
    self.imageSliceView.backgroundColor = [NSColor whiteColor];
    
    self.inspector.inspectorDelegate = self;
    [self.inspector addView:self.infoPanel withTitle:@"Info" expanded:NO];
    
    self.gradientEditor.target = self;
    self.gradientEditor.action = @selector(gradientChanged:);
    
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"EffectsColumn"];
    column.resizingMask = NSTableColumnAutoresizingMask;
    column.width = self.inspector.frame.size.width;
    column.minWidth = column.width;
    self.effectTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    self.effectTableView.backgroundColor = [NSColor clearColor];
    self.effectTableView.floatsGroupRows = NO;
    self.effectTableView.focusRingType = NSFocusRingTypeNone;
    [self.effectTableView addTableColumn:column];
}

- (void)dealloc {
    [self.imageSliceView unbind:@"themeType"];
    [self.imageSliceView unbind:@"sliceRects"];
    [self removeObserver:self forKeyPath:@"asset.image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"asset.image"]) {
        [self.imageSliceView setImage:self.asset.image imageProperties:nil];
        [self.imageSliceView setZoomFactor:1.0];
        
        self.sizeField.stringValue = [NSString stringWithFormat:@"%zupx x %zupx", CGImageGetWidth(self.asset.image), CGImageGetHeight(self.asset.image)];
    } else if ([keyPath isEqualToString:@"asset.type"]) {
        if (self.asset.type <= 3) {
            self.typeSegment.hidden = NO;
            [self.typeSegment setSelectedSegment:self.asset.type];
        } else
            self.typeSegment.hidden = YES;
        
        for (int x = 0; x < self.inspector.numberOfViews - 1; x++)
            [self.inspector removeViewAtIndex:x];
        
        [self.contentView setSubviews:@[]];
        self.sizeField.hidden = YES;
        NSView *content = nil;
        switch (self.asset.type) {
            case kCoreThemeTypeEffect:
                content = self.effectView;
                [self.inspector insertView:self.effectPanel withTitle:@"Layer Effects" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypeColor:
                content = self.colorView;
                [self.inspector insertView:self.colorPanel withTitle:@"Color" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypeGradient:
                content = self.gradientView;
                [self.inspector insertView:self.gradientPanel withTitle:@"Gradient" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypePDF:
                content = self.pdfView;
                [self.inspector expandViewAtIndex:0];
                break;
            case kCoreThemeTypeAnimation:
            case kCoreThemeTypeNinePart:
            case kCoreThemeTypeOnePart:
            case kCoreThemeTypeSixPart:
            case kCoreThemeTypeThreePartHorizontal:
            case kCoreThemeTypeThreePartVertical:
                self.sizeField.hidden = NO;
                content = self.bitmapView;
                [self.inspector insertView:self.attributesPanel withTitle:@"Attributes" atIndex:0 expanded:YES];
            default:
                break;
        }
        
        content.frame = self.contentView.bounds;
        [self.contentView addSubview:content];
        
    } else if ([keyPath isEqualToString:@"asset"]) {
        self.exifOrientation = self.asset.exifOrientation;
        self.utiType = self.asset.utiType;
        self.opacity = self.asset.opacity;
        self.blendMode = self.asset.blendMode;
        self.color = self.asset.color;
        self.effectWrapper = self.asset.effectPreset;
        
        [self.effectTableView reloadData];
    } else if ([keyPath isEqualToString:@"color"]) {
        self.colorPreview.layer.backgroundColor = self.color.CGColor;
    } else if ([keyPath isEqualToString:@"asset.pdfData"]) {
        self.pdf = [[PDFDocument alloc] initWithData:self.asset.pdfData];
    } else if ([keyPath isEqualToString:@"asset.gradient"]) {
        self.gradientAngle = self.asset.gradient.angle;
        self.gradientRadial = self.asset.gradient.isRadial;
        self.gradient = self.asset.gradient.gradientRepresentation;
        self.gradientEditor.gradient = self.gradient;
    }
}

- (IBAction)cancel:(id)sender {
    __weak TEAssetDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.presentingViewController dismissViewController:self];
    });
}

- (IBAction)save:(id)sender {
    [self cancel:sender];
    //!TODO set slices
    //    self.asset.slices = self.imageSliceView.sliceRects;
    self.asset.exifOrientation = self.exifOrientation;
    self.asset.utiType = self.utiType;
    self.asset.blendMode = self.blendMode;
    self.asset.opacity = self.opacity;
}

- (void)gradientChanged:(id)sender {
    self.gradient = self.gradientEditor.gradient;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.effectWrapper.effects.count ?: 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [[NSTableCellView alloc] initWithFrame:NSMakeRect(4, 0, tableView.frame.size.width, 18)];
    CUIEffectType type = -1;
    if (self.effectWrapper.effects.count > 0)
        type = [(CFTEffect *)self.effectWrapper.effects[row] type];
    cellView.wantsLayer = YES;
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, cellView.frame.size.width, 18)];
    textField.wantsLayer = YES;
    textField.bordered = NO;
    textField.selectable = NO;
    textField.drawsBackground = NO;
    [cellView addSubview:textField];
    
    if (self.effectWrapper.effects.count == 0)
        textField.stringValue = @"No items to show";
    else
        textField.stringValue = CUIEffectTypeToString(type);
    
    cellView.textField = textField;
    cellView.identifier = [@(type) stringValue];
    
    return cellView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return self.effectWrapper.effects.count > 0;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

}

@end
/*
 @interface CHAlwaysActiveTableView : NSTableView;
 @end
 
 @implementation CHAlwaysActiveTableView
 
 - (BOOL)resignFirstResponder {
 return YES;
 }
 
 @end
 */
