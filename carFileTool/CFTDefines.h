//
//  CFTDefines.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

@import Foundation;

#ifndef carFileTool_CFTDefines_h
#define carFileTool_CFTDefines_h

// http://stackoverflow.com/questions/7792622/manual-retain-with-arc
#define AntiARCRetain(...) { void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing; }
#define AntiARCRelease(...) { void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil; }

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
    obsolete_kCoreThemeInactive = 3,
    kCoreThemeStateDisabled     = 4
};

typedef NS_ENUM(NSUInteger, CoreThemePresentationState) {
    kCoreThemePresentationStateActive     = 0,
    kCoreThemePresentationStateInactive   = 1,
    kCoreThemePresentationStateActiveMain = 2
};

typedef NS_ENUM(NSUInteger, CoreThemeLayout) {
    kCoreThemeGradient                               = 6,
    kCoreThemeEffect                                 = 7,
    kCoreThemeOnePartFixedSize                       = 10,
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
    kCoreThemeTypeRawPixel            = 1245774599,
    kCoreThemeTypeColor               = 1001
};

typedef NS_ENUM(NSUInteger, CFTEXIFOrientation) {
    CFTEXIFOrientationNormal           = 1,
    CFTEXIFOrientationReverse          = 2,
    CFTEXIFOrientationRotate180        = 3,
    CFTEXIFOrientationReverseRotate180 = 4,
    CFTEXIFOrientationReverseRotate90  = 5,
    CFTEXIFOrientationRotate90         = 6,
    CFTEXIFOrientationReverseRotate270 = 7,
    CFTEXIFOrientationRotate270        = 8
};

typedef NS_ENUM(NSUInteger, CFTThemeAttribute) {
    CFTThemeAttributeElement             = 1,
    CFTThemeAttributePart                = 2,
    CFTThemeAttributeSize                = 3,
    CFTThemeAttributeDirection           = 4,
    CFTThemeAttributeValue               = 6,
    CFTThemeAttributeDimension1          = 8,
    CFTThemeAttributeDimension2          = 9,
    CFTThemeAttributeState               = 10,
    CFTThemeAttributeLayer               = 11,
    CFTThemeAttributeScale               = 12,
    CFTThemeAttributePresentationState   = 14,
    CFTThemeAttributeIdiom               = 15,
    CFTThemeAttributeSubtype             = 16,
    CFTThemeAttributeIdentifier          = 17,
    CFTThemeAttributePreviousValue       = 18,
    CFTThemeAttributePreviousState       = 19,
    CFTThemeAttributeSizeClassHorizontal = 20,
    CFTThemeAttributeSizeClassVertical   = 21,
    CFTThemeAttributeMemoryClass         = 22,
    CFTThemeAttributeGraphicsClass       = 23
};

typedef NS_ENUM(unsigned int, CUIEffectType) {
    CUIEffectTypeColorFill      = 'Colr',
    CUIEffectTypeOutputOpacity  = 'Fade',
    CUIEffectTypeShapeOpacity   = 'SOpc',
    CUIEffectTypeBevelAndEmboss = 'Embs',
    CUIEffectTypeDropShadow     = 'Drop',
    CUIEffectTypeInnerGlow      = 'iGlw',
    CUIEffectTypeOuterGlow      = 'oGlw',
    CUIEffectTypeExtraShadow    = 'Xtra',
    CUIEffectTypeInnerShadow    = 'inSh',
    CUIEffectTypeGradient       = 'Grad'
};

typedef NS_ENUM(unsigned int, CUIEffectParameter) {
    CUIEffectParameterColor      = 0, // rgb
    CUIEffectParameterColor2     = 1, // rgb
    CUIEffectParameterOpacity    = 2, // float
    CUIEffectParameterOpacity2   = 3, // float
    CUIEffectParameterBlurRadius = 4, // int
    CUIEffectParameterOffset     = 5, // int
    CUIEffectParameterAngle      = 6, // int
    CUIEffectParameterBlendMode  = 7, // enum (CGBlendMode)
    CUIEffectParameterSoften     = 8, // int
    CUIEffectParameterSpread     = 9  // int
};

typedef NS_ENUM(unsigned int, CUIGradientStyle) {
    CUIGradientStyleLinear = 'Lnr ',
    CUIGradientStyleRadial = 'Rdl '
};

struct _rgbcolor {
    unsigned char r;
    unsigned char g;
    unsigned char b;
};

typedef union {
    double floatValue;
    unsigned long long intValue;
    struct _rgbcolor colorValue;
    short angleValue;
    unsigned int enumValue;
} CUIEffectValue;

typedef struct {
    CUIEffectType effectType;
    CUIEffectParameter effectParameter;
    CUIEffectValue effectValue;
} CUIEffectTuple;

void *kCFTUndoContext;
#define REGISTER_UNDO_PROPERTIES(PROPERTIES) \
    for (NSString *key in PROPERTIES) { \
        [self addObserver:self  \
               forKeyPath:key \
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew\
                  context:&kCFTUndoContext]; \
    }
#define HANDLE_UNDO \
    if (context == &kCFTUndoContext && self.undoManager) { \
        if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) { \
            if ([self respondsToSelector:@selector(updateChangeCount:)]) { \
               if (self.undoManager.isUndoing) { [self updateChangeCount:NSChangeUndone]; } \
               else if (self.undoManager.isUndoing) { [self updateChangeCount:NSChangeRedone]; } \
               else { [self updateChangeCount: NSChangeDone]; }\
            } \
        } else { \
            id oldValue = change[NSKeyValueChangeOldKey]; \
            id newValue = change[NSKeyValueChangeNewKey]; \
            if ([oldValue isKindOfClass: [NSNull class]]) { oldValue = nil; } \
            if ([newValue isKindOfClass: [NSNull class]]) { newValue = nil; } \
            if (![oldValue isEqual: newValue] && oldValue != newValue) { \
                [[self.undoManager prepareWithInvocationTarget: object] setValue: oldValue forKeyPath: keyPath]; \
                if (!self.undoManager.isUndoing) { [self.undoManager setActionName:[@"Change " stringByAppendingString: decamelize(keyPath)]]; } \
                    return; \
            }\
        } \
    }
#define UNREGISTER_UNDO_PROPERTIES(PROPERTIES) \
    for (NSString *key in PROPERTIES) { \
        [self removeObserver:self forKeyPath:key]; \
    }

extern NSString *decamelize(NSString *string);

extern NSString *CoreThemeTypeToString(CoreThemeType value);
extern NSString *CFTEXifOrientationToString(CFTEXIFOrientation value);
extern NSString *CoreThemeLayerToString(CoreThemeLayer value);
extern NSString *CoreThemeIdiomToString(CoreThemeIdiom value);
extern NSString *CoreThemeSizeToString(CoreThemeSize value);
extern NSString *CoreThemeValueToString(CoreThemeValue value);
extern NSString *CoreThemeDirectionToString(CoreThemeDirection value);
extern NSString *CoreThemeStateToString(CoreThemeState value);
extern NSString *CoreThemePresentationStateToString(CoreThemePresentationState value);
extern NSString *CoreThemeLayoutToString(CoreThemeLayout value);
extern NSString *CFTScaleToString(double scale);
extern NSString *CUIEffectTypeToString(CUIEffectType value);
#endif
