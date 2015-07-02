//
//  NSColor+Pasteboard.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/13/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "NSColor+Pasteboard.h"
#import <objc/runtime.h>

@interface NSColor (Original)
- (id)_orig_initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type;
- (id)_orig_pasteboardPropertyListForType:(NSString *)type;
+ (NSArray *)_orig_readableTypesForPasteboard:(NSPasteboard *)pasteboard;
- (NSArray *)_orig_writableTypesForPasteboard:(NSPasteboard *)pasteboard;
@end

__attribute__((constructor)) static void NSColorPasteboard() {
    // Swizzle NSPasteboardWriting and NSPasteboardReading to add our own type
    // + (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard
    // - (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
    // - (id)initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type
    // - (id)pasteboardPropertyListForType:(NSString *)type
    Class self  = objc_getClass("NSColor");
    Class super = class_getSuperclass(self);
    
#define SWAP(CLASS, SEL1, SEL2, DEST) \
    { \
        Method m = class_getInstanceMethod(CLASS, @selector(SEL1)); \
        Method m2 = class_getInstanceMethod(CLASS, @selector(SEL2)); \
        class_addMethod(CLASS, @selector(DEST), method_getImplementation(m2), method_getTypeEncoding(m2));\
        m2 = class_getInstanceMethod(CLASS, @selector(DEST)); \
        method_exchangeImplementations(m, m2);\
    }

    SWAP(super, readableTypesForPasteboard:, _replaced_readableTypesForPasteboard:, _orig_readableTypesForPasteboard:);
    SWAP(self, initWithPasteboardPropertyList:ofType:, _replaced_initWithPasteboardPropertyList:ofType:, _orig_initWithPasteboardPropertyList:ofType:);
    SWAP(self, pasteboardPropertyListForType:, _replaced_pasteboardPropertyListForType:, _orig_pasteboardPropertyListForType:);
    SWAP(self, writableTypesForPasteboard:, _replaced_writableTypesForPasteboard:, _orig_writableTypesForPasteboard:);
}

@implementation NSColor (Pasteboard)

- (id)_replaced_initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type {
    if ([type isEqualToString:kCFTColorPboardType]) {
        [self release];
        
        return [[NSColor colorWithRed:[propertyList[@"red"] doubleValue]
                                green:[propertyList[@"green"] doubleValue]
                                 blue:[propertyList[@"blue"] doubleValue]
                                alpha:[propertyList[@"alpha"] doubleValue]] retain];
    }
    
    return [self _orig_initWithPasteboardPropertyList:propertyList ofType:type];
}

- (id)_replaced_pasteboardPropertyListForType:(NSString *)type {
    if ([type isEqualToString:kCFTColorPboardType]) {
        NSColor *rgbd = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        
        return @{ @"red": @(rgbd.redComponent), @"green": @(rgbd.greenComponent), @"blue": @(rgbd.blueComponent), @"alpha": @(rgbd.alphaComponent) };
    }
    
    return [self _orig_pasteboardPropertyListForType:type];
}

+ (NSArray *)_replaced_readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return [[self _orig_readableTypesForPasteboard:pasteboard] arrayByAddingObject:kCFTColorPboardType];
}

- (NSArray *)_replaced_writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return [[self _orig_writableTypesForPasteboard:pasteboard] arrayByAddingObject:kCFTColorPboardType];
}

@end
