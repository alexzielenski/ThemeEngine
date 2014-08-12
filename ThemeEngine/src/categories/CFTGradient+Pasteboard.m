//
//  CFTGradient+Pasteboard.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTGradient+Pasteboard.h"

@interface CFTGradient ()
@property (readwrite, strong) NSArray *colors;
@property (readwrite, strong) NSArray *locations;
@property (readwrite, strong) NSArray *midPoints;
@property (readwrite, assign) CGFloat angle;
@property (readwrite, assign, getter=isRadial) BOOL radial;
- (void)_initializeWithColors:(NSArray *)colors atLocations:(NSArray *)locations midPoints:(NSArray *)midPoints angle:(CGFloat)angle radial:(BOOL)radial;
@end


@implementation CFTGradient (Pasteboard)

#pragma mark - NSPasteboardReading

+ (instancetype)gradientFromPasteboard:(NSPasteboard *)pb {
    return [[self alloc] initWithPasteboardPropertyList:[pb propertyListForType:kCFTGradientPboardType] ofType:kCFTGradientPboardType];
}

- (id)initWithPasteboardPropertyList:(NSDictionary *)propertyList ofType:(NSString *)type {
    if ((self = [self init])) {
        NSArray *colors = propertyList[@"colors"];
        NSMutableArray *newColors = [NSMutableArray array];
        for (NSUInteger x = 0; x < colors.count; x++) {
            newColors[x] = [[NSColor alloc] initWithPasteboardPropertyList:colors[x] ofType:NSPasteboardTypeColor];
        }
        
        [self _initializeWithColors:newColors
                        atLocations:propertyList[@"locations"]
                          midPoints:propertyList[@"midPoints"]
                              angle:[propertyList[@"angle"] doubleValue]
                             radial:[propertyList[@"radial"] boolValue]];
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
    for (NSUInteger x = 0; x < self.colors.count; x++) {
        colors[x] = [self.colors[x] pasteboardPropertyListForType:NSPasteboardTypeColor];
    }
    dictionary[@"colors"] = colors;
    dictionary[@"locations"] = self.locations;
    dictionary[@"midPoints"] = self.midPoints;
    dictionary[@"angle"] = @(self.angle);
    dictionary[@"radial"] = @(self.isRadial);
    return dictionary;
}

@end
