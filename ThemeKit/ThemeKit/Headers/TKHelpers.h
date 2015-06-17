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

extern void *TKIvarPointer(id self, const char *name);

@class TKRendition;
extern NSString *TKElementNameForRendition(TKRendition *rendition);

#endif /* TKHelpers_h */
