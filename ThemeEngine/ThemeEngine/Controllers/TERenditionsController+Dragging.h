//
//  TERenditionsController+Dragging.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController.h"


@interface TERenditionsController ()
@end

@interface TERenditionsController (Dragging) <NSDraggingDestination>
- (void)bootstrapDragAndDrop;
- (BOOL)pasteFromPasteboard:(NSPasteboard *)pb toIndices:(NSIndexSet *)indices;
@end
