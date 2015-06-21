//
//  TERenditionsController+Dragging.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController+Dragging.h"

#import "TKBitmapRendition+Pasteboard.h"

@implementation TERenditionsController (Dragging) 

- (void)bootstrapDragAndDrop {
    [self.renditionBrowser registerForDraggedTypes:@[ (__bridge NSString *)kUTTypeFileURL,
                                                      (__bridge NSString *)kUTTypeImage,
                                                      (__bridge NSString *)kUTTypePNG,
                                                      (__bridge NSString *)kUTTypeTIFF,
                                                      (__bridge NSString *)kUTTypeJPEG
                                                      ]];
}


- (NSUInteger)imageBrowser:(IKImageBrowserView *)aBrowser writeItemsAtIndexes:(NSIndexSet *)itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
    [pasteboard clearContents];
    [pasteboard writeObjects:[self.renditionsArrayController.arrangedObjects objectsAtIndexes:itemIndexes]];
    return itemIndexes.count;
}

#pragma mark - NSDraggingDestination

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
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
