//
//  TKTypes.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#ifndef TKTypes_h
#define TKTypes_h

/**
 *  @enum CoreThemeLayer enum
 *  @abstract Indicates which layer this asset is part of for its UI element
 */
typedef NS_ENUM(NSUInteger, CoreThemeLayer){
    /**
     *  The asset is the base layout to which every other layer is stacked on.
     * This is the one you probably want to use.
     */
    CoreThemeLayerBase             = 0,
    /**
     *  The asset should be layered on top of the base in a highlighted state.
     */
    CoreThemeLayerHighlight        = 1,
    /**
     *  This asset masks the entire element. All alpha in this mask will be clipped off of the element.
     */
    CoreThemeLayerMask             = 2,
    /**
     *  This asset represents a pulse. (Mostly unused nowadays, but think of the NSButton pulsing)
     */
    CoreThemeLayerPulse            = 3,
    /**
     *  Unknown
     */
    CoreThemeLayerHitMask          = 4,
    /**
     *  This asset should be mostly alpha and should contain a pattern that repeats over the entire element
     */
    CoreThemeLayerPatternOverlay   = 5,
    /**
     *  Unknown
     */
    CoreThemeLayerOutline          = 6,
    /**
     *  Unknown
     */
    CoreThemeLayerInterior         = 7
};

typedef NS_ENUM(NSUInteger, CoreThemeIdiom) {
    CoreThemeIdiomUniversal  = 0,
    CoreThemeIdiomPhone      = 1,
    CoreThemeIdiomPad        = 2,
    CoreThemeIdiomTV         = 3,
    CoreThemeIdiomCar        = 4,
    CoreThemeIdiomWatch      = 5,
    CoreThemeIdiomMarketing  = 6
};

typedef NS_ENUM(NSUInteger, CoreThemeSizeClass) {
    CoreThemeSizeClassUnspecified = 0,
    CoreThemeSizeClassCompact     = 1,
    CoreThemeSizeClassRegular     = 2
};

typedef NS_ENUM(NSInteger, CoreThemeTemplateRenderingMode) {
    CoreThemeTemplateRenderingModeNone      = 0,
    CoreThemeTemplateRenderingModeTemplate  = 1,
    CoreThemeTemplateRenderingModeAutomatic = 2
};

typedef NS_ENUM(NSUInteger, CoreThemeSize) {
    CoreThemeSizeRegular = 0,
    CoreThemeSizeSmall   = 1,
    CoreThemeSizeMini    = 2,
    CoreThemeSizeLarge   = 3
};

typedef NS_ENUM(NSUInteger, CoreThemeValue) {
    CoreThemeValueOff    = 0,
    CoreThemeValueOn     = 1,
    CoreThemeValueMixed  = 2
};

typedef NS_ENUM(NSUInteger, CoreThemeDirection) {
    CoreThemeDirectionHorizontal    = 0,
    CoreThemeDirectionVertical      = 1,
    CoreThemeDirectionPointingUp    = 2,
    CoreThemeDirectionPointingDown  = 3,
    CoreThemeDirectionPointingLeft  = 4,
    CoreThemeDirectionPointingRight = 5
};

typedef NS_ENUM(NSUInteger, CoreThemeState) {
    CoreThemeStateNormal            = 0,
    CoreThemeStateRollover          = 1,
    CoreThemeStatePressed           = 2,
    obsolete_CoreThemeStateInactive = 3,
    CoreThemeStateDisabled          = 4,
    CoreThemeStateDeeplyPressed     = 5
};

typedef NS_ENUM(NSUInteger, CoreThemePresentationState) {
    CoreThemePresentationStateActive     = 0,
    CoreThemePresentationStateInactive   = 1,
    CoreThemePresentationStateActiveMain = 2
};

