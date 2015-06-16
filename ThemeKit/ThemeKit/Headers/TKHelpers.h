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

#define TKKey(KEY) NSStringFromSelector(@selector(KEY))
#define TKClass(NAME) objc_getClass(#NAME)
#define TKIvar(OBJECT, TYPE, NAME) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wignored-attributes\"") \
        (*(__unsafe_unretained TYPE *)TKIvarPointer(OBJECT, #NAME)) \
    _Pragma("clang diagnostic pop")

extern void *TKIvarPointer(id self, const char *name);

@class TKRendition;
extern NSString *TKElementNameForRendition(TKRendition *rendition);

#endif /* TKHelpers_h */
