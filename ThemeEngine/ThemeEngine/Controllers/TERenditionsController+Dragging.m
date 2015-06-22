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

- (IBAction)paste:(id)sender {
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
    NSLog(@"copied!");
    
    [pasteboard clearContents];
    [pasteboard writeObjects:[self.renditionsArrayController.arrangedObjects objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    // Don't allow users to drop in between cells
    if (self.renditionBrowser.dropOperation != IKImageBrowserDropOn)
        return NSDragOperationNone;
    
    // Ensure the drop target is valid
    NSUInteger idx = self.renditionBrowser.indexAtLocationOfDroppedItem;
    TKRendition <TERenditionPasteboardItem> *rendition = self.renditionsArrayController.arrangedObjects[idx];
    if (rendition) {
        NSPasteboard *pb = [sender draggingPasteboard];
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

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
    
}

@end
