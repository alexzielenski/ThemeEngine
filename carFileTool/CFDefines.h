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
    kCoreThemeDirectionHorizontal    = 1,
    kCoreThemeDirectionVertical      = 2,
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
    kCoreThemeAnimationFilmstrip                     = 50
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

#endif
