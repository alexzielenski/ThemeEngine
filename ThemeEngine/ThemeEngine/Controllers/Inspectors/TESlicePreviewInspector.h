//
//  TESlicePreviewInspector.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import "TESliceImageView.h"
@class TEInspectorController;
@interface TESlicePreviewInspector : TEInspectorDetailController
@property (weak) IBOutlet TESliceImageView *sliceImageView;

@property (readonly) BOOL canChangeLeftEdge;
@property (readonly) BOOL canChangeTopEdge;
@property (readonly) BOOL canChangeRightEdge;
@property (readonly) BOOL canChangeBottomEdge;
@end
