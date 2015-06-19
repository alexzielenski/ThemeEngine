//
//  TKLayoutInformation.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKLayoutInformation.h"
#import "TKLayoutInformation+Private.h"
#import "TKStructs.h"

@implementation TKLayoutInformation

+ (instancetype)layoutInformationWithCSIData:(NSData *)csiData {
    return [[self alloc] initWithCSIData:csiData];
}

- (instancetype)initWithCSIData:(NSData *)csiData {
    if ((self = [self init])) {
        
        unsigned infoLength = 0;
        [csiData getBytes:&infoLength range:NSMakeRange(offsetof(struct csiheader, infolistLength), sizeof(infoLength))];
        
        unsigned sliceMagic = CSIInfoMagicSlices;
        NSRange sliceMagicLocation = [csiData rangeOfData:[NSData dataWithBytes:&sliceMagic
                                                                         length:sizeof(sliceMagic)]
                                                  options:0
                                                    range:NSMakeRange(sizeof(struct csiheader), infoLength)];
        
        if (sliceMagicLocation.location != NSNotFound) {
            unsigned int nslices = 0;
            [csiData getBytes:&nslices range:NSMakeRange(sliceMagicLocation.location + sizeof(unsigned int) * 2, sizeof(nslices))];
            
            NSMutableArray *slices = [NSMutableArray arrayWithCapacity:nslices];
            for (int idx = 0; idx < nslices; idx++) {
                struct {
                    unsigned int x;
                    unsigned int y;
                    unsigned int w;
                    unsigned int h;
                } sliceInts;
                
                [csiData getBytes:&sliceInts range:NSMakeRange(sliceMagicLocation.location + sizeof(sliceInts) * idx + sizeof(unsigned int) * 3,
                                                               sizeof(sliceInts))];
                [slices addObject:[NSValue valueWithRect:NSMakeRect(sliceInts.x, sliceInts.y, sliceInts.w, sliceInts.h)]];
            }
            
//            NSLog(@"%@", slices);
            
        }
        
        
    }
    
    return self;
}

@end
