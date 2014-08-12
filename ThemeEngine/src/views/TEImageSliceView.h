//
//  CHImageSliceView.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/9/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFTDefines.h"
#import <Quartz/Quartz.h>

@interface TEImageSliceView : IKImageView
@property (assign) CGFloat zoomFactor;
@property (assign, getter=isSlicing) BOOL slicing;
@property (assign) CoreThemeType themeType; // alows only onepart, threepartH, threepartV, ninepart, filmstrip, sixpart slice editing disabled for now
@property (strong) NSArray *sliceRects; // array of NSValue -rectValue
@property (assign) NSEdgeInsets edgeInsets;
@end
