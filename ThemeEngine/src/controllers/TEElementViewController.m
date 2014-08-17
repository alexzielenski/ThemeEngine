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
#import "NSColor+Pasteboard.h"
#import <CommonCrypto/CommonDigest.h>
#import "TEPhotoshopController.h"
#import "CFTElementStore.h"

// Stolen from facebook
static NSString *md5(NSString *input) {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@interface TEElementViewController ()
@property (strong) NSPredicate *filterPredicate;
@property (strong) TEAssetDetailViewController *detailPopoverViewController;
- (void)_initialize;
- (void)_filterPredicates;
- (BOOL)_pasteFromPasteboard:(NSPasteboard *)pb atIndices:(NSIndexSet *)indices;
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
    [self.assetsArrayController removeObserver:self forKeyPath:@"arrangedObjects.previewImage"];
    [self.imageBrowserView unbind:NSContentBinding];
}

- (void)_initialize {
    [self addObserver:self forKeyPath:@"elements" options:0 context:nil];
}

static void *kTEDirtyContext;

- (void)viewDidLoad {
    self.imageBrowserView.constrainsToOriginalSize = YES;
    self.imageBrowserView.contentResizingMask = NSViewHeightSizable;
    self.imageBrowserView.canControlQuickLookPanel = YES;
    self.imageBrowserView.allowsDroppingOnItems = YES;
    
    self.assetsArrayController.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"key.themeElement" ascending:NO],
                                                    [NSSortDescriptor sortDescriptorWithKey:@"key.themePart" ascending:NO],
                                                    [NSSortDescriptor sortDescriptorWithKey:@"key.themeState" ascending:NO],
                                                    [NSSortDescriptor sortDescriptorWithKey:@"key.themePresentationState" ascending:NO],
                                                    [NSSortDescriptor sortDescriptorWithKey:@"key.themeSize" ascending:NO]];
    [self.assetsArrayController addObserver:self forKeyPath:@"arrangedObjects.previewImage" options:0 context:&kTEDirtyContext];
    [self.imageBrowserView bind:NSContentBinding toObject:self.assetsArrayController withKeyPath:@"arrangedObjects" options:nil];
    self.imageBrowserView.draggingDestinationDelegate = self;
    self.imageBrowserView.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"elements"]) {
        
        __weak TEElementViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.detailPopoverViewController.presentingViewController)
                [weakSelf dismissViewController:self.detailPopoverViewController];
        });
        
        [self _filterPredicates];
    } else if ([keyPath isEqualToString:@"previewImage"]) {
        [self.imageBrowserView reloadData];
    } else if (context == &kTEDirtyContext) {
        
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
        
        self.filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:terms];
    } else {
        self.filterPredicate = nil;
    }
}

#pragma mark - Actions

- (IBAction)paste:(id)sender {
    [self _pasteFromPasteboard:[NSPasteboard generalPasteboard] atIndices:self.assetsArrayController.selectionIndexes];
}

- (IBAction)sendToPhotoshop:(id)sender {
    NSIndexSet *indices = [self.assetsArrayController.selectionIndexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return [self.assetsArrayController.arrangedObjects[idx] image] != nil;
    }];
    
    [[TEPhotoshopController sharedPhotoshopController] sendImagesToPhotoshop:[self.assetsArrayController.arrangedObjects valueForKeyPath:@"image"]
                                                                  withLayout:indices
                                                                  dimensions:NSMakeSize(self.imageBrowserView.numberOfColumns, self.imageBrowserView.numberOfRows)];
}

- (IBAction)removeColor:(id)sender {
    NSIndexSet *indices = [self.assetsArrayController.selectionIndexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return [(CFTAsset *)self.assetsArrayController.arrangedObjects[idx] type] == kCoreThemeTypeColor;
    }];
    
    for (CFTAsset *color in [self.assetsArrayController.arrangedObjects objectsAtIndexes:indices]) {
        [color.element.store removeAsset: color];
    }
}

- (IBAction)receiveFromPhotoshop:(id)sender {
    NSArray *received = [TEPhotoshopController.sharedPhotoshopController receiveImagesFromPhotoshop];
    
    __block NSUInteger currentRepIndex = 0;
    [self.assetsArrayController.selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSBitmapImageRep *rep = rep = received[currentRepIndex % received.count];
        
        CFTAsset *asset = self.assetsArrayController.arrangedObjects[idx];
        if (CoreThemeTypeIsBitmap(asset.type)) {
            asset.image = rep;
            
            currentRepIndex++;
        }
    }];
}

