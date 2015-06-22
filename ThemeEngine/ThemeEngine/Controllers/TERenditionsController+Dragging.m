//
//  TERenditionsController+Dragging.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController+Dragging.h"
#import "TKRendition+Pasteboard.h"

@implementation TERenditionsController (Dragging)

- (BOOL)pasteFromPasteboard:(NSPasteboard *)pb toIndices:(NSIndexSet *)indices {
    NSArray <NSPasteboardItem *> *items = pb.pasteboardItems;
    NSUInteger count = items.count;
    
    __block BOOL success = YES;
    [indices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * __nonnull stop) {
        // mod them so we can just keep repeating the same pb in order
        NSUInteger itemIndex = idx % count;
        TKRendition <TERenditionPasteboardItem> *rendition =
        [self.renditionsArrayController.arrangedObjects objectAtIndex:idx];
        success &= [rendition readFromPasteboardItem:items[itemIndex]];
        *stop = !success;
    }];
        
    return success;
}

- (IBAction)paste:(id)sender {
    [self pasteFromPasteboard:[NSPasteboard generalPasteboard]
                    toIndices:self.renditionsArrayController.selectionIndexes];
}

- (void)bootstrapDragAndDrop {
    [self.renditionBrowser registerForDraggedTypes:@[ (__bridge NSString *)kUTTypeFileURL,
                                                      (__bridge NSString *)kUTTypeImage,
                                                      (__bridge NSString *)kUTTypePNG,
                                                      (__bridge NSString *)kUTTypeTIFF,
                                                      (__bridge NSString *)kUTTypeJPEG,
                                                      
                                                      // TKRendition classes
                                                      TKBitmapRendition.pasteboardType,
                                                      TKEffectRendition.pasteboardType,
                                                      TKColorRendition.pasteboardType,
                                                      TKGradientRendition.pasteboardType,
                                                      TKRawDataRendition.pasteboardType,
                                                      TKPDFRendition.pasteboardType
                                                      ]];
    self.renditionBrowser.allowsDroppingOnItems = YES;
}


- (NSUInteger)imageBrowser:(IKImageBrowserView *)aBrowser writeItemsAtIndexes:(NSIndexSet *)itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
    
    [pasteboard clearContents];
    [pasteboard writeObjects:[self.renditionsArrayController.arrangedObjects objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSPasteboard *pb = [sender draggingPasteboard];

    // Don't allow users to drop in between cells
    if (self.renditionBrowser.dropOperation != IKImageBrowserDropOn)
        return NSDragOperationNone;
    // Only accept one item in a drag. To use the pasteboard
    // to change multiple things at once, I suggest using copying and pasting
    // but with drags you can't be specific enough
    else if (pb.pasteboardItems.count != 1)
        return NSDragOperationNone;
    
    // Ensure the drop target is valid
    NSUInteger idx = self.renditionBrowser.indexAtLocationOfDroppedItem;
    TKRendition <TERenditionPasteboardItem> *rendition = self.renditionsArrayController.arrangedObjects[idx];
    if (rendition) {
        NSArray *types = rendition.readableTypes;
        NSString *type = [rendition.class pasteboardType];
        
        if ([sender draggingSource] != self.renditionBrowser) {
            // Make sure the item we are hovering over can handle the pasteboard content
            if ([pb availableTypeFromArray:types] != nil) {
                return NSDragOperationCopy;
            }
        } else if ([pb availableTypeFromArray:@[ type ] ] != nil) {
            // If this is a drop from within-app, make sure the type matches EXACTLY
            return NSDragOperationCopy;
        }

    }
    
    return NSDragOperationNone;
}

/* 
 To read only file URLs, use the NSPasteboardURLReadingFileURLsOnlyKey option in a dictionary provided to -readObjectsForClasses:options:.
 NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
 
 To read only URLs with particular content types, use the NSPasteboardURLReadingContentsConformToTypesKey option in a dictionary provided to -readObjectsForClasses:options:.  In the sample below, only URLs whose content types are images will be returned.
 NSDictionary *options = [NSDictionary dictionaryWithObject:[NSImage imageTypes] forKey:NSPasteboardURLReadingContentsConformToTypesKey];
 */

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    // Verify that the contents of the URL is actually what we are looking for
    NSPasteboard *pb = [sender draggingPasteboard];
    
    // Ensure the drop target is valid
    NSUInteger idx = self.renditionBrowser.indexAtLocationOfDroppedItem;
    TKRendition <TERenditionPasteboardItem> *rendition = self.renditionsArrayController.arrangedObjects[idx];
    
    if ([pb availableTypeFromArray:@[ (__bridge NSString *)kUTTypeURL, (__bridge NSString *)kUTTypeFileURL ]] != nil) {
        NSArray *readableTypes = [pb readObjectsForClasses:@[ [NSURL class] ]
                                                   options:@{
                                                             NSPasteboardURLReadingContentsConformToTypesKey: rendition.readableTypes
                                                             }];
        if (readableTypes.count == 0)
            return NO;
    }
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    return [self pasteFromPasteboard:[sender draggingPasteboard]
                           toIndices:[NSIndexSet indexSetWithIndex:self.renditionBrowser.indexAtLocationOfDroppedItem]];
}


@end
