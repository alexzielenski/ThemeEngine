//
//  CHAssetDetailViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEAssetDetailViewController.h"

@interface TEAssetDetailViewController () <ZKInspectorDelegate, NSTableViewDataSource, NSTableViewDelegate>
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
    
    [self.animationImageView bind:@"image" toObject:self withKeyPath:@"asset.image" options:nil];
    
    [self addObserver:self forKeyPath:@"asset" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.type" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.pdfData" options:0 context:nil];
    [self addObserver:self forKeyPath:@"color" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.gradient" options:0 context:nil];
    
    self.imageSliceView.hasHorizontalScroller = YES;
    self.imageSliceView.hasVerticalScroller = YES;
//    self.imageSliceView.autohidesScrollers = NO;
    self.imageSliceView.autoresizes = YES;
    
    self.inspector.inspectorDelegate = self;
    self.inspector.enclosingScrollView.drawsBackground = NO;
    self.inspector.backgroundColor = [NSColor clearColor];
//    self.inspector.enclosingScrollView.backgroundColor = [NSColor whiteColor];
//    self.inspector.backgroundColor = [NSColor whiteColor];

    [self.inspector addView:self.infoPanel withTitle:@"Info" expanded:NO];    
}

- (void)dealloc {
    [self.pdfPreview unbind:@"document"];
    [self.imageSliceView unbind:@"themeType"];
    [self.imageSliceView unbind:@"sliceRects"];
    [self removeObserver:self forKeyPath:@"asset"];
    [self removeObserver:self forKeyPath:@"asset.pdfData"];
    [self removeObserver:self forKeyPath:@"asset.type"];
    [self removeObserver:self forKeyPath:@"color"];
    [self removeObserver:self forKeyPath:@"asset.gradient"];
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
        [self.inspector reloadData];
        [self.contentView setSubviews:@[]];
        self.sizeField.hidden = YES;
        NSView *content = nil;
        switch (self.asset.type) {
            case kCoreThemeTypeEffect:
                content = self.effectsViewController.view;
                NSColorPanel.sharedColorPanel.showsAlpha = NO;
                [self.inspector insertView:self.effectPanel withTitle:@"Layer Effects" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypeColor:
                content = self.colorView;
                NSColorPanel.sharedColorPanel.showsAlpha = YES;
                [self.inspector insertView:self.colorPanel withTitle:@"Color" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypeGradient:
                content = self.gradientViewController.view;
                NSColorPanel.sharedColorPanel.showsAlpha = YES;
                [self.inspector insertView:self.gradientPanel withTitle:@"Gradient" atIndex:0 expanded:YES];
                break;
            case kCoreThemeTypePDF:
                content = self.pdfView;
                [self.inspector expandViewAtIndex:0];
                break;
            case kCoreThemeTypeAnimation: {
                content = self.animationView;
                //!TODO make this better
                self.animationImageView.frameWidth = [self.asset.slices[0] rectValue].size.width;
                [self.inspector insertView:self.animationPanel withTitle:@"Animation" atIndex:0 expanded:YES];
                break;
            }
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
        self.exifOrientation = self.asset.exifOrientation;
        self.utiType = self.asset.utiType;
        self.opacity = self.asset.opacity;
        self.blendMode = self.asset.blendMode;
        self.color = self.asset.color;
        self.effectsViewController.effectWrapper = self.asset.effectPreset;
    } else if ([keyPath isEqualToString:@"color"]) {
        self.colorPreview.layer.backgroundColor = self.color.CGColor;
    } else if ([keyPath isEqualToString:@"asset.pdfData"]) {
        self.pdf = [[PDFDocument alloc] initWithData:self.asset.pdfData];
    } else if ([keyPath isEqualToString:@"asset.gradient"]) {
        self.gradient = self.asset.gradient;
        self.gradientViewController.gradientEditor.gradientWrapper = self.gradient;
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
    if (self.asset.type != kCoreThemeTypeAnimation) {
        self.asset.slices = self.imageSliceView.sliceRects;
    } else {
        NSArray *slices = @[ [NSValue valueWithRect:NSMakeRect(0, 0,
                                                               self.animationImageView.frameWidth, self.animationImageView.image.pixelsHigh)],
                             [NSValue valueWithRect:NSMakeRect(self.animationImageView.frameWidth, 0,
                                                               self.animationImageView.image.pixelsWide - self.animationImageView.frameWidth,
                                                               self.animationImageView.image.pixelsHigh)]];
        self.asset.slices = slices;
    }
    self.asset.exifOrientation = self.exifOrientation;
    self.asset.utiType = self.utiType;
    self.asset.blendMode = self.blendMode;
    self.asset.opacity = self.opacity;
    self.asset.effectPreset = self.effectsViewController.effectWrapper;
    self.asset.color = self.color;
    self.asset.gradient = self.gradient;
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

