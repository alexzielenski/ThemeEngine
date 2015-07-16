//
//  TKHelpers.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#ifndef TKHelpers_h
#define TKHelpers_h

#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#import "TKStructs.h"
#import "TKTypes.h"

#define TKKey(KEY) NSStringFromSelector(@selector(KEY))
#define TKClass(NAME) objc_getClass(#NAME)
#define TKIvar(OBJECT, TYPE, NAME) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wignored-attributes\"") \
        (*(__unsafe_unretained TYPE *)TKIvarPointer(OBJECT, #NAME)) \
    _Pragma("clang diagnostic pop")

// http://stackoverflow.com/questions/7792622/manual-retain-with-arc
#define AntiARCRetain(...) { void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing; }
#define AntiARCRelease(...) { void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil; }

#define WITH(OBJECT) { \
typeof(OBJECT) _ = OBJECT;

#define ENDWITH }

extern void *TKIvarPointer(id self, const char *name);

@class CUIRenditionKey;
@class TKRendition, CUICommonAssetStorage, TKAssetStorage;
extern NSString *TKElementNameForRendition(TKRendition *rendition, TKAssetStorage *storage);
extern NSData *TKConvertRenditionKeyToCARKey(NSData *src, CUICommonAssetStorage *storage);
extern NSData *TKConvertCARKeyToRenditionKey(NSData *src, CUICommonAssetStorage *storage);

extern CUIRenditionKey *CUIRenditionKeyFromDictionary(NSDictionary *dictionary);
extern NSDictionary *NSDictionaryFromCUIRenditionKey(CUIRenditionKey *key);

///Not Exported
extern void CUIFillCARKeyArrayForRenditionKey(uint16_t *dst, struct renditionkeytoken *src, struct renditionkeyfmt const *format);
extern void CUIFillRenditionKeyForCARKeyArray(struct renditionkeytoken *dst, uint16_t *src, struct renditionkeyfmt const *format);

extern OSErr CUIRenditionKeyCopy(struct renditionkeytoken *dst, struct renditionkeytoken *src, int maxCountIncludingZeroTerminator); // use 0x10

extern OSErr CUIRenditionKeySetValueForAttribute(struct renditionkeytoken *rendition, int, int, int);
extern CFIndex CUIRenditionKeyIndexForAttribute(struct renditionkeytoken *rendition, int attribute);
extern size_t CUIRenditionKeyTokenCount(struct renditionkeytoken *rendition);
extern BOOL CUIRenditionKeyHasIdentifier(struct renditionkeytoken *rendition, int, int);
extern int CUIRenditionKeyValueForAttribute(struct renditionkeytoken *rendition, int attribute);
extern int CUIRenditionKeyStandardize(int arg0, int arg1, int arg2);
extern CUIRenditionKey *CUIRenditionKeyFromKeySignature(NSString *signature, int *unk);
extern OSErr CUICopyKeySignature(char *buffer, size_t bufferSize, void *keyList, void *keyFormat);
extern int CUIRenditionKeyTokenIsBaseKeyOfKeyList(struct renditionkeytoken *arg0, int arg1);

extern NSEdgeInsets TKInsetsFromSliceRects(NSArray <NSValue *> *slices, CoreThemeType type);
extern NSArray <NSValue *> *TKSlicesFromInsets(NSEdgeInsets insets, NSSize imageSize, CoreThemeType type);

// I think it returns compression factor
// this is used to compress image data for car files
// Haven't been able to figure out pk_decompressData yet
extern int pk_compressData(void *bytes, unsigned int samples_per_pixel, unsigned int width, unsigned int height, unsigned int bytes_per_row, void *buffer, unsigned int buffer_length);
extern int pk_decompressData(void *inBytes, void *outBytes, struct slice slice, BOOL readonly, int bpr, BOOL arg7);

///
#endif /* TKHelpers_h */
