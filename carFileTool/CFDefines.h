//
//  CFDefines.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

@import Foundation;

#ifndef carFileTool_CFDefines_h
#define carFileTool_CFDefines_h

typedef NS_ENUM(NSUInteger, CoreThemeLayer) {
    kCoreThemeLayerBase             = 0,
    kCoreThemeLayerHighlight        = 1,
    kCoreThemeLayerMask             = 2,
    kCoreThemeLayerPulse            = 3,
    kCoreThemeLayerHitMask          = 4,
    kCoreThemeLayerPatternOverlay   = 5,
    kCoreThemeLayerOutline          = 6,
    kCoreThemeLayerInterior         = 7
};

typedef NS_ENUM(NSUInteger, CoreThemeIdiom) {
    kCoreThemeIdiomUniversal  = 0,
    kCoreThemeIdiomPhone      = 1,
    kCoreThemeIdiomPad        = 2,
    kCoreThemeIdiomTV         = 3,
    kCoreThemeIdiomCar        = 4,
    kCoreThemeIdiom5          = 5
};

typedef NS_ENUM(NSUInteger, CoreThemeSize) {
    kCoreThemeSizeRegular = 0,
    kCoreThemeSizeSmall   = 1,
    kCoreThemeSizeMini    = 2,
    kCoreThemeSizeLarge   = 3
};

typedef NS_ENUM(NSUInteger, CoreThemeValue) {
    kCoreThemeValueOff    = 0,
    kCoreThemeValueOn     = 1,
    kCoreThemeValueMixed  = 2
};

typedef NS_ENUM(NSUInteger, CoreThemeDirection) {
    kCoreThemeDirectionHorizontal    = 0,
    kCoreThemeDirectionVertical      = 1,
    kCoreThemeDirectionPointingUp    = 2,
    kCoreThemeDirectionPointingDown  = 3,
    kCoreThemeDirectionPointingLeft  = 4,
    kCoreThemeDirectionPointingRight = 5
};

typedef NS_ENUM(NSUInteger, CoreThemeState) {
    kCoreThemeStateNormal       = 0,
    kCoreThemeStateRollover     = 1,
    kCoreThemeStatePressed      = 2,
    obsolete_kCoreThemeInactive = 3
};

typedef NS_ENUM(NSUInteger, CoreThemePresentationState) {
    kCoreThemePresentationStateActive     = 0,
    kCoreThemePresentationStateInactive   = 1,
    kCoreThemePresentationStateActiveMain = 2
};

typedef NS_ENUM(NSUInteger, CoreThemeLayout) {
    kCoreThemeOnePartFixedSize                       = 10 ,
    kCoreThemeOnePartTile                            = 11,
    kCoreThemeOnePartScale                           = 12,
    kCoreThemeThreePartHTile                         = 20,
    kCoreThemeThreePartHScale                        = 21,
    kCoreThemeThreePartHUniform                      = 22,
    kCoreThemeThreePartVTile                         = 23,
    kCoreThemeThreePartVScale                        = 24,
    kCoreThemeThreePartVUniform                      = 25,
    kCoreThemeNinePartTile                           = 30,
    kCoreThemeNinePartScale                          = 31,
    kCoreThemeNinePartHorizontalUniformVerticalScale = 32,
    kCoreThemeNinePartHorizontalScaleVerticalUniform = 33,
    kCoreThemeManyPartLayoutUnknown                  = 40,
    kCoreThemeAnimationFilmstrip                     = 50,
};

typedef NS_ENUM(NSUInteger, CoreThemeType) {
    kCoreThemeTypeOnePart             = 0,
    kCoreThemeTypeThreePartHorizontal = 1,
    kCoreThemeTypeThreePartVertical   = 2,
    kCoreThemeTypeNinePart            = 3,
    kCoreThemeTypeSixPart             = 5,
    kCoreThemeTypeGradient            = 6,
    kCoreThemeTypeEffect              = 7,
    kCoreThemeTypeAnimation           = 8,
    kCoreThemeTypePDF                 = 9,
    kCoreThemeTypeRawData             = 1000,
    kCoreThemeTypeRawPixel            = 1245774599
};

typedef NS_ENUM(NSUInteger, CFEXIFOrientation) {
    CFEXIFOrientationNormal           = 1,
    CFEXIFOrientationReverse          = 2,
    CFEXIFOrientationRotate180        = 3,
    CFEXIFOrientationReverseRotate180 = 4,
    CFEXIFOrientationReverseRotate90  = 5,
    CFEXIFOrientationRotate90         = 6,
    CFEXIFOrientationReverseRotate270 = 7,
    CFEXIFOrientationRotate270        = 8
};

typedef NS_ENUM(NSUInteger, CFThemeAttribute) {
    CFThemeAttributeElement             = 1,
    CFThemeAttributePart                = 2,
    CFThemeAttributeSize                = 3,
    CFThemeAttributeDirection           = 4,
    CFThemeAttributeValue               = 6,
    CFThemeAttributeDimension1          = 8,
    CFThemeAttributeDimension2          = 9,
    CFThemeAttributeState               = 10,
    CFThemeAttributeLayer               = 11,
    CFThemeAttributeScale               = 12,
    CFThemeAttributePresentationState   = 14,
    CFThemeAttributeIdiom               = 15,
    CFThemeAttributeSubtype             = 16,
    CFThemeAttributeIdentifier          = 17,
    CFThemeAttributePreviousValue       = 18,
    CFThemeAttributePreviousState       = 19,
    CFThemeAttributeSizeClassHorizontal = 20,
    CFThemeAttributeSizeClassVertical   = 21,
    CFThemeAttributeMemoryClass         = 22,
    CFThemeAttributeGraphicsClass       = 23
};

extern NSString *CoreThemeTypeToString(CoreThemeType value);
extern NSString *CFEXifOrientationToString(CFEXIFOrientation value);
extern NSString *CoreThemeLayerToString(CoreThemeLayer value);
extern NSString *CoreThemeIdiomToString(CoreThemeIdiom value);
extern NSString *CoreThemeSizeToString(CoreThemeSize value);
extern NSString *CoreThemeValueToString(CoreThemeValue value);
extern NSString *CoreThemeDirectionToString(CoreThemeDirection value);
extern NSString *CoreThemeStateToString(CoreThemeState value);
extern NSString *CoreThemePresentationStateToString(CoreThemePresentationState value);
extern NSString *CoreThemeLayoutToString(CoreThemeLayout value);

#endif
