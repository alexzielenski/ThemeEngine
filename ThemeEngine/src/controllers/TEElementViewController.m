//
//  CHElementViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEElementViewController.h"
#import "TEAssetDetailViewController.h"
#import <Quartz/Quartz.h>
#import "CFTAsset+Pasteboard.h"

@interface TEElementViewController ()
@property (strong) NSArray *assets;
@property (strong) NSArray *filteredAssets;
@property (strong) NSString *lastQuery;
@property (strong) TEAssetDetailViewController *detailPopoverViewController;
- (void)_initialize;
- (void)_filterPredicates;
- (BOOL)_pasteFromPasteboard:(NSPasteboard *)pb atIndex:(NSUInteger)index;
- (void)_startObservingAsset:(CFTAsset *)asset;
- (void)_stopObservingAsset:(CFTAsset *)asset;
@end

@implementation TEElementViewController

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
    [self removeObserver:self forKeyPath:@"assets"];
}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"elements" options:0 context:nil];
    [self addObserver:self forKeyPath:@"assets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
        
        __weak TEElementViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.detailPopoverViewController.presentingViewController)
                [weakSelf dismissViewController:self.detailPopoverViewController];
        });
        
        self.assets = [[self.elements valueForKeyPath:@"@distinctUnionOfSets.assets"] allObjects];
        self.filteredAssets = self.assets;
        [self _filterPredicates];
    } else if ([keyPath isEqualToString:@"previewImage"]) {
        [self.imageBrowserView reloadData];
    } else if ([keyPath isEqualToString:@"assets"]) {
        NSArray *newObjects = change[NSKeyValueChangeNewKey];
        NSArray *oldObjects = change[NSKeyValueChangeOldKey];
        
        if ([newObjects isKindOfClass:[NSNull class]])
            newObjects = nil;
        if ([oldObjects isKindOfClass:[NSNull class]])
            oldObjects = nil;
        
        for (id obj in newObjects)
            [self _startObservingAsset:obj];
        for (id obj in oldObjects)
            [self _stopObservingAsset:obj];
        
        [self.imageBrowserView reloadData];
    }
}

- (void)_startObservingAsset:(CFTAsset *)asset {
    [asset addObserver:self forKeyPath:@"previewImage" options:0 context:nil];
}

- (void)_stopObservingAsset:(CFTAsset *)asset {
    [asset removeObserver:self forKeyPath:@"previewImage"];
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

- (IBAction)paste:(id)sender {
    [self _pasteFromPasteboard:[NSPasteboard generalPasteboard] atIndex:self.imageBrowserView.selectionIndexes.firstIndex];
}


- (NSUInteger)imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
    [pasteboard clearContents];
    [pasteboard writeObjects:[self.filteredAssets objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}


#pragma mark - IKImageBrowserView

- (void)imageBrowser:(IKImageBrowserView *)browser cellWasDoubleClickedAtIndex:(NSUInteger)index {
    // open up popover where the user can edit shit like gradients, effects
    if (!self.detailPopoverViewController) {
        self.detailPopoverViewController = [[TEAssetDetailViewController alloc] initWithNibName:@"Detail" bundle:nil];
     }

    IKImageBrowserCell *cell = [browser cellForItemAtIndex:index];
    
    if (self.detailPopoverViewController.presentingViewController)
        [self dismissViewController:self.detailPopoverViewController];
    [self presentViewController:self.detailPopoverViewController
        asPopoverRelativeToRect:cell.frame
                         ofView:cell.imageBrowserView
                  preferredEdge:CGRectMaxXEdge
                       behavior:NSPopoverBehaviorApplicationDefined];
    
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
    return [self _pasteFromPasteboard:sender.draggingPasteboard atIndex:idx];
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
    [self.imageBrowserView reloadData];
}

- (BOOL)_pasteFromPasteboard:(NSPasteboard *)pb atIndex:(NSUInteger)index {
    CFTAsset *asset = self.filteredAssets[index];
    BOOL bad = NO;
    
    switch (asset.type) {
        case kCoreThemeTypeOnePart:
        case kCoreThemeTypeThreePartHorizontal:
        case kCoreThemeTypeThreePartVertical:
        case kCoreThemeTypeNinePart:
        case kCoreThemeTypeSixPart:
        case kCoreThemeTypeAnimation: {
            if (![pb canReadObjectForClasses:@[ [NSImage class] ] options:nil]) {
                bad = YES;
                break;
            }
            // bitmaps
            NSBitmapImageRep *image = [NSBitmapImageRep imageRepsWithPasteboard:pb][0];
            //!TODO Remove this restriction by asking user to re-slice
            if (asset.image.pixelsWide == image.pixelsWide && asset.image.pixelsHigh == image.pixelsHigh) {
                asset.image = image;
            } else {
                NSRunAlertPanel(@"Invalid Image", @"Sizes must be equal", @"Sorry, boss", nil, nil);
            }
            break;
        }
        case kCoreThemeTypePDF:
            if (![pb canReadItemWithDataConformingToTypes:@[ (__bridge NSString *)kUTTypePDF ] ]) {
                bad = YES;
                break;
            }
            asset.pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[pb stringForType:(__bridge NSString *)kUTTypeFileURL]]];
            break;
        case kCoreThemeTypeColor:
            if (![pb canReadObjectForClasses:@[ [NSColor class] ] options:nil]) {
                bad = YES;
                break;
            }
            asset.color = [NSColor colorFromPasteboard:pb];
            break;
        case kCoreThemeTypeEffect:
            if (![pb canReadObjectForClasses:@[ [CFTEffectWrapper class] ] options:nil]) {
                bad = YES;
                break;
            }
            asset.effectPreset = [CFTEffectWrapper effectWrapperFromPasteboard:pb];
            break;
        case kCoreThemeTypeGradient:
            if (![pb canReadObjectForClasses:@[ [CFTGradient class] ] options:nil]) {
                bad = YES;
                break;
            }
            asset.gradient = [CFTGradient gradientFromPasteboard:pb];
            break;
        default:
            break;
    }
    
    if (bad) {
        NSRunAlertPanel(@"Invalid type", @"The destination doesn't support this value type. (e.g. you copied a gradient to an image)", @"Sorry", nil, nil);
        return NO;
    }
    
    return YES;
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
    return [self.image description];
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
    NSString *tempPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] stringByAppendingPathComponent:asset.imageUID];
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
