//
//  TKGradientStop+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientStop+Pasteboard.h"
#import <objc/runtime.h>
#import "NSColor+Pasteboard.h"

NSString *const TEGradientStopPBoardType = @"com.alexzielenski.themekit.model.gradientstop";

static NSString *const kKeyClassName = @"className";

#define KEY(L) NSStringFromSelector(@selector(L))

@implementation TKGradientStop (Pasteboard)

+ (instancetype)gradientStopWithPropertyList:(nonnull NSDictionary *)list ofType:(nonnull NSString *)type {
    if (![type isEqualToString:TEGradientStopPBoardType])
        return nil;
    
    NSString *className = list[kKeyClassName];
    Class cls = NSClassFromString(className);
    if (cls != NULL) {
        return [[cls alloc] initWithPasteboardPropertyList:list ofType:type];
    }
    
    return nil;
}

- (id)initWithPasteboardPropertyList:(nonnull id)list ofType:(nonnull NSString *)type {
    if (![type isEqualToString:TEGradientStopPBoardType] ||
        !list)
        return nil;
    
    NSString *className = list[kKeyClassName];
    Class cls = NSClassFromString(className);
    // try to set our class at runtime
    object_setClass(self, cls);
    if ((self = [self init])) {
        self.location       = [list[KEY(location)] doubleValue];
        self.color          = [NSColor colorWithDictionary:list[KEY(color)]];
        self.opacity        = [list[KEY(opacity)] doubleValue];
        self.doubleStop     = [list[KEY(isDoubleStop)] boolValue];
        self.leadOutColor   = [NSColor colorWithDictionary:list[KEY(leadOutColor)]];
        self.leadOutOpacity = [list[KEY(leadOutOpacity)] doubleValue];
    }
    
    return self;
}

+ (NSArray<NSString *> *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ [pasteboard availableTypeFromArray:@[ TEGradientStopPBoardType ]] ];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(nonnull NSString *)type pasteboard:(nonnull NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsPropertyList;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (NSArray<NSString *> *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ TEGradientStopPBoardType ];
}

- (nullable id)pasteboardPropertyListForType:(NSString *)type {
    if (![type isEqualToString:TEGradientStopPBoardType])
        return nil;
    
    NSMutableDictionary *property = [NSMutableDictionary dictionary];
    property[kKeyClassName]       = self.className;
    property[KEY(color)]          = self.color.dictionaryRepresentation;
    property[KEY(leadOutColor)]   = self.leadOutColor.dictionaryRepresentation;
    property[KEY(opacity)]        = @(self.opacity);
    property[KEY(leadOutOpacity)] = @(self.leadOutOpacity);
    property[KEY(location)]       = @(self.location);
    property[KEY(isDoubleStop)]   = @(self.isDoubleStop);

    return property;
}

- (nonnull NSDictionary *)dictionaryRepresentation {
    return [self pasteboardPropertyListForType:TEGradientStopPBoardType];
}

@end