// There is something similar between CoreThemeTypeAndCoreThemeLayout
typedef NS_ENUM(uint32_t, CoreThemeLayout) {
    CoreThemeLayoutGradient                               = 6,
    CoreThemeLayoutEffect                                 = 7,
    CoreThemeLayoutOnePartFixedSize                       = 10,
    CoreThemeLayoutOnePartTile                            = 11,
    CoreThemeLayoutOnePartScale                           = 12,
    CoreThemeLayoutThreePartHTile                         = 20,
    CoreThemeLayoutThreePartHScale                        = 21,
    CoreThemeLayoutThreePartHUniform                      = 22,
    CoreThemeLayoutThreePartVTile                         = 23,
    CoreThemeLayoutThreePartVScale                        = 24,
    CoreThemeLayoutThreePartVUniform                      = 25,
    CoreThemeLayoutNinePartTile                           = 30,
    CoreThemeLayoutNinePartScale                          = 31,
    CoreThemeLayoutNinePartHorizontalUniformVerticalScale = 32,
    CoreThemeLayoutNinePartHorizontalScaleVerticalUniform = 33,
    CoreThemeLayoutSixPart                                = 40,
    CoreThemeLayoutAnimationFilmstrip                     = 50,
    
    // Non-images > 999:
    CoreThemeLayoutRawData                                = 1000,
    
    // new in 10.11
    CoreThemeLayoutExternalLink        = 1001,
    // Layer stacks being encoded CALayers/.caar
    CoreThemeLayoutLayerStack          = 1002,
    CoreThemeLayoutInternalLink        = 1003,
    CoreThemeLayoutAssetPack           = 1004,
};

typedef NS_ENUM(uint32_t, CSIPixelFormat) {
    CSIPixelFormatARGB    = 'ARGB',
    CSIPixelFormatPDF     = 'PDF ',
    // Used in raw data and layer stack
    CSIPixelFormatRawData = 'DATA',
    CSIPixelFormatJPEG    = 'JPEG'
};

//! Should really be layout
typedef NS_ENUM(NSUInteger, CoreThemeType) {
    CoreThemeTypeOnePart             = 0,
    CoreThemeTypeThreePartHorizontal = 1,
    CoreThemeTypeThreePartVertical   = 2,
    CoreThemeTypeNinePart            = 3,
    CoreThemeTypeSixPart             = 5,
    CoreThemeTypeGradient            = 6,
    CoreThemeTypeEffect              = 7,
    CoreThemeTypeAnimation           = 8,
    CoreThemeTypePDF                 = 9,
    
    CoreThemeTypeRawData             = 1000, // used for layer stacks
    
    CoreThemeTypeColor               = -1001, // This is a fake type
    CoreThemeTypeAssetPack           = 1004  // ZZZPackedAssets-1.0.0/2.0.0 I've seen subtype 10
};

typedef NS_ENUM(NSUInteger, TKEXIFOrientation) {
    TKEXIFOrientationNotApplicable    = 0,
    TKEXIFOrientationNormal           = 1,
    TKEXIFOrientationReverse          = 2,
    TKEXIFOrientationRotate180        = 3,
    TKEXIFOrientationReverseRotate180 = 4,
    TKEXIFOrientationReverseRotate90  = 5,
    TKEXIFOrientationRotate90         = 6,
    TKEXIFOrientationReverseRotate270 = 7,
    TKEXIFOrientationRotate270        = 8
};

typedef NS_ENUM(uint16_t, TKThemeAttribute) {
    TKThemeAttributeElement             = 1,
    TKThemeAttributePart                = 2,
    TKThemeAttributeSize                = 3,
    TKThemeAttributeDirection           = 4,
    TKThemeAttributeValue               = 6,
    TKThemeAttributeDimension1          = 8,
    TKThemeAttributeDimension2          = 9,
    TKThemeAttributeState               = 10,
    TKThemeAttributeLayer               = 11,
    TKThemeAttributeScale               = 12,
    TKThemeAttributePresentationState   = 14,
    TKThemeAttributeIdiom               = 15,
    TKThemeAttributeSubtype             = 16,
    TKThemeAttributeIdentifier          = 17,
    TKThemeAttributePreviousValue       = 18,
    TKThemeAttributePreviousState       = 19,
    TKThemeAttributeSizeClassHorizontal = 20,
    TKThemeAttributeSizeClassVertical   = 21,
    TKThemeAttributeMemoryClass         = 22,
    TKThemeAttributeGraphicsClass       = 23
};

