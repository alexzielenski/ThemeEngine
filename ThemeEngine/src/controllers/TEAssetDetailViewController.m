//
//  CHAssetDetailViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEAssetDetailViewController.h"

@interface TEAssetDetailViewController () <ZKInspectorDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (strong) CFTEffect *currentEffect;
- (void)gradientChanged:(id)sender;
@end
 

@implementation TEAssetDetailViewController
@dynamic topInset, bottomInset, leftInset, rightInset;
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
    
    [self addObserver:self forKeyPath:@"asset" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.type" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.pdfData" options:0 context:nil];
    [self addObserver:self forKeyPath:@"color" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.gradient" options:0 context:nil];
    [self addObserver:self forKeyPath:@"currentEffect" options:0 context:nil];
    
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
//    self.effectTableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleGap;
    [self.effectTableView addTableColumn:column];
}

- (void)dealloc {
    [self.gradientPreview unbind:@"angle"];
    [self.gradientPreview unbind:@"radial"];
    [self.gradientPreview unbind:@"gradient"];
    [self.pdfPreview unbind:@"document"];
    [self.imageSliceView unbind:@"themeType"];
    [self.imageSliceView unbind:@"sliceRects"];
    
    [self removeObserver:self forKeyPath:@"asset"];
    [self removeObserver:self forKeyPath:@"asset.pdfData"];
    [self removeObserver:self forKeyPath:@"asset.type"];
    [self removeObserver:self forKeyPath:@"color"];
    [self removeObserver:self forKeyPath:@"asset.gradient"];
    [self removeObserver:self forKeyPath:@"currentEffect"];
    [self removeObserver:self forKeyPath:@"asset.image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"asset.image"]) {
        [self.imageSliceView setImage:self.asset.image.CGImage imageProperties:nil];
        [self.imageSliceView setZoomFactor:1.0];
        
        self.sizeField.stringValue = [NSString stringWithFormat:@"%zupx x %zupx", self.asset.image.pixelsWide, self.asset.image.pixelsHigh];
    } else if ([keyPath isEqualToString:@"asset.type"]) {
        if (self.asset.type <= 3) {
            self.typeSegment.hidden = NO;
            [self.typeSegment setSelectedSegment:self.asset.type];
        } else
            self.typeSegment.hidden = YES;
        for (int x = (int)self.inspector.numberOfViews - 2; x >= 0; x--)
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
                [self.inspector insertView:self.attributesPanel withTitle:@"Attributes" atIndex:0 expanded:NO];
                [self.inspector insertView:self.slicePanel withTitle:@"Slices" atIndex:0 expanded:YES];
                break;
            default:
                break;
        }

        content.frame = self.contentView.bounds;
        [self.contentView addSubview:content];
        
    } else if ([keyPath isEqualToString:@"asset"]) {
        self.currentEffect = nil;
        
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
    } else if ([keyPath isEqualToString:@"currentEffect"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (self.currentEffect.type) {
                case CUIEffectTypeBevelAndEmboss:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = YES;
                    self.effectBlurRadiusView.enabled = YES;
                    self.effectSoftenView.enabled = YES;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = YES;
                    self.effectBlendModeView.enabled = NO;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeColorFill:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = NO;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = YES;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeDropShadow:
                case CUIEffectTypeExtraShadow:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = YES;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = NO;
                    self.effectOffsetView.enabled = YES;
                    self.effectAngleView.enabled = YES;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeGradient:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = YES;
                    self.effectBlurRadiusView.enabled = NO;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = NO;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeInnerGlow:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = YES;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = YES;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeInnerShadow:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = YES;
                    self.effectSoftenView.enabled = YES;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = YES;
                    self.effectOffsetView.enabled = YES;
                    self.effectAngleView.enabled = YES;
                    self.effectSpreadView.enabled = NO;
                    break;
                case CUIEffectTypeOuterGlow:
                    self.effectColorView.enabled = YES;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = YES;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = NO;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = YES;
                    break;
                case CUIEffectTypeOutputOpacity:
                case CUIEffectTypeShapeOpacity:
                    self.effectColorView.enabled = NO;
                    self.effectColor2View.enabled = NO;
                    self.effectBlurRadiusView.enabled = NO;
                    self.effectSoftenView.enabled = NO;
                    self.effectOpacityView.enabled = YES;
                    self.effectOpacity2View.enabled = NO;
                    self.effectBlendModeView.enabled = NO;
                    self.effectOffsetView.enabled = NO;
                    self.effectAngleView.enabled = NO;
                    self.effectSpreadView.enabled = NO;
                default:
                    break;
            }
        });
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
    self.asset.slices = self.imageSliceView.sliceRects;
    self.asset.exifOrientation = self.exifOrientation;
    self.asset.utiType = self.utiType;
    self.asset.blendMode = self.blendMode;
    self.asset.opacity = self.opacity;
    self.asset.effectPreset = self.effectWrapper;
    self.asset.color = self.color;
}

