//
//  CFTDefines.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BEGINSTRINGIFY(PREFIX, DECAMEL) \
    NSUInteger prefixLength = [@(#PREFIX) length];\
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
    default: \
        return @"Unknown"; \
    }

NSString *decamelize(NSString *string) {
    return [[string stringByReplacingOccurrencesOfString:@"([a-z])([A-Z])"
                                              withString:@"$1 $2"
                                                 options:NSRegularExpressionSearch
                                                   range:NSMakeRange(0, string.length)] capitalizedString];
}

NSString *CoreThemeTypeToString(CoreThemeType value) {
    BEGINSTRINGIFY(kCoreThemeType, NO)
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
    STRINGIFY(kCoreThemeTypeColor)
    ENDSTRINGIFY
}

NSString *CFTEXifOrientationToString(CFTEXIFOrientation value) {
    BEGINSTRINGIFY(CFTEXIFOrientation, NO)
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
    BEGINSTRINGIFY(kCoreThemeLayer, NO)
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
    BEGINSTRINGIFY(kCoreThemeIdiom, NO)
    STRINGIFY(kCoreThemeIdiomUniversal)
    STRINGIFY(kCoreThemeIdiomPhone)
    STRINGIFY(kCoreThemeIdiomPad)
    STRINGIFY(kCoreThemeIdiomTV)
    STRINGIFY(kCoreThemeIdiomCar)
    STRINGIFY(kCoreThemeIdiom5)
    ENDSTRINGIFY
}

NSString *CoreThemeSizeToString(CoreThemeSize value) {
    BEGINSTRINGIFY(kCoreThemeSize, NO)
    STRINGIFY(kCoreThemeSizeRegular)
    STRINGIFY(kCoreThemeSizeSmall)
    STRINGIFY(kCoreThemeSizeMini)
    STRINGIFY(kCoreThemeSizeLarge)
    ENDSTRINGIFY
}

NSString *CoreThemeValueToString(CoreThemeValue value) {
    BEGINSTRINGIFY(kCoreThemeValue, NO)
    STRINGIFY(kCoreThemeValueOff)
    STRINGIFY(kCoreThemeValueOn)
    STRINGIFY(kCoreThemeValueMixed)
    ENDSTRINGIFY
}

NSString *CoreThemeDirectionToString(CoreThemeDirection value) {
    BEGINSTRINGIFY(kCoreThemeDirection, NO)
    STRINGIFY(kCoreThemeDirectionHorizontal)
    STRINGIFY(kCoreThemeDirectionVertical)
    STRINGIFY(kCoreThemeDirectionPointingUp)
    STRINGIFY(kCoreThemeDirectionPointingDown)
    STRINGIFY(kCoreThemeDirectionPointingLeft)
    STRINGIFY(kCoreThemeDirectionPointingRight)
    ENDSTRINGIFY
}

NSString *CoreThemeStateToString(CoreThemeState value) {
    BEGINSTRINGIFY(kCoreThemeState, NO)
    STRINGIFY(kCoreThemeStateNormal)
    STRINGIFY(kCoreThemeStateRollover)
    STRINGIFY(kCoreThemeStatePressed)
    STRINGIFY(kCoreThemeStateDisabled)
    case obsolete_kCoreThemeInactive:
        return @"obselete_inactive";
    ENDSTRINGIFY
    
}

NSString *CoreThemePresentationStateToString(CoreThemePresentationState value) {
    BEGINSTRINGIFY(kCoreThemePresentationState, NO)
    STRINGIFY(kCoreThemePresentationStateActive)
    STRINGIFY(kCoreThemePresentationStateInactive)
    STRINGIFY(kCoreThemePresentationStateActiveMain)
    ENDSTRINGIFY
}

NSString *CoreThemeLayoutToString(CoreThemeLayout value) {
    BEGINSTRINGIFY(kCoreTheme, NO)
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
    STRINGIFY(CUIEffectTypeGradient);
    ENDSTRINGIFY
}

BOOL CoreThemeTypeIsBitmap(CoreThemeType type) {
    switch (type) {
        case kCoreThemeTypeAnimation:
        case kCoreThemeTypeNinePart:
        case kCoreThemeTypeOnePart:
        case kCoreThemeTypeSixPart:
        case kCoreThemeTypeThreePartHorizontal:
        case kCoreThemeTypeThreePartVertical:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

NSString *CFTScaleToString(double scale) {
    if (scale == 1.0)
        return @"@1x";
    else if (scale == 2.0)
        return @"@2x";
    else if (scale == 3.0)
        return @"@3x";
    return [NSString stringWithFormat:@"@%.0fx", scale];
}

#import "CUICommonAssetStorage.h"
#import <dlfcn.h>

static CFIndex CFTRenditionKeyIndexForAttribute(struct _renditionkeytoken *dst, uint16_t attribute) {
    CFIndex idx = 0;
    struct _renditionkeytoken current = dst[0];
    do {
        if (current.identifier == attribute) {
            return idx;
        }
        
        idx++;
    } while (current.identifier != 0);
    return -1;
}

extern NSData *CFTConvertCARKeyToRenditionKey(NSData *src, CUICommonAssetStorage *storage) {
    unsigned short *bytes = (unsigned short *)src.bytes;
    if (storage.swapped) {
        [storage _swapRenditionKeyArray:bytes];
    }
    
    // CAR key is just flat list of short values in the order of the attributes from the keyformat
    // plus a trailing null
    struct _renditionkeytoken *dst = calloc(storage.keyFormat->numTokens + 1, sizeof(uint32_t));
    NSUInteger count = storage.keyFormat->numTokens;
    if (count != 0) {
        NSUInteger idx = 0;
        NSUInteger write_idx = 0;
        
        uint16_t *source = (uint16_t*)src.bytes;
        do {
            int attribute = storage.keyFormat->attributes[idx];
            int value = source[idx];
            
            if (value != 0) {
                struct _renditionkeytoken *current = &dst[write_idx];
                current->identifier = attribute;
                current->value = value;
                write_idx++;
            }
            
            idx++;
        } while (idx < count);
    }
    
    return [NSData dataWithBytesNoCopy:dst length:(storage.keyFormat->numTokens + 1) * sizeof(uint32_t) freeWhenDone:YES];
}

extern NSData *CFTConvertRenditionKeyToCARKey(NSData *src, CUICommonAssetStorage *storage) {
    uint16_t *dst = calloc(storage.keyFormat->numTokens, sizeof(uint16_t)); //! TODO: max out at 0x10 elements
    
    NSMutableData *copy = src.mutableCopy;
    // compatibility updates
    struct _renditionkeytoken *source = copy.mutableBytes;

    if (storage.storageVersion <= 4) {
        CFIndex idx = CFTRenditionKeyIndexForAttribute(source, CFTThemeAttributePresentationState);
        if (idx >= 0) {
            uint16_t value = *(uint16_t *)((void *)source + idx * sizeof(struct _renditionkeytoken) + 0x2);
            if (value == 0) {
                value = obsolete_kCoreThemeInactive;
            }
            
            *(uint16_t *)((void *)source + idx * sizeof(struct _renditionkeytoken) + 0x2) = value;
        }
        
    }
    
    // this is exported for some reason
    CUIFillCARKeyArrayForRenditionKey(dst, (struct _renditionkeytoken *)copy.bytes, storage.keyFormat);
    if (storage.swapped) {
        NSUInteger idx = storage.keyFormat->numTokens;
        do {
            *dst = CFSwapInt16(*dst);
            dst += 1;
            idx--;
        } while (idx != 0);
    }
    
    return [NSData dataWithBytesNoCopy:dst length:storage.keyFormat->numTokens * sizeof(uint16_t) freeWhenDone:YES];
}
