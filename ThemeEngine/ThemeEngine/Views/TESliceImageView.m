//
//  TESliceImageView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESliceImageView.h"

@interface TESliceImageView ()
@property (strong) CALayer *leftHandle;
@property (strong) CALayer *topHandle;
@property (strong) CALayer *bottomHandle;
@property (strong) CALayer *rightHandle;
- (void)_initialize;
- (void)_toggleDisplay;
- (void)addHandleWithName:(NSString *)name vertical:(BOOL)vertical;
@end

@implementation TESliceImageView
@dynamic leftHandlePosition, topHandlePosition, bottomHandlePosition, rightHandlePosition, sliceInsets;

#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize {
    self.layer = [CALayer layer];
    self.layer.delegate = self;
    self.wantsLayer = YES;
    
    [self addHandleWithName:@"leftHandle" vertical:YES];
    [self addHandleWithName:@"rightHandle" vertical:YES];
    [self addHandleWithName:@"topHandle" vertical:NO];
    [self addHandleWithName:@"bottomHandle" vertical:NO];
}

- (void)addHandleWithName:(NSString *)name vertical:(BOOL)vertical {
    CALayer *handle         = [CALayer layer];

    handle.name             = name;
    handle.borderWidth      = 1.0;
    handle.borderColor      = [[[NSColor blackColor] colorWithAlphaComponent:0.4] CGColor];
    handle.backgroundColor  = [[NSColor whiteColor] CGColor];

    if (vertical) {
        handle.frame = CGRectMake(0, 0, 3.0, self.bounds.size.height);
        handle.autoresizingMask = kCALayerHeightSizable | kCALayerMinYMargin | kCALayerMaxYMargin;
        handle.anchorPoint      = CGPointMake(0.5, 0.0);
        
    } else {
        handle.frame            = CGRectMake(0, 0, self.bounds.size.width, 3.0);
        handle.anchorPoint      = CGPointMake(0.0, 0.5);
        handle.autoresizingMask = kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMaxXMargin;

    }
    
    [self setValue:handle forKey:name];
    [self.layer addSublayer:handle];
}

#pragma mark - Display

- (void)_toggleDisplay {
    switch (self.renditionType) {
        case CoreThemeTypeThreePartHorizontal: {
            self.topHandle.hidden    = YES;
            self.bottomHandle.hidden = YES;
            self.leftHandle.hidden   = NO;
            self.rightHandle.hidden  = NO;
            
            break;
        }
        case CoreThemeTypeThreePartVertical: {
            self.topHandle.hidden    = NO;
            self.bottomHandle.hidden = NO;
            self.leftHandle.hidden   = YES;
            self.rightHandle.hidden  = YES;
            break;
        }
        case CoreThemeTypeNinePart: {
            self.topHandle.hidden    = NO;
            self.bottomHandle.hidden = NO;
            self.leftHandle.hidden   = NO;
            self.rightHandle.hidden  = NO;
            break;
        }
//        case CoreThemeTypeSixPart: {
//
//            break;
//        }
        default: {
            self.leftHandle.hidden   = YES;
            self.rightHandle.hidden  = YES;
            self.topHandle.hidden    = YES;
            self.bottomHandle.hidden = YES;
            break;
        }
    }
}

- (void)_generateInsetsFromSlices {
    if (self.renditionType == CoreThemeTypeThreePartVertical && self.sliceRects.count == 3) {
        CGRect topRect = [self.sliceRects[0] rectValue];
        CGRect bottomRect = [self.sliceRects[2] rectValue];
        
        self.sliceInsets = NSEdgeInsetsMake(topRect.size.height, 0, bottomRect.size.height, 0);
        
    } else if (self.renditionType == CoreThemeTypeNinePart && self.sliceRects.count == 9) {
        CGRect topLeftRect = [self.sliceRects[0] rectValue];
        CGRect bottomRightRect = [self.sliceRects[8] rectValue];
        
        self.sliceInsets = NSEdgeInsetsMake(topLeftRect.size.height, topLeftRect.size.width,
                                            bottomRightRect.size.height, bottomRightRect.size.width);
        
    } else if (self.renditionType == CoreThemeTypeThreePartHorizontal && self.sliceRects.count == 3) {
        CGRect leftRect = [self.sliceRects[0] rectValue];
        CGRect rightRect = [self.sliceRects[2] rectValue];
        
        self.sliceInsets = NSEdgeInsetsMake(0, leftRect.size.width, 0, rightRect.size.width);
    }
}

