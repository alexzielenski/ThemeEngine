//
//  TKGradientRendition+Pasteboard.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/21/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKGradientRendition+Pasteboard.h"
#import "TKGradient+Pasteboard.h"

@implementation TKGradientRendition (Pasteboard)

+ (NSString *)pasteboardType {
    return TEGradientPBoardType;
}

- (BOOL)readFromPasteboardItem:(NSPasteboardItem *)item {

    if ([item availableTypeFromArray:@[ TEGradientPBoardType ]] != nil) {
        NSDictionary *pb = [item propertyListForType:TEGradientPBoardType];
        TKGradient *grad = [[TKGradient alloc] initWithPasteboardPropertyList:pb
                                                                       ofType:TEGradientPBoardType];
        if (grad != nil) {
            self.gradient = grad;
            return YES;
        }
    }
    
    return NO;
}

- (id)pasteboardPropertyListForType:(nonnull NSString *)type {
    if ([type isEqualToString:TEGradientPBoardType]) {
        return [self.gradient pasteboardPropertyListForType:type];
    }
    
    return [super pasteboardPropertyListForType:type];
}

@end
