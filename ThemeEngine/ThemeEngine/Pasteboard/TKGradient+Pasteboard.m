//
//  TKGradient+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradient+Pasteboard.h"

NSString *const TEGradientPBoardType = @"com.alexzielenski.themekit.model.gradient";
#define KEY(L) NSStringFromSelector(@selector(L))

@implementation TKGradient (Pasteboard)

- (id)initWithPasteboardPropertyList:(nonnull id)list ofType:(nonnull NSString *)type {
    if (![type isEqualToString:TEGradientPBoardType] ||
        !list)
        return nil;

    NSArray *colorStopPlists       = list[KEY(colorStops)];
    NSMutableArray *colorStops = [NSMutableArray array];
    for (NSDictionary *plist in colorStopPlists)
        [colorStops addObject:[TKGradientStop gradientStopWithPropertyList:plist ofType:TEGradientStopPBoardType]];
    
    NSArray *opacityStopPlists     = list[KEY(opacityStops)];
    NSMutableArray *opacityStops = [NSMutableArray array];
    for (NSDictionary *plist in opacityStopPlists)
        [opacityStops addObject:[TKGradientStop gradientStopWithPropertyList:plist ofType:TEGradientStopPBoardType]];
    
    
    NSArray *colorMidpoints   = list[KEY(colorMidpoints)];
    NSArray *opacityMidpoints = list[KEY(opacityMidpoints)];
    NSNumber *dithered        = list[KEY(isDithered)];
    NSNumber *fill            = list[KEY(fillCoefficient)];
    NSNumber *smooth          = list[KEY(smoothingCoefficient)];
    NSNumber *radial          = list[KEY(isRadial)];
    NSNumber *angle           = list[KEY(angle)];

    if ((self = [self initWithColorStops:colorStops
                            opacityStops:opacityStops
                  colorMidPointLocations:colorMidpoints
                opacityMidPointLocations:opacityMidpoints
                                  radial:radial.boolValue
                                   angle:angle.doubleValue
                    smoothingCoefficient:smooth.doubleValue
                         fillCoefficient:fill.doubleValue])) {
        self.dithered = dithered.boolValue;
    }
    
    return self;
}

+ (NSArray<NSString *> *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ [pasteboard availableTypeFromArray:@[ TEGradientPBoardType ]] ];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(nonnull NSString *)type pasteboard:(nonnull NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsPropertyList;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (NSArray<NSString *> *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ TEGradientPBoardType ];
}

- (nullable id)pasteboardPropertyListForType:(NSString *)type {
    if (![type isEqualToString:TEGradientPBoardType])
        return nil;
    
    NSMutableDictionary *property       = [NSMutableDictionary dictionary];
    property[KEY(colorStops)]           = [self.colorStops valueForKey:KEY(dictionaryRepresentation)];
    property[KEY(opacityStops)]         = [self.opacityStops valueForKey:KEY(dictionaryRepresentation)];
    property[KEY(colorMidpoints)]       = self.colorMidpoints;
    property[KEY(opacityMidpoints)]     = self.opacityMidpoints;
    property[KEY(isDithered)]           = @(self.isDithered);
    property[KEY(isRadial)]             = @(self.isRadial);
    property[KEY(fillCoefficient)]      = @(self.fillCoefficient);
    property[KEY(smoothingCoefficient)] = @(self.smoothingCoefficient);
    property[KEY(angle)]                = @(self.angle);
        
    return property;
}

@end
