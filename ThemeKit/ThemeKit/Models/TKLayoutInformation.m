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
        
        
        // Parse CSI data for slice information
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
            
            self.sliceRects = slices;
        }
        
        
        // Get metric information
        NSMutableArray *metrics = [NSMutableArray array];
        unsigned metricMagic = CSIInfoMagicMetrics;
        NSRange metricMagicLocation = [csiData rangeOfData:
                                       [NSData dataWithBytes:&metricMagic length:sizeof(metricMagic)]
                                                   options:0
                                                     range:NSMakeRange(sizeof(struct csiheader), infoLength)];
        if (metricMagicLocation.location != NSNotFound) {
            unsigned int nmetrics = 0;
            [csiData getBytes:&nmetrics range:NSMakeRange(metricMagicLocation.location +
                                                          sizeof(unsigned int) * 2, sizeof(nmetrics))];
            
            NSMutableArray *metrics = [NSMutableArray arrayWithCapacity:nmetrics];
            for (int idx = 0; idx < nmetrics; idx++) {
                CUIMetrics renditionMetric;
                
                struct {
                    unsigned int a;
                    unsigned int b;
                    unsigned int c;
                    unsigned int d;
                    unsigned int e;
                    unsigned int f;
                } mtr;
                
                [csiData getBytes:&mtr range:NSMakeRange(metricMagicLocation.location + sizeof(mtr) * idx + sizeof(unsigned int) * 3, sizeof(mtr))];
                renditionMetric.edgeTR = CGSizeMake(mtr.c, mtr.b);
                renditionMetric.edgeBL = CGSizeMake(mtr.a, mtr.d);
                renditionMetric.imageSize = CGSizeMake(mtr.e, mtr.f);
                
                [metrics addObject:[NSValue valueWithBytes:&renditionMetric objCType:@encode(CUIMetrics)]];
            }
        }
        
        self.metrics = metrics;
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [self init])) {
        [self setValue:[coder decodeObjectForKey:TKKey(metrics)] forKey:TKKey(metrics)];
        [self setValue:[coder decodeObjectForKey:TKKey(sliceRects)] forKey:TKKey(sliceRects)];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.metrics forKey:TKKey(metrics)];
    [coder encodeObject:self.sliceRects forKey:TKKey(sliceRects)];
}

@end
