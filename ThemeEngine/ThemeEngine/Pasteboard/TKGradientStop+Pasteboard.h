//
//  TKGradientStop+Pasteboard.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/ThemeKit.h>

// Don't call initWithPropertyList:ofType:
// Call gradientStopWithPropertyList:ofType:
// It will choose the correct stop class for you
extern NSString * _Nonnull const TEGradientStopPBoardType;
@interface TKGradientStop (Pasteboard) <NSPasteboardReading, NSPasteboardWriting>

+ (nullable instancetype)gradientStopWithPropertyList:(nonnull NSDictionary *)list ofType:(nonnull NSString *)type;

// convenience method for calling propertylistoftype
- (nonnull NSDictionary *)dictionaryRepresentation;

@end