#pragma mark - IKImageBrowserView

- (NSUInteger)imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
    [pasteboard clearContents];
    [pasteboard writeObjects:[self.assetsArrayController.arrangedObjects objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}

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
    
    self.detailPopoverViewController.asset = self.assetsArrayController.arrangedObjects[index];
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSUInteger idx = [self.imageBrowserView indexAtLocationOfDroppedItem];
    if (idx >= [self.assetsArrayController.arrangedObjects count])
        return NSDragOperationNone;
    
    CoreThemeType type = [(CFTAsset *)self.assetsArrayController.arrangedObjects[idx] type];
    //!TODO Check for individual items on the pasteboard per type of the hovered asset
    if ([NSImage canInitWithPasteboard:sender.draggingPasteboard] && self.imageBrowserView.dropOperation == IKImageBrowserDropOn &&
        (type <= kCoreThemeTypeSixPart || type == kCoreThemeTypeAnimation || type == kCoreThemeTypePDF || type == kCoreThemeTypeColor) && sender.numberOfValidItemsForDrop == 1)
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
    return [self _pasteFromPasteboard:sender.draggingPasteboard atIndices:[NSIndexSet indexSetWithIndex:idx]];
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
    [self.imageBrowserView reloadData];
}

- (BOOL)_pasteFromPasteboard:(NSPasteboard *)pb atIndices:(NSIndexSet *)indices {
    NSUInteger *indexes = malloc(sizeof(NSUInteger) * indices.count);
    [indices getIndexes:indexes maxCount:indices.count inIndexRange:NULL];
    
    for (NSUInteger x = 0; x < MAX(pb.pasteboardItems.count, indices.count); x++) {
        NSPasteboardItem *item = nil;
        CFTAsset *asset = nil;
        
        if (x >= indices.count)
            break;
        else {
            item = pb.pasteboardItems[x % pb.pasteboardItems.count];
        }
        
        asset = self.assetsArrayController.arrangedObjects[indexes[x]];
        
        BOOL bad = NO;
        
        if ([item availableTypeFromArray:@[kCFTColorPboardType]]) {
            if (asset.type == kCoreThemeTypeColor)
                asset.color = [[NSColor alloc] initWithPasteboardPropertyList:[item propertyListForType:kCFTColorPboardType] ofType:kCFTColorPboardType];
            else
                bad = YES;
        }
        
        if ([item availableTypeFromArray:@[kCFTEffectWrapperPboardType]]) {
            if (asset.type == kCoreThemeTypeEffect)
                asset.effectPreset = [[CFTEffectWrapper alloc] initWithPasteboardPropertyList:[item propertyListForType:kCFTEffectWrapperPboardType] ofType:kCFTEffectWrapperPboardType];
            else
                bad = YES;
        }
        
        if ([item availableTypeFromArray:@[kCFTGradientPboardType]]) {
            if (asset.type == kCoreThemeTypeGradient)
                asset.gradient = [[CFTGradient alloc] initWithPasteboardPropertyList:[item propertyListForType:kCFTGradientPboardType] ofType:kCFTGradientPboardType];
            else
                bad = YES;
        }
        
        if ([item availableTypeFromArray:@[NSPasteboardTypePNG]]) {
            if (asset.type <= kCoreThemeTypeSixPart || asset.type == kCoreThemeTypeAnimation) {
                asset.image = [[NSBitmapImageRep alloc] initWithData:[item dataForType:NSPasteboardTypePNG]];;
            }// else
//                bad = YES;
        }
        
        if ([item availableTypeFromArray:@[NSPasteboardTypePDF]]) {
            if (asset.type == kCoreThemeTypePDF)
                asset.pdfData = [item dataForType:NSPasteboardTypePDF];
//            else
//                bad = YES;
        }
     
        if (bad) {
            NSRunAlertPanel(@"Invalid type", @"The destination doesn't support this value type. (e.g. you copied a gradient to an image)", @"Sorry", nil, nil);
            return NO;
        }
    }
    
    free(indexes);
    
    return YES;
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
    NSString *tempPath = [[[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] stringByAppendingPathComponent:md5(asset.imageUID)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
