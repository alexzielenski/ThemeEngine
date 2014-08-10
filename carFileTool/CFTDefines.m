//
//  CFTDefines.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BEGINSTRINGIFY(PREFIX) \
    NSUInteger prefixLength = [@(#PREFIX) length];\
    switch (value) {
#define STRINGIFY(NUM) \
    case NUM: \
        return [@(#NUM) substringFromIndex: prefixLength].lowercaseString;
#define ENDSTRINGIFY \
    default: \
        return @"Unknown"; \
    }

NSString *CoreThemeTypeToString(CoreThemeType value) {
    BEGINSTRINGIFY(kCoreThemeType)
    STRINGIFY(kCoreThemeTypeOnePart)
    STRINGIFY(kCoreThemeTypeThreePartHorizontal)
    STRINGIFY(kCoreThemeTypeThreePartVertical)
    STRINGIFY(kCoreThemeTypeNinePart)
    STRINGIFY(kCoreThemeTypeSixPart)
    STRINGIFY(kCoreThemeTypeGradient)
    STRINGIFY(kCoreThemeTypeEffect)
    STRINGIFY(kCoreThemeTypeAnimation)
    STRINGIFY(kCoreThemeTypePDF)
    STRINGIFY(kCoreThemeTypeRawData)
    STRINGIFY(kCoreThemeTypeRawPixel)
    ENDSTRINGIFY
}

NSString *CFTEXifOrientationToString(CFTEXIFOrientation value) {
    BEGINSTRINGIFY(CFTEXIFOrientation)
    STRINGIFY(CFTEXIFOrientationNormal)
    STRINGIFY(CFTEXIFOrientationReverse)
    STRINGIFY(CFTEXIFOrientationRotate180)
    STRINGIFY(CFTEXIFOrientationReverseRotate180)
    STRINGIFY(CFTEXIFOrientationReverseRotate90)
    STRINGIFY(CFTEXIFOrientationRotate90)
    STRINGIFY(CFTEXIFOrientationReverseRotate270)
    STRINGIFY(CFTEXIFOrientationRotate270)
    ENDSTRINGIFY
}

NSString *CoreThemeLayerToString(CoreThemeLayer value) {
    BEGINSTRINGIFY(kCoreThemeLayer)
    STRINGIFY(kCoreThemeLayerBase)
    STRINGIFY(kCoreThemeLayerHighlight)
    STRINGIFY(kCoreThemeLayerMask)
    STRINGIFY(kCoreThemeLayerPulse)
    STRINGIFY(kCoreThemeLayerHitMask)
    STRINGIFY(kCoreThemeLayerPatternOverlay)
    STRINGIFY(kCoreThemeLayerOutline)
    STRINGIFY(kCoreThemeLayerInterior)
    ENDSTRINGIFY
}

NSString *CoreThemeIdiomToString(CoreThemeIdiom value) {
    BEGINSTRINGIFY(kCoreThemeIdion)
    STRINGIFY(kCoreThemeIdiomUniversal)
    STRINGIFY(kCoreThemeIdiomPhone)
    STRINGIFY(kCoreThemeIdiomPad)
    STRINGIFY(kCoreThemeIdiomTV)
    STRINGIFY(kCoreThemeIdiomCar)
    STRINGIFY(kCoreThemeIdiom5)
    ENDSTRINGIFY
}

NSString *CoreThemeSizeToString(CoreThemeSize value) {
    BEGINSTRINGIFY(kCoreThemeSize)
    STRINGIFY(kCoreThemeSizeRegular)
    STRINGIFY(kCoreThemeSizeSmall)
    STRINGIFY(kCoreThemeSizeMini)
    STRINGIFY(kCoreThemeSizeLarge)
    ENDSTRINGIFY
}

NSString *CoreThemeValueToString(CoreThemeValue value) {
    BEGINSTRINGIFY(kCoreThemeValue)
    STRINGIFY(kCoreThemeValueOff)
    STRINGIFY(kCoreThemeValueOn)
    STRINGIFY(kCoreThemeValueMixed)
    ENDSTRINGIFY
}

NSString *CoreThemeDirectionToString(CoreThemeDirection value) {
    BEGINSTRINGIFY(kCoreThemeDirection)
    STRINGIFY(kCoreThemeDirectionHorizontal)
    STRINGIFY(kCoreThemeDirectionVertical)
    STRINGIFY(kCoreThemeDirectionPointingUp)
    STRINGIFY(kCoreThemeDirectionPointingDown)
    STRINGIFY(kCoreThemeDirectionPointingLeft)
    STRINGIFY(kCoreThemeDirectionPointingRight)
    ENDSTRINGIFY
}

NSString *CoreThemeStateToString(CoreThemeState value) {
    BEGINSTRINGIFY(kCoreThemeState)
    STRINGIFY(kCoreThemeStateNormal)
    STRINGIFY(kCoreThemeStateRollover)
    STRINGIFY(kCoreThemeStatePressed)
    STRINGIFY(kCoreThemeStateDisabled)
    case obsolete_kCoreThemeInactive:
        return @"obselete_inactive";
    ENDSTRINGIFY
    
}

NSString *CoreThemePresentationStateToString(CoreThemePresentationState value) {
    BEGINSTRINGIFY(kCoreThemePresentationState)
    STRINGIFY(kCoreThemePresentationStateActive)
    STRINGIFY(kCoreThemePresentationStateInactive)
    STRINGIFY(kCoreThemePresentationStateActiveMain)
    ENDSTRINGIFY
}

NSString *CoreThemeLayoutToString(CoreThemeLayout value) {
    BEGINSTRINGIFY(kCoreTheme)
    STRINGIFY(kCoreThemeOnePartFixedSize)
    STRINGIFY(kCoreThemeOnePartTile)
    STRINGIFY(kCoreThemeOnePartScale)
    STRINGIFY(kCoreThemeThreePartHTile)
    STRINGIFY(kCoreThemeThreePartHScale)
    STRINGIFY(kCoreThemeThreePartHUniform)
    STRINGIFY(kCoreThemeThreePartVTile)
    STRINGIFY(kCoreThemeThreePartVScale)
    STRINGIFY(kCoreThemeThreePartVUniform)
    STRINGIFY(kCoreThemeNinePartTile)
    STRINGIFY(kCoreThemeNinePartScale)
    STRINGIFY(kCoreThemeNinePartHorizontalUniformVerticalScale)
    STRINGIFY(kCoreThemeNinePartHorizontalScaleVerticalUniform)
    STRINGIFY(kCoreThemeManyPartLayoutUnknown)
    STRINGIFY(kCoreThemeAnimationFilmstrip)
    ENDSTRINGIFY
}

NSString *CFTScaleToString(double scale) {
    if (scale == 1.0)
        return @"@1x";
    else if (scale == 2.0)
        return @"@2x";
    return @"";
}
