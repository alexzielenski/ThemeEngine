//
//  TKLayoutInformation.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKTypes.h>

@interface TKLayoutInformation : NSObject
// Slices
@property (strong) NSArray *sliceRects;

// Metrics
@property (strong) NSArray *metrics;

// We can't implement NSCoder with custom structs (such as CUIMetrics)
// So we have this instead for you
- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (NSDictionary *)dicitonaryRepresentation;

@end
