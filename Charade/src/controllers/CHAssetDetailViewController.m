//
//  CHAssetDetailViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CHAssetDetailViewController.h"

@interface CHAssetDetailViewController () <ZKInspectorDelegate>

@end

@implementation CHAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.typeSegment setImage:[[NSCursor resizeLeftRightCursor] image] forSegment:1];
    [self.typeSegment setImage:[[NSCursor resizeUpDownCursor] image] forSegment:2];
    [self.typeSegment setImage:[NSImage imageNamed:@"Square"] forSegment:3];
    
    [self.imageSliceView bind:@"themeType" toObject:self withKeyPath:@"asset.type" options:nil];
    [self.imageSliceView bind:@"sliceRects" toObject:self withKeyPath:@"asset.slices" options:nil];
    
    [self addObserver:self forKeyPath:@"asset" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.type" options:0 context:nil];
    
    //!TODO: Get scrolling in the image view to work
//    self.imageSliceView.hasHorizontalScroller = YES;
//    self.imageSliceView.hasVerticalScroller = YES;
//    self.imageSliceView.autohidesScrollers = NO;
//    self.imageSliceView.autoresizes = NO;
    self.imageSliceView.backgroundColor = [NSColor whiteColor];
    
    self.inspector.inspectorDelegate = self;
    [self.inspector addView:self.attributesPanel withTitle:@"Attributes" expanded:YES];
    [self.inspector addView:self.infoPanel withTitle:@"Info" expanded:NO];
    [self.inspector expandViewAtIndex:0];
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
        
    } else if ([keyPath isEqualToString:@"asset"]) {
        self.exifOrientation = self.asset.exifOrientation;
        self.utiType = self.asset.utiType;
        self.opacity = self.asset.opacity;
        self.blendMode = self.asset.blendMode;
    }
}

- (IBAction)cancel:(id)sender {
    __weak CHAssetDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.presentingViewController dismissViewController:self];
    });
}

- (IBAction)save:(id)sender {
    [self cancel:sender];
//    self.asset.slices = self.imageSliceView.sliceRects;
    self.asset.exifOrientation = self.exifOrientation;
    self.asset.utiType = self.utiType;
    self.asset.blendMode = self.blendMode;
    self.asset.opacity = self.opacity;
}


@end
