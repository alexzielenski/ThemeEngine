//
//  NSColor+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "NSColor+Pasteboard.h"

@implementation NSColor (Pasteboard)

+ (NSColor *)colorWithDictionary:(NSDictionary<NSString *, NSNumber *> *)dictionary {
    return [NSColor colorWithHue:dictionary[@"h"].doubleValue
                      saturation:dictionary[@"s"].doubleValue
                      brightness:dictionary[@"b"].doubleValue
                           alpha:dictionary[@"a"].doubleValue];
}

- (NSDictionary *)dictionaryRepresentation {
    NSColor *rep = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    return @{ @"h": @(rep.hueComponent), @"s": @(rep.saturationComponent), @"b": @(rep.brightnessComponent), @"a": @(rep.alphaComponent) };
}

@end
