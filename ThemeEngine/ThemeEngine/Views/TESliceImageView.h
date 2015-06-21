//
//  TESliceImageView.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKBitmapRendition.h>
#import "TEBackgroundColorView.h"
@import Cocoa;

@interface TESliceImageView : NSView
@property (nonatomic, strong) IBOutlet TEBackgroundColorView *backgroundView;
@property (nonatomic, strong) NSBitmapImageRep *image;
@property (nonatomic, strong) NSArray *sliceRects;
@property BOOL hideHandles;
@property (nonatomic) BOOL drawsChecker;

// We support displaying
// CoreThemeTypeOnePart
// CoreThemeTypeThreePartHorizontal
// CoreThemeTypeThreePartVertical
// CoreThemeTypeNinePart
@property (nonatomic) CoreThemeType renditionType;

@property (nonatomic) NSEdgeInsets sliceInsets; // for slicing
@property (nonatomic) NSEdgeInsets edgeInsets; // for metrics

// KVO slicing handles
@property CGFloat leftHandlePosition;
@property CGFloat rightHandlePosition;
@property CGFloat topHandlePosition;
@property CGFloat bottomHandlePosition;
@end
