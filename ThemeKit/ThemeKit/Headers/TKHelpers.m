//
//  TKHelpers.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHelpers.h"
#import "TKRendition+Private.h"
#import "TKColorRendition.h"
#import <CoreUI/CUICommonAssetStorage.h>
#import "TKAssetStorage+Private.h"

void *TKIvarPointer(id self, const char *name) {
    Ivar ivar = class_getInstanceVariable(object_getClass(self), name);
    return ivar == NULL ? NULL : (__bridge void *)self + ivar_getOffset(ivar);
}

// Sanitizes the names of assets to not include any context information
// which is covered by the key
extern NSString *TKElementNameForRendition(TKRendition *rendition, TKAssetStorage *storage) {
    NSString *nam = [storage.storage renditionNameForKeyList:(struct renditionkeytoken *)rendition.renditionKey.keyList];
    if (nam != nil) {
        return nam;
    }
    
    static NSArray *replacements = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacements = @[
                         @"@2x",
                         @"@3x",
                         // Sizes
                         @"_Mini",
                         @"_Small",
                         @"_Regular",
                         @"_Large",
                         // Directions
                         @"_Horizontal",
                         @"_Vertical",
                         @"_PointingUp",
                         @"_PointingRight",
                         @"_PointingDown",
                         @"_PointingLeft",
                         // States
                         @"_Active",
                         @"_Inactive"
                         ];
    });
    NSMutableString *name = rendition.name.mutableCopy;
    for (NSString *token in replacements) {
        [name replaceOccurrencesOfString:token
                              withString:@""
                                 options:NSBackwardsSearch
                                   range:NSMakeRange(0, name.length)];
    }
    
    return [name stringByDeletingPathExtension];
}


#pragma mark - CAR Keys

static CFIndex TKRenditionKeyIndexForAttribute(struct renditionkeytoken *dst, uint16_t attribute) {
    CFIndex idx = 0;
    struct renditionkeytoken current = dst[0];
    do {
        if (current.identifier == attribute) {
            return idx;
        }
        
        idx++;
    } while (current.identifier != 0);
    return -1;
}

extern NSData *TKConvertCARKeyToRenditionKey(NSData *src, CUICommonAssetStorage *storage) {
    unsigned short *bytes = (unsigned short *)src.bytes;
    if (storage.swapped) {
        [storage _swapRenditionKeyArray:bytes];
    }
    
    // CAR key is just flat list of short values in the order of the attributes from the keyformat
    // plus a trailing null
    struct renditionkeytoken *dst = calloc(storage.keyFormat->num_identifiers + 1, sizeof(uint32_t));
    NSUInteger count = storage.keyFormat->num_identifiers;
    if (count != 0) {
        NSUInteger idx = 0;
        NSUInteger write_idx = 0;
        
        uint16_t *source = (uint16_t*)src.bytes;
        do {
            int attribute = storage.keyFormat->identifier_list[idx];
            int value = source[idx];
            
            if (value != 0) {
                struct renditionkeytoken *current = &dst[write_idx];
                current->identifier = attribute;
                current->value = value;
                write_idx++;
            }
            
            idx++;
        } while (idx < count);
    }
    
    return [NSData dataWithBytesNoCopy:dst length:(storage.keyFormat->num_identifiers + 1) * sizeof(uint32_t) freeWhenDone:YES];
}

extern NSData *TKConvertRenditionKeyToCARKey(NSData *src, CUICommonAssetStorage *storage) {
    uint16_t *dst = calloc(storage.keyFormat->num_identifiers, sizeof(uint16_t)); //! TODO: max out at 0x10 elements
    
    NSMutableData *copy = src.mutableCopy;
    // compatibility updates
    struct renditionkeytoken *source = copy.mutableBytes;
    
    if (storage.storageVersion <= 4) {
        CFIndex idx = TKRenditionKeyIndexForAttribute(source, TKThemeAttributePresentationState);
        if (idx >= 0) {
            uint16_t value = *(uint16_t *)((void *)source + idx * sizeof(struct renditionkeytoken) + 0x2);
            if (value == 0) {
                value = obsolete_CoreThemeStateInactive;
            }
            
            *(uint16_t *)((void *)source + idx * sizeof(struct renditionkeytoken) + 0x2) = value;
        }
        
    }
    
    // this is exported for some reason
    CUIFillCARKeyArrayForRenditionKey(dst, (struct renditionkeytoken *)copy.bytes, storage.keyFormat);
    if (storage.swapped) {
        NSUInteger idx = storage.keyFormat->num_identifiers;
        do {
            *dst = CFSwapInt16(*dst);
            dst += 1;
            idx--;
        } while (idx != 0);
    }
    
    return [NSData dataWithBytesNoCopy:dst length:storage.keyFormat->num_identifiers * sizeof(uint16_t) freeWhenDone:YES];
}

