//
//  NSColor+Pasteboard.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// For our purposes we need only encode rgb values in a pasteboard so let's do that
@interface NSColor (Pasteboard)
+ (NSColor *)colorWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;
@end