- (void)gradientChanged:(id)sender {
    self.gradient = self.gradientEditor.gradient;
}

#pragma mark - Properties

- (CGFloat)topInset {
    return self.imageSliceView.edgeInsets.top;
}

- (void)setTopInset:(CGFloat)topInset {
    NSEdgeInsets insets = self.imageSliceView.edgeInsets;
    insets.top = topInset;
    self.imageSliceView.edgeInsets = insets;
}

- (CGFloat)leftInset {
    return self.imageSliceView.edgeInsets.left;
}

- (void)setLeftInset:(CGFloat)leftInset {
    NSEdgeInsets insets = self.imageSliceView.edgeInsets;
    insets.left = leftInset;
    self.imageSliceView.edgeInsets = insets;
}

- (CGFloat)bottomInset {
    return self.imageSliceView.edgeInsets.bottom;
}

- (void)setBottomInset:(CGFloat)bottomInset {
    NSEdgeInsets insets = self.imageSliceView.edgeInsets;
    insets.bottom = bottomInset;
    self.imageSliceView.edgeInsets = insets;
}

- (CGFloat)rightInset {
    return self.imageSliceView.edgeInsets.right;
}

- (void)setRightInset:(CGFloat)rightInset {
    NSEdgeInsets insets = self.imageSliceView.edgeInsets;
    insets.right = rightInset;
    self.imageSliceView.edgeInsets = insets;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasSuffix:@"Inset"]) {
        return [NSSet setWithObject:@"imageSliceView.edgeInsets"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

#pragma mark - NSTableViewDataSource

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
    if (self.effectTableView.selectedRow != -1)
        self.currentEffect = self.effectWrapper.effects[self.effectTableView.selectedRow];
    else
        self.currentEffect = nil;
}

#define kTEDetailType @"asdasdasd"

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard setPropertyList:@[ @(rowIndexes.firstIndex) ] forType:kTEDetailType];
    [aTableView registerForDraggedTypes:@[kTEDetailType]];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
    if (info.draggingSource == self.effectTableView && operation == NSTableViewDropAbove)
        return NSDragOperationMove;
    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    if (info.draggingSource != self.effectTableView)
        return NO;
    NSUInteger originalRow = [[[info.draggingPasteboard propertyListForType:kTEDetailType] firstObject] unsignedIntegerValue];
    [self.effectWrapper moveEffectAtIndex:originalRow toIndex:row];
    [aTableView moveRowAtIndex:originalRow toIndex:row];
    return YES;
}

@end

@interface TEHorizontalInsetValueTransformer : NSValueTransformer
@end

@implementation TEHorizontalInsetValueTransformer

+ (Class)transformedValueClass {
    return [NSNumber class];
}

- (NSNumber *)transformedValue:(NSNumber *)value {
    return @(value.intValue == kCoreThemeTypeThreePartHorizontal  || value.intValue == kCoreThemeTypeNinePart);
}

@end

@interface TEVerticalInsetValueTransformer : NSValueTransformer
@end

@implementation TEVerticalInsetValueTransformer

+ (Class)transformedValueClass {
    return [NSNumber class];
}

- (NSNumber *)transformedValue:(NSNumber *)value {
    return @(value.intValue == kCoreThemeTypeThreePartVertical  || value.intValue == kCoreThemeTypeNinePart);
}

@end