typedef NS_ENUM(uint32_t, CUIEffectType) {
    // Comments include mandatory values
    // though there are optional ones, some of which are included in (parenthesis)
    CUIEffectTypeColorFill      = 'Colr', // color, opacity (blend mode)
    CUIEffectTypeOutputOpacity  = 'Fade', // opacity
    CUIEffectTypeShapeOpacity   = 'SOpc', // opacity
    CUIEffectTypeBevelAndEmboss = 'Embs', // color, coolr2, opacity, opacity 2, blur radius, soften
    CUIEffectTypeDropShadow     = 'Drop', // color, opacity, blur radius, offset, angle (spread)
    CUIEffectTypeInnerGlow      = 'iGlw', // color, opacity, blur radius (blend mode)
    CUIEffectTypeOuterGlow      = 'oGlw', // color, opacity, blur radius (spread)
    CUIEffectTypeExtraShadow    = 'Xtra', // color, opacity, blur radius, offset, angle (spread)
    CUIEffectTypeInnerShadow    = 'inSh', // color, opacity, blur radius, offset, angle (spread, blend mode)
    CUIEffectTypeGradientFill   = 'Grad' // color, color2, opacity
};

typedef NS_ENUM(unsigned int, CUIEffectParameter) {
    CUIEffectParameterColor      = 0, // rgb
    CUIEffectParameterColor2     = 1, // rgb
    CUIEffectParameterOpacity    = 2, // float
    CUIEffectParameterOpacity2   = 3, // float, "Shadow Opacity"
    CUIEffectParameterBlurRadius = 4, // int
    CUIEffectParameterOffset     = 5, // int
    CUIEffectParameterAngle      = 6, // int
    CUIEffectParameterBlendMode  = 7, // enum (CGBlendMode)
    CUIEffectParameterSoften     = 8, // int
    CUIEffectParameterSpread     = 9  // int
};

typedef NS_ENUM(uint32_t, CUIGradientStyle) {
    CUIGradientStyleLinear = 'Lnr ',
    CUIGradientStyleRadial = 'Rdl '
};

typedef union {
    double floatValue;
    unsigned long long intValue;
    struct _rgbcolor {
        unsigned char r;
        unsigned char g;
        unsigned char b;
    } colorValue;
    short angleValue;
    unsigned int enumValue;
} CUIEffectValue;

typedef struct {
    CUIEffectType effectType;
    CUIEffectParameter effectParameter;
    CUIEffectValue effectValue;
} CUIEffectTuple;

extern NSString *decamelize(NSString *string);
extern NSString *CoreThemeTypeToString(CoreThemeType value);
extern NSString *TKEXIFOrientationToString(TKEXIFOrientation value);
extern NSString *CoreThemeLayerToString(CoreThemeLayer value);
extern NSString *CoreThemeIdiomToString(CoreThemeIdiom value);
extern NSString *CoreThemeSizeToString(CoreThemeSize value);
extern NSString *CoreThemeValueToString(CoreThemeValue value);
extern NSString *CoreThemeDirectionToString(CoreThemeDirection value);
extern NSString *CoreThemeStateToString(CoreThemeState value);
extern NSString *CoreThemePresentationStateToString(CoreThemePresentationState value);
extern NSString *CoreThemeLayoutToString(CoreThemeLayout value);
extern NSString *TKScaleToString(double scale);
extern NSString *CUIEffectTypeToString(CUIEffectType value);
extern NSString *CoreThemeTemplateRenderingModeToString(CoreThemeTemplateRenderingMode mode);
#endif /* TKTypes_h */
