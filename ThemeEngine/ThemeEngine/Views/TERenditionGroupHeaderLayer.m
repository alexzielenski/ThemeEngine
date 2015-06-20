//
//  TERenditionGroupHeaderLayer.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/20/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionGroupHeaderLayer.h"
#define kFontSize 14.0

@interface TERenditionGroupHeaderLayer ()
@end

@implementation TERenditionGroupHeaderLayer

- (id)init {
    if ((self = [super init])) {

        self.frame           = CGRectMake(0, 0, 100, 30);
        self.backgroundColor = [[[NSColor grayColor] colorWithAlphaComponent:0.2] CGColor];
        self.layoutManager = [CAConstraintLayoutManager layoutManager];
        
        self.textLayer       = [CATextLayer layer];
        self.badgeLayer      = [CALayer layer];
        self.badgeTextLayer  = [CATextLayer layer];
        self.badgeTextLayer.name = @"badgeText";
        self.badgeLayer.backgroundColor = [[[NSColor grayColor] colorWithAlphaComponent:0.3] CGColor];
        self.badgeTextLayer.fontSize = 12.0;
        self.badgeTextLayer.font = (__bridge CTFontRef)[NSFont boldSystemFontOfSize:12.0];
        
        self.badgeLayer.frame = CGRectMake(0, 0, 40, 20);
        self.badgeLayer.cornerRadius = 10.0;
        self.textLayer.fontSize = kFontSize;
        self.textLayer.autoresizingMask = kCALayerMinXMargin | kCALayerMinYMargin | kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMaxYMargin;
        self.badgeTextLayer.autoresizingMask = kCALayerMinXMargin | kCALayerMinYMargin | kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMaxYMargin;
        
//        self.badgeTextLayer.frame = self.badgeLayer.bounds;
        self.badgeTextLayer.position = CGPointZero;
        [self.badgeLayer addSublayer:self.badgeTextLayer];
        
        [self addSublayer:self.textLayer];
        [self addSublayer:self.badgeLayer];
        
        [self.textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                                 relativeTo:@"superlayer"
                                                                  attribute:kCAConstraintMidY]];
        [self.textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                                 relativeTo:@"superlayer"
                                                                  attribute:kCAConstraintMinX
                                                                     offset:40.0]];
        [self.badgeLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                                  relativeTo:@"superlayer"
                                                                   attribute:kCAConstraintMidY]];
        [self.badgeLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                                  relativeTo:@"superlayer"
                                                                   attribute:kCAConstraintMaxX
                                                                      offset:-20.0]];
        [self.badgeTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                                      relativeTo:@"superlayer"
                                                                       attribute:kCAConstraintMidX]];
        [self.badgeTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                                      relativeTo:@"superlayer"
                                                                       attribute:kCAConstraintMidY]];
    }
    
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    self.textLayer.foregroundColor = [[NSColor controlTextColor] CGColor];
    self.badgeTextLayer.foregroundColor = [[NSColor controlTextColor] CGColor];
    
    NSSize size = [self.badgeTextLayer.string sizeWithAttributes:@{
                                                                    NSFontAttributeName: (__bridge NSFont *)self.badgeTextLayer.font
                                                                    }];
    self.badgeLayer.frame = CGRectMake(self.badgeLayer.frame.origin.x, self.badgeLayer.frame.origin.y, size.width + 20, self.badgeLayer.frame.size.height);
    self.badgeTextLayer.frame = CGRectMake(NSMidX(self.badgeLayer.bounds) - size.width / 2, self.badgeTextLayer.frame.origin.y, size.width, size.height);
    [self.badgeLayer setNeedsLayout];
}


@end
