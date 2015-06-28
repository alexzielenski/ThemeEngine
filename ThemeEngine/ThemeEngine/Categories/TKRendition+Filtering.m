//
//  TKRendition+Filtering.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRendition+Filtering.h"
#import <objc/runtime.h>
#import <ThemeKit/TKTypes.h>

@implementation TKRendition (Filtering)
@dynamic isColor, isEffect, isRawData;
@dynamic sizeString, typeString, stateString, layerString, scaleString, idiomString, valueString, presentationStateString, directionString;
- (BOOL)isColor {
    return [self isKindOfClass:[TKColorRendition class]];
}

- (BOOL)isEffect {
    return [self isKindOfClass:[TKEffectRendition class]];
}

- (BOOL)isRawData {
    return [self isMemberOfClass:[TKRawDataRendition class]];
}

- (BOOL)isBitmap {
    return [self isKindOfClass:[TKBitmapRendition class]];
}

- (NSSet *)keywords {
    NSSet *keywords = objc_getAssociatedObject(self, @selector(keywords));
    if (!keywords) {
        keywords = [NSSet setWithObjects:
                    self.name,
                    self.element.name,
                    self.typeString,
                    self.stateString,
                    self.scaleString,
                    self.layerString,
                    self.idiomString,
                    self.sizeString,
                    self.valueString,
                    self.presentationStateString,
                    self.directionString,
                    nil];
        keywords = [keywords setByAddingObjectsFromArray:[[[decamelize(self.name) lowercaseString]
                                                           stringByReplacingOccurrencesOfString:@"_" withString:@" "]
                                                          componentsSeparatedByString:@" "]];
        keywords = [keywords setByAddingObjectsFromArray:[[[decamelize(self.element.name) lowercaseString]
                                                           stringByReplacingOccurrencesOfString:@"_" withString:@" "]
                                                          componentsSeparatedByString:@" "]];
        objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return keywords;
}

#pragma mark - String Keys

- (NSString *)directionString {
    return CoreThemeDirectionToString(self.direction);
}

- (NSString *)presentationStateString {
    return CoreThemePresentationStateToString(self.presentationState);
}

- (NSString *)valueString {
    return CoreThemeValueToString(self.value);
}

- (NSString *)idiomString {
    return CoreThemeIdiomToString(self.idiom);
}

- (NSString *)layerString {
    return CoreThemeLayerToString(self.layer);
}

- (NSString *)sizeString {
    return CoreThemeSizeToString(self.size);
}

- (NSString *)typeString {
    return CoreThemeTypeToString(self.type);
}

- (NSString *)stateString {
    return CoreThemeStateToString(self.state);
}

- (NSString *)scaleString {
    return TKScaleToString(self.scale);
}

@end
