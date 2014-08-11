//
//  CHAssetDetailViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CHAssetDetailViewController.h"

@interface CHAssetDetailViewController ()

@end

@implementation CHAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.typeSegment setImage:[[NSCursor resizeLeftRightCursor] image] forSegment:1];
    [self.typeSegment setImage:[[NSCursor resizeUpDownCursor] image] forSegment:2];
    [self.typeSegment setImage:[NSImage imageNamed:@"Square"] forSegment:3];
    
    [self.imageSliceView bind:@"themeType" toObject:self withKeyPath:@"asset.type" options:nil];
    [self.imageSliceView bind:@"sliceRects" toObject:self withKeyPath:@"asset.slices" options:nil];
    
    [self addObserver:self forKeyPath:@"asset.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"asset.type" options:0 context:nil];
    
    //!TODO: Get scrolling in the image view to work
//    self.imageSliceView.hasHorizontalScroller = YES;
//    self.imageSliceView.hasVerticalScroller = YES;
//    self.imageSliceView.autohidesScrollers = NO;
//    self.imageSliceView.autoresizes = NO;
    self.imageSliceView.backgroundColor = [NSColor whiteColor];
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
        
    }
}

@end
