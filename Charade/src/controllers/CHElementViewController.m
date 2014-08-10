//
//  CHElementViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CHElementViewController.h"
#import "CHAssetDetailViewController.h"
#import <Quartz/Quartz.h>

@interface CHElementViewController ()
@property (strong) NSArray *assets;
@property (strong) NSArray *filteredAssets;
@property (strong) NSString *lastQuery;
@property (strong) NSPopover *detailPopover;
@property (strong) CHAssetDetailViewController *detailPopoverViewController;
- (void)_initialize;
- (void)_filterPredicates;
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
    self.imageBrowserView.allowsDroppingOnItems = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"elements"]) {
        self.assets = [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] allObjects];
        self.filteredAssets = self.assets;
        [self _filterPredicates];
        [self.imageBrowserView reloadData];
    }
}

- (IBAction)searchChanged:(NSSearchField *)sender {
    [self _filterPredicates];
}

- (void)_filterPredicates {
    if (self.search.stringValue.length >= 3) {
        NSMutableArray *terms = [NSMutableArray array];
        for (NSString *term in [self.search.stringValue componentsSeparatedByString:@" "]) {
            if (term.length == 0)
                continue;
            
            NSMutableString *field = term.mutableCopy;
            NSString *format = @"ANY keywords LIKE[cd] %@";

            if ([field rangeOfString:@"\""].location == NSNotFound) {
                [field appendString:@"*"];
            } else {
                NSUInteger length = field.length;
                [field replaceOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, field.length)];
                // don't use this term if the second quote isnt there
                if (length != field.length + 2)
                    continue;
                
            }
            
            if ([field rangeOfString:@"!"].location == 0) {
                format = [format stringByReplacingOccurrencesOfString:@"ANY" withString:@"NONE"];
                [field deleteCharactersInRange:NSMakeRange(0, 1)];
            }
            
            if ([field isEqualToString:@"*"])
                continue;
            
            if (field.length == 0)
                continue;
            
            [terms addObject:[NSPredicate predicateWithFormat:format, field]];
        }
        
        // Only search the filtered assets if the user is writing to the end of the query
        // otherwise they could be editing something that changes the entire thing
        self.filteredAssets = [[self.search.stringValue hasPrefix:self.lastQuery] ? self.filteredAssets : self.assets filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:terms]];
    } else {
        self.filteredAssets = self.assets;
    }
    
    self.lastQuery = self.search.stringValue;
    [self.imageBrowserView reloadData];
}

- (IBAction)copy:(id)sender {
    NSLog(@"copy");
}

- (IBAction)paste:(id)sender {
    
}


- (NSUInteger)imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
    NSLog(@"write: %@", [self.filteredAssets objectsAtIndexes:itemIndexes]);
    [pasteboard clearContents];    
    [pasteboard writeObjects:[self.filteredAssets objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}


#pragma mark - IKImageBrowserView

- (void) imageBrowser:(IKImageBrowserView *)browser cellWasDoubleClickedAtIndex:(NSUInteger)index {
    // open up popover where the user can edit shit like gradients, effects
    if (!self.detailPopoverViewController) {
        self.detailPopoverViewController = [[CHAssetDetailViewController alloc] initWithNibName:@"CHAssetDetailViewController" bundle:nil];
    }
    
    if (!self.detailPopover) {
        self.detailPopover = [[NSPopover alloc] init];
        self.detailPopover.contentViewController = self.detailPopoverViewController;
    }
    
    IKImageBrowserCell *cell = [browser cellForItemAtIndex:index];
    [self.detailPopover showRelativeToRect:cell.frame ofView:cell.imageBrowserView preferredEdge:CGRectMaxXEdge];
    self.detailPopoverViewController.asset = self.filteredAssets[index];
}

- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *) browser {
    if (browser.selectionIndexes.count == 1) {
        self.statusLabel.stringValue = [self.filteredAssets[browser.selectionIndexes.firstIndex] debugDescription];
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
    return self.filteredAssets.count;
}

- (id)imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index {
    return [self.filteredAssets objectAtIndex:index];
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSUInteger idx = [self.imageBrowserView indexAtLocationOfDroppedItem];
    CoreThemeType type = [(CFTAsset *)self.filteredAssets[idx] type];
    if ([NSImage canInitWithPasteboard:sender.draggingPasteboard] && self.imageBrowserView.dropOperation == IKImageBrowserDropOn &&
        (type <= kCoreThemeTypeSixPart || type == kCoreThemeTypeAnimation || type == kCoreThemeTypePDF) && sender.numberOfValidItemsForDrop == 1)
        return NSDragOperationCopy;
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSUInteger idx = [self.imageBrowserView indexAtLocationOfDroppedItem];
    CFTAsset *asset = self.filteredAssets[idx];
    
    switch (asset.type) {
        case kCoreThemeTypeOnePart:
        case kCoreThemeTypeThreePartHorizontal:
        case kCoreThemeTypeThreePartVertical:
        case kCoreThemeTypeNinePart:
        case kCoreThemeTypeSixPart:
        case kCoreThemeTypeAnimation:
        case kCoreThemeTypeGradient: {
            // bitmaps
            CGImageRef image = [[NSBitmapImageRep imageRepsWithPasteboard:sender.draggingPasteboard][0] CGImage];
            //!TODO Remove this restriction
            if (CGImageGetWidth(asset.image) == CGImageGetWidth(image) && CGImageGetHeight(asset.image) == CGImageGetHeight(image)) {
                asset.image = image;
            } else {
                NSRunAlertPanel(@"Invalid Image", @"Sizes must be equal", @"Sorry, boss", nil, nil);
            }
            break;
        }
        case kCoreThemeTypePDF:
            asset.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[sender.draggingPasteboard stringForType:(__bridge NSString *)kUTTypeFileURL]]];
        default:
            break;
    }
    
    return YES;
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
    [self.imageBrowserView reloadData];
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
    else if (self.type == kCoreThemeTypeColor) {
        return [NSString stringWithFormat:@"%f, %f, %f, %f", self.color.redComponent, self.color.greenComponent, self.color.blueComponent, self.color.alphaComponent];
    }
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
