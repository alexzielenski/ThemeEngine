//
//  TKLayoutInformation.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKTypes.h>

@interface TKLayoutInformation : NSObject
@property (readonly, nonatomic) CoreThemeType layoutType;

// Slices
@property NSArray *sliceRects;

// Metrics
@property NSEdgeInsets edgeInsets;
@property NSSize imageSize;
@end
