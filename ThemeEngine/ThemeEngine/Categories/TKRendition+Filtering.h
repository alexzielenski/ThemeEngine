//
//  TKRendition+Filtering.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/ThemeKit.h>

@interface TKRendition (Filtering)
@property (readonly) BOOL isColor;
@property (readonly) BOOL isEffect;
@property (readonly) BOOL isRawData;
@property (readonly) BOOL isBitmap;

@property (readonly) NSSet *keywords;

@property (readonly) NSString *sizeString;
@property (readonly) NSString *valueString;
@property (readonly) NSString *stateString;
@property (readonly) NSString *idiomString;
@property (readonly) NSString *directionString;
@property (readonly) NSString *presentationStateString;
@property (readonly) NSString *typeString;
@property (readonly) NSString *layerString;
@property (readonly) NSString *scaleString;
@end
