//
//  CFTGradient+Pasteboard.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradient+Pasteboard.h"

@implementation CFTGradient (Pasteboard)

#pragma mark - NSPasteboardReading

+ (instancetype)gradientFromPasteboard:(NSPasteboard *)pb {
    if ([pb canReadItemWithDataConformingToTypes:@[kCFTGradientPboardType]])
        return [[self alloc] initWithPasteboardPropertyList:[pb propertyListForType:kCFTGradientPboardType] ofType:kCFTGradientPboardType];
    return nil;
}

- (id)initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type {
    if (!propertyList)
        return nil;
    if (![type isEqualToString:kCFTGradientPboardType])
        return nil;
    
    NSArray *colors = propertyList[@"colors"];
    NSMutableArray *newColors = [NSMutableArray array];
    for (NSUInteger x = 0; x < colors.count; x++) {
        NSColor *color = [[NSColor alloc] initWithPasteboardPropertyList:colors[x] ofType:kCFTColorPboardType];
        newColors[x] = color;
    }
            
    if ((self = [self initWithColors:newColors
                      colorlocations:propertyList[@"colorLocations"]
                      colorMidpoints:propertyList[@"colorMidpoints"]
                           opacities:propertyList[@"opacityStops"]
                    opacityLocations:propertyList[@"opacityLocations"]
                    opacityMidpoints:propertyList[@"opacityMidPoints"]
                smoothingCoefficient:1.0
                           fillColor:[[NSColor alloc] initWithPasteboardPropertyList:propertyList[@"fillColor"] ofType:kCFTColorPboardType]
                               angle:[propertyList[@"angle"] doubleValue]
                              radial:[propertyList[@"radial"] boolValue]
                              dither:[propertyList[@"dithered"] boolValue]])) {
        
    }
    
    return self;
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsPropertyList;
}

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ kCFTGradientPboardType ];
}

#pragma mark - NSPasteboardWriting

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardWritingPromised;
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[ kCFTGradientPboardType ];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *colors = [NSMutableArray array];
    NSArray *myColors = self.colorStops ?: @[];
    for (NSUInteger x = 0; x < myColors.count; x++) {
        colors[x] = [myColors[x] pasteboardPropertyListForType:kCFTColorPboardType];
    }
    dictionary[@"colors"] = colors;
    dictionary[@"colorLocations"] = self.colorLocations ?: @[];
    dictionary[@"colorMidpoints"] = self.colorMidpoints ?: @[];
    dictionary[@"opacityStops"] = self.opacityStops ?: @[];
    dictionary[@"opacityMidpoints"] = self.opacityMidpoints ?: @[];
    dictionary[@"opacityLocations"] = self.opacityLocations ?: @[];
    dictionary[@"fillColor"] = [self.fillColor pasteboardPropertyListForType:kCFTColorPboardType];
    dictionary[@"angle"] = @(self.angle);
    dictionary[@"dithered"] = @(self.isDithered);
    dictionary[@"radial"] = @(self.isRadial);
    return dictionary;
}

@end
