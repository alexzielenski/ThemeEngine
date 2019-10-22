//
//  TKTypes.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTypes.h"

#define BEGINSTRINGIFY(PREFIX, DECAMEL) \
    NSString *prefix = @(#PREFIX); \
    NSUInteger prefixLength = [prefix length];\
    BOOL decamel = DECAMEL; \
    switch (value) {

#define STRINGIFY(NUM) \
        case NUM: { \
            NSString *num = [@(#NUM) substringFromIndex: prefixLength];\
            if (decamel) \
                return decamelize(num); \
            return num.lowercaseString; \
        }

#define ENDSTRINGIFY \
        default: {\
            NSLog(@"Unknown %@: %lu", prefix, (unsigned long)value);\
            return @"Unknown"; \
        }\
}

NSString *decamelize(NSString *string) {
    string = [string stringByDeletingPathExtension];
    return [[[string stringByReplacingOccurrencesOfString:@"(?<!^)(?=[A-Z])"
                                               withString:@" $1"
                                                  options:NSRegularExpressionSearch
                                                    range:NSMakeRange(0, string.length)] capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

NSString *CoreThemeTypeToString(CoreThemeType value) {
    BEGINSTRINGIFY(CoreThemeType, NO)
    STRINGIFY(CoreThemeTypeOnePart)
    STRINGIFY(CoreThemeTypeThreePartHorizontal)
    STRINGIFY(CoreThemeTypeThreePartVertical)
    STRINGIFY(CoreThemeTypeNinePart)
    STRINGIFY(CoreThemeTypeSixPart)
    STRINGIFY(CoreThemeTypeGradient)
    STRINGIFY(CoreThemeTypeEffect)
    STRINGIFY(CoreThemeTypeAnimation)
    STRINGIFY(CoreThemeTypePDF)
    STRINGIFY(CoreThemeTypeRawData)
    STRINGIFY(CoreThemeTypeColor)
    STRINGIFY(CoreThemeTypeAssetPack)
    ENDSTRINGIFY
}

NSString *TKEXIFOrientationToString(TKEXIFOrientation value) {
    BEGINSTRINGIFY(TKEXIFOrientation, NO)
    STRINGIFY(TKEXIFOrientationNotApplicable)
    STRINGIFY(TKEXIFOrientationNormal)
    STRINGIFY(TKEXIFOrientationReverse)
    STRINGIFY(TKEXIFOrientationRotate180)
    STRINGIFY(TKEXIFOrientationReverseRotate180)
    STRINGIFY(TKEXIFOrientationReverseRotate90)
    STRINGIFY(TKEXIFOrientationRotate90)
    STRINGIFY(TKEXIFOrientationReverseRotate270)
    STRINGIFY(TKEXIFOrientationRotate270)
    ENDSTRINGIFY
}

NSString *CoreThemeLayerToString(CoreThemeLayer value) {
    BEGINSTRINGIFY(CoreThemeLayer, NO)
    STRINGIFY(CoreThemeLayerBase)
    STRINGIFY(CoreThemeLayerHighlight)
    STRINGIFY(CoreThemeLayerMask)
    STRINGIFY(CoreThemeLayerPulse)
    STRINGIFY(CoreThemeLayerHitMask)
    STRINGIFY(CoreThemeLayerPatternOverlay)
    STRINGIFY(CoreThemeLayerOutline)
    STRINGIFY(CoreThemeLayerInterior)
    ENDSTRINGIFY
}

NSString *CoreThemeIdiomToString(CoreThemeIdiom value) {
    BEGINSTRINGIFY(CoreThemeIdiom, NO)
    STRINGIFY(CoreThemeIdiomUniversal)
    STRINGIFY(CoreThemeIdiomPhone)
    STRINGIFY(CoreThemeIdiomPad)
    STRINGIFY(CoreThemeIdiomTV)
    STRINGIFY(CoreThemeIdiomCar)
    STRINGIFY(CoreThemeIdiomWatch)
    STRINGIFY(CoreThemeIdiomMarketing)
    ENDSTRINGIFY
}

NSString *CoreThemeSizeToString(CoreThemeSize value) {
    BEGINSTRINGIFY(CoreThemeSize, NO)
    STRINGIFY(CoreThemeSizeRegular)
    STRINGIFY(CoreThemeSizeSmall)
    STRINGIFY(CoreThemeSizeMini)
    STRINGIFY(CoreThemeSizeLarge)
    ENDSTRINGIFY
}

NSString *CoreThemeValueToString(CoreThemeValue value) {
    BEGINSTRINGIFY(CoreThemeValue, NO)
    STRINGIFY(CoreThemeValueOff)
    STRINGIFY(CoreThemeValueOn)
    STRINGIFY(CoreThemeValueMixed)
    ENDSTRINGIFY
}

NSString *CoreThemeDirectionToString(CoreThemeDirection value) {
    BEGINSTRINGIFY(CoreThemeDirection, NO)
    STRINGIFY(CoreThemeDirectionHorizontal)
    STRINGIFY(CoreThemeDirectionVertical)
    STRINGIFY(CoreThemeDirectionPointingUp)
    STRINGIFY(CoreThemeDirectionPointingDown)
    STRINGIFY(CoreThemeDirectionPointingLeft)
    STRINGIFY(CoreThemeDirectionPointingRight)
    ENDSTRINGIFY
}

NSString *CoreThemeStateToString(CoreThemeState value) {
    BEGINSTRINGIFY(CoreThemeState, NO)
    STRINGIFY(CoreThemeStateNormal)
    STRINGIFY(CoreThemeStateRollover)
    STRINGIFY(CoreThemeStatePressed)
    STRINGIFY(CoreThemeStateDisabled)
    STRINGIFY(CoreThemeStateDeeplyPressed)
case obsolete_CoreThemeStateInactive:
    return @"obselete_inactive";
    ENDSTRINGIFY
    
}

NSString *CoreThemePresentationStateToString(CoreThemePresentationState value) {
    BEGINSTRINGIFY(CoreThemePresentationState, NO)
    STRINGIFY(CoreThemePresentationStateActive)
    STRINGIFY(CoreThemePresentationStateInactive)
    STRINGIFY(CoreThemePresentationStateActiveMain)
    ENDSTRINGIFY
}

NSString *CoreThemeLayoutToString(CoreThemeLayout value) {
    BEGINSTRINGIFY(CoreTheme, NO)
    STRINGIFY(CoreThemeLayoutOnePartFixedSize)
    STRINGIFY(CoreThemeLayoutOnePartTile)
    STRINGIFY(CoreThemeLayoutOnePartScale)
    STRINGIFY(CoreThemeLayoutThreePartHTile)
    STRINGIFY(CoreThemeLayoutThreePartHScale)
    STRINGIFY(CoreThemeLayoutThreePartHUniform)
    STRINGIFY(CoreThemeLayoutThreePartVTile)
    STRINGIFY(CoreThemeLayoutThreePartVScale)
    STRINGIFY(CoreThemeLayoutThreePartVUniform)
    STRINGIFY(CoreThemeLayoutNinePartTile)
    STRINGIFY(CoreThemeLayoutNinePartScale)
    STRINGIFY(CoreThemeLayoutNinePartHorizontalUniformVerticalScale)
    STRINGIFY(CoreThemeLayoutNinePartHorizontalScaleVerticalUniform)
    STRINGIFY(CoreThemeLayoutSixPart)
    STRINGIFY(CoreThemeLayoutAnimationFilmstrip)
    STRINGIFY(CoreThemeLayoutEffect)
    STRINGIFY(CoreThemeLayoutExternalLink)
    STRINGIFY(CoreThemeLayoutGradient)
    STRINGIFY(CoreThemeLayoutInternalLink)
    STRINGIFY(CoreThemeLayoutLayerStack)
    STRINGIFY(CoreThemeLayoutRawData)
    ENDSTRINGIFY
}

NSString *CUIEffectTypeToString(CUIEffectType value) {
    BEGINSTRINGIFY(CUIEffectType, YES)
    STRINGIFY(CUIEffectTypeBevelAndEmboss)
    STRINGIFY(CUIEffectTypeColorFill)
    STRINGIFY(CUIEffectTypeDropShadow)
    STRINGIFY(CUIEffectTypeExtraShadow)
    STRINGIFY(CUIEffectTypeInnerGlow)
    STRINGIFY(CUIEffectTypeInnerShadow)
    STRINGIFY(CUIEffectTypeOuterGlow)
    STRINGIFY(CUIEffectTypeOutputOpacity)
    STRINGIFY(CUIEffectTypeShapeOpacity)
    STRINGIFY(CUIEffectTypeGradientFill);
    ENDSTRINGIFY
}

extern NSString *CoreThemeTemplateRenderingModeToString(CoreThemeTemplateRenderingMode value) {
    BEGINSTRINGIFY(CoreThemeTemplateRenderingMode, NO)
    STRINGIFY(CoreThemeTemplateRenderingModeNone)
    STRINGIFY(CoreThemeTemplateRenderingModeTemplate)
    STRINGIFY(CoreThemeTemplateRenderingModeAutomatic)
    ENDSTRINGIFY
}

NSString *TKScaleToString(double scale) {
    if (scale == 1.0)
        return @"@1x";
    else if (scale == 2.0)
        return @"@2x";
    else if (scale == 3.0)
        return @"@3x";
    return [NSString stringWithFormat:@"@%.0fx", scale];
}