- (void)drawLayer:(nonnull CALayer *)layer inContext:(nonnull CGContextRef)ctx {
    if (layer == self.layer) {
        // draw our image sliced out
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithCGContext:ctx flipped:self.layer.geometryFlipped]];
        [self.image drawInRect:layer.bounds
                      fromRect:NSZeroRect
                     operation:NSCompositeSourceOver
                      fraction:1.0
                respectFlipped:YES
                         hints:nil];
        [NSGraphicsContext restoreGraphicsState];
    }
}

#pragma mark - Re-evaluation

- (void)setRenditionType:(CoreThemeType)renditionType {
    _renditionType = renditionType;
    [self _toggleDisplay];
    [self _generateInsetsFromSlices];
}

- (void)setSliceRects:(NSArray *)sliceRects {
    _sliceRects = sliceRects;
    [self _toggleDisplay];
    [self _generateInsetsFromSlices];
}

- (void)setImage:(NSBitmapImageRep *)image {
    if (!image) {
        // set placeholder image
    }
    
    _image = image;
    
    // Keep our frame exactly the same size as the image
    NSSize frameSize = NSMakeSize(image.pixelsHigh, image.pixelsWide);
    NSRect frame = self.frame;
    frame.size = frameSize;
    self.frame = frame;
    
    [self.layer setNeedsDisplay];
    [self.layer setNeedsLayout];
}

- (void)setEdgeInsets:(NSEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self.layer setNeedsDisplay];
}

#pragma mark - Properties

- (CGFloat)leftHandlePosition {
    return self.leftHandle.position.x;
}

- (void)setLeftHandlePosition:(CGFloat)leftHandlePosition {
    CGPoint pos              = self.leftHandle.position;
    pos.x                    = leftHandlePosition;
    self.leftHandle.position = pos;
}

- (CGFloat)topHandlePosition {
    return self.topHandle.position.y;
}

- (void)setTopHandlePosition:(CGFloat)topHandlePosition {
    CGPoint pos             = self.topHandle.position;
    pos.y                   = topHandlePosition;
    self.topHandle.position = pos;
}

- (CGFloat)rightHandlePosition {
    return CGRectGetMaxX(self.layer.bounds) - self.rightHandle.position.x;
}

- (void)setRightHandlePosition:(CGFloat)rightHandlePosition {
    CGPoint pos               = self.rightHandle.position;
    pos.x                     = CGRectGetMaxX(self.layer.bounds) - rightHandlePosition;
    self.rightHandle.position = pos;
}

- (CGFloat)bottomHandlePosition {
    return CGRectGetMaxY(self.layer.bounds) - self.bottomHandle.position.y;
}

- (void)setBottomHandlePosition:(CGFloat)bottomHandlePosition {
    CGPoint pos                = self.bottomHandle.position;
    pos.y                      = CGRectGetMaxY(self.layer.bounds) - bottomHandlePosition;
    self.bottomHandle.position = pos;
}

- (NSEdgeInsets)sliceInsets {
    return NSEdgeInsetsMake(self.topHandlePosition, self.leftHandlePosition, self.bottomHandlePosition, self.rightHandlePosition);
}

- (void)setSliceInsets:(NSEdgeInsets)edgeInsets {
    self.leftHandlePosition   = edgeInsets.left;
    self.topHandlePosition    = edgeInsets.top;
    self.bottomHandlePosition = edgeInsets.bottom;
    self.rightHandlePosition  = edgeInsets.right;
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingSliceInsets {
    return [NSSet setWithObjects:@"leftHandlePosition", @"topHandlePosition",
            @"rightHandlePosition", @"bottomHandlePosition", nil];
}

+ (NSSet *)keyPathsForValuesAffectingLeftHandlePosition {
    return [NSSet setWithObject:@"leftHandle.position"];
}

+ (NSSet *)keyPathsForValuesAffectingTopHandlePosition {
    return [NSSet setWithObject:@"topHandle.position"];
}

+ (NSSet *)keyPathsForValuesAffectingRightHandlePosition {
    return [NSSet setWithObject:@"rightHandle.position"];
}

+ (NSSet *)keyPathsForValuesAffectingBottomHandlePosition {
    return [NSSet setWithObject:@"bottomHandle.position"];
}

@end
