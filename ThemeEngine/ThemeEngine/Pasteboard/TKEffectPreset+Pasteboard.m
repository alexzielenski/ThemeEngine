//
//  TKEffectPreset+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKEffectPreset+Pasteboard.h"
#import "NSColor+Pasteboard.h"

static NSString *const kTypeKey       = @"Type";
static NSString *const kParametersKey = @"Parameters";

NSString *const TKEffectPresetPBoardType = @"com.alexzielenski.themekit.model.effectpreset";

@implementation TKEffectPreset (Pasteboard)

#pragma mark - NSPasteboardReading

+ (instancetype)effectWrapperFromPasteboard:(NSPasteboard *)pasteboard {
    if ([pasteboard canReadItemWithDataConformingToTypes:@[ TKEffectPresetPBoardType ]])
        return [[self alloc] initWithPasteboardPropertyList:[pasteboard propertyListForType:TKEffectPresetPBoardType]
                                                     ofType:TKEffectPresetPBoardType];
    return nil;
}

- (id)initWithPasteboardPropertyList:(NSArray *)propertyList
                              ofType:(NSString *)type {
    if (![type isEqualToString:TKEffectPresetPBoardType] ||
        !propertyList) {
        return nil;
    }
    
    if ((self = [self init])) {
        for (NSUInteger x = 0; x < propertyList.count; x++) {
            NSDictionary *effects = propertyList[x];
            TKEffect *effect = [TKEffect effectWithType:(CUIEffectType)[effects[kTypeKey] integerValue]];
            
            for (NSString *key in effects[kParametersKey]) {
                id value = effects[kParametersKey][key];
                if (![value isKindOfClass:[NSNumber class]]) {
                    [effect setColor:[NSColor colorWithDictionary:value]
                        forParameter:(CUIEffectParameter)[key integerValue]];
                    
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
    return @[ TKEffectPresetPBoardType ];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsPropertyList;
}

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ TKEffectPresetPBoardType ];
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    if (![type isEqualToString:TKEffectPresetPBoardType])
        return nil;
    
    NSMutableArray *property = [NSMutableArray array];
    
    for (NSUInteger x = 0; x < self.effects.count; x++) {
        TKEffect *effect = self.effects[x];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[kTypeKey] = [@(effect.type) stringValue];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        for (NSNumber *parameter in effect.parameters) {
            NSColor *value = effect.parameters[parameter];
            
            if ([value isKindOfClass:[NSColor class]]) {
                parameters[[parameter stringValue]] = [value dictionaryRepresentation];
                
            } else
                parameters[[parameter stringValue]] = value;
        }
        
        dict[kParametersKey] = parameters;
        [property insertObject:dict atIndex:x];
    }
    
    return property;
}

@end
