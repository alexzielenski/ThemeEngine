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
                renditionMetric.edgeTR = CGSizeMake(mtr.a, mtr.b);
                renditionMetric.edgeBL = CGSizeMake(mtr.c, mtr.d);
                renditionMetric.imageSize = CGSizeMake(mtr.e, mtr.f);
                
                [metrics addObject:[NSValue valueWithBytes:&renditionMetric objCType:@encode(CUIMetrics)]];
            }
            self.metrics = metrics;
        }
    }
    
    return self;
}

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)d {
    if ((self = [self init])) {
        NSArray *slices = d[@"slices"];
        NSArray *metrics = d[@"metrics"];
        
        NSMutableArray *sliceRects = [NSMutableArray array];
        for (NSInteger x = 0; x < slices.count; x++) {
            [sliceRects addObject:[NSValue valueWithRect:NSRectFromString(slices[x])]];
        }
        
        self.sliceRects = sliceRects;
        
        sliceRects = [NSMutableArray array];
        for (NSInteger x = 0; x < metrics.count; x++) {
            CUIMetrics metric;
            NSDictionary *h = metrics[x];
            metric.imageSize = NSSizeFromString(h[@"imageSize"]);
            metric.edgeTR    = NSSizeFromString(h[@"edgeTR"]);
            metric.edgeBL    = NSSizeFromString(h[@"edgeBL"]);
            
            [sliceRects addObject:[NSValue valueWithBytes:&metric
                                                 objCType:@encode(CUIMetrics)]];
        }
        
        self.metrics = sliceRects;
    }
    
    return self;
}

- (NSDictionary *)dicitonaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *slices = [NSMutableArray array];
    for (NSInteger x = 0; x < self.sliceRects.count; x++) {
        NSValue *slice = self.sliceRects[x];
        [slices addObject:NSStringFromRect(slice.rectValue)];
    }
    
    NSMutableArray *metrics = [NSMutableArray array];
    for (NSInteger x = 0; x < self.metrics.count; x++) {
        CUIMetrics metric;
        NSValue *value = self.metrics[x];
        [value getValue:&metric];
        
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        d[@"imageSize"] = NSStringFromSize(metric.imageSize);
        d[@"edgeTR"] = NSStringFromSize(metric.edgeTR);
        d[@"edgeBL"] = NSStringFromSize(metric.edgeBL);
        
        [metrics addObject:d];
    }
    
    dict[@"metrics"] = metrics;
    dict[@"slices"]  = slices;
    
    return dict;
}

@end
