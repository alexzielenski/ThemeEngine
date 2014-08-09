//
//  CHElementViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CHElementViewController.h"
#import <Quartz/Quartz.h>

@interface CHElementViewController ()
@property (strong) NSArray *assets;
- (void)_initialize;
@end

@implementation CHElementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self _initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"elements"];
}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"elements" options:0 context:nil];
}

- (void)awakeFromNib {
//    self.imageBrowserView.cellSize = NSMakeSize(96, 96);
    self.imageBrowserView.constrainsToOriginalSize = YES;
    self.imageBrowserView.contentResizingMask = NSViewHeightSizable;
    self.imageBrowserView.canControlQuickLookPanel = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"elements"]) {
        self.assets = [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] allObjects];
        [self.imageBrowserView reloadData];
    }
}

#pragma mark - IKImageBrowserView

- (void) imageBrowser:(IKImageBrowserView *)browser cellWasDoubleClickedAtIndex:(NSUInteger)index {
    // open up popover where the user can edit shit like gradients, effects
}

- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *) browser {
    if (browser.selectionIndexes.count == 1) {
        self.statusLabel.stringValue = [self.assets[browser.selectionIndexes.firstIndex] debugDescription];
        self.statusLabel.toolTip = [self.statusLabel.stringValue stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
    } else if (browser.selectionIndexes.count > 1) {
        self.statusLabel.stringValue = @"Multible Selection";
        self.statusLabel.toolTip = @"";
    } else {
        self.statusLabel.stringValue = @"No Selection";
        self.statusLabel.toolTip = @"";
    }
}

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *) browser {
    return self.assets.count;
}

- (id)imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index {
    return [self.assets objectAtIndex:index];
}

@end

@interface CFTAsset (ImageKit)
@end

@implementation CFTAsset (ImageKit)


- (id)imageRepresentation {
    return self.previewImage;
}

- (NSString *)imageRepresentationType {
    return IKImageBrowserNSImageRepresentationType;
}

- (NSString *)imageUID {
    if (self.type == kCoreThemeTypePDF || self.type == kCoreThemeTypeRawData || self.type == kCoreThemeTypeRawPixel)
        return self.rawData.description;
    else if (self.type == kCoreThemeTypeGradient)
        return self.gradient.description;
    else if (self.type == kCoreThemeTypeEffect)
        return self.effectPreset.description;
    return [(__bridge id)self.image description];
}

@end

@interface CHPreviewItem : NSObject <QLPreviewItem>
@property (readwrite, copy) NSURL *previewItemURL;
@property (readwrite, copy) NSString *previewItemTitle;
@property (readwrite, strong) id previewItemDisplayState;
@end

@implementation CHPreviewItem
@end

@interface IKImageBrowserView (QL)
@end

@implementation IKImageBrowserView (QL)

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    NSUInteger idx = [self.selectionIndexes firstIndex];
    if (idx > [self.dataSource numberOfItemsInImageBrowser:self])
        return nil;
    
    CFTAsset *asset = [self.dataSource imageBrowser:self itemAtIndex:idx];
    CHPreviewItem *item = [[CHPreviewItem alloc] init];
    item.previewItemDisplayState = panel.displayState;
    item.previewItemTitle = asset.name;
    
    NSImage *previewImage = asset.previewImage;
    NSImageRep *rep = previewImage.representations[0];
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:asset.imageUID];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([rep isKindOfClass:[NSPDFImageRep class]]) {
        tempPath = [tempPath stringByAppendingPathExtension:@"pdf"];
        if (![manager fileExistsAtPath:tempPath])
            [[(NSPDFImageRep *)rep PDFRepresentation] writeToFile:tempPath atomically:NO];
    } else if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
        tempPath = [tempPath stringByAppendingPathExtension:@"png"];
        if (![manager fileExistsAtPath:tempPath])
            [[(NSBitmapImageRep *)rep representationUsingType:NSPNGFileType properties:nil] writeToFile:tempPath atomically:NO];
    } else {
        tempPath = [tempPath stringByAppendingPathComponent:@"tiff"];
        if (![manager fileExistsAtPath:tempPath])
            [[previewImage TIFFRepresentation] writeToFile:tempPath atomically:NO];
    }
    
    item.previewItemURL = [NSURL fileURLWithPath:tempPath];
    return item;
}

@end
