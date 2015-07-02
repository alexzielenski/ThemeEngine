//
//  CFTEffectWrapper+Pasteboard.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTEffectWrapper+Pasteboard.h"
#import "NSColor+Pasteboard.h"

#define kTypeKey @"Type"
#define kParametersKey @"Parameters"

@implementation CFTEffectWrapper (Pasteboard)

#pragma mark - NSPasteboardReading

+ (instancetype)effectWrapperFromPasteboard:(NSPasteboard *)pasteboard {
    if ([pasteboard canReadItemWithDataConformingToTypes:@[kCFTEffectWrapperPboardType]])
        return [[self alloc] initWithPasteboardPropertyList:[pasteboard propertyListForType:kCFTEffectWrapperPboardType]
                                                     ofType:kCFTEffectWrapperPboardType];
    return nil;
}

- (id)initWithPasteboardPropertyList:(NSArray *)propertyList
                              ofType:(NSString *)type {
    if (![type isEqualToString:kCFTEffectWrapperPboardType]) {
        return nil;
    }
    if (!propertyList)
        return nil;
    
    if ((self = [self init])) {
        for (NSUInteger x = 0; x < propertyList.count; x++) {
            NSDictionary *effects = propertyList[x];
            CFTEffect *effect = [CFTEffect effectWithType:(CUIEffectType)[effects[kTypeKey] integerValue]];
            for (NSString *key in effects[kParametersKey]) {
                id value = effects[kParametersKey][key];
                if (![value isKindOfClass:[NSNumber class]]) {
                    [effect setColor:[[NSColor alloc] initWithPasteboardPropertyList:value ofType:kCFTColorPboardType] forParameter:(CUIEffectParameter)[key integerValue]];
                } else {
                    [effect setNumber:value forParameter:(CUIEffectParameter)[key integerValue]];
                }
            }
            
            [self addEffect:effect];
        }
    }
    return self;
}

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[kCFTEffectWrapperPboardType];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsPropertyList;
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[kCFTEffectWrapperPboardType];
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    NSMutableArray *property = [NSMutableArray array];
    
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        CFTEffect *effect = self.effects[x];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[kTypeKey] = [@(effect.type) stringValue];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        for (NSNumber *parameter in effect.parameters) {
            NSColor *value = effect.parameters[parameter];
            if ([value isKindOfClass:[NSColor class]]) {
                parameters[[parameter stringValue]] = [value pasteboardPropertyListForType:kCFTColorPboardType];
            } else
                parameters[[parameter stringValue]] = value;
        }
        
        dict[kParametersKey] = parameters;
        [property insertObject:dict atIndex:x];
    }
    return property;
}

@end
