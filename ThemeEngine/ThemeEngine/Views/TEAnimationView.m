//
//  TEAnimationView.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/15/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEAnimationView.h"
@import QuartzCore;

// Stolen from my mousecape source code
@interface TESpriteLayer : CALayer
@property (assign) NSUInteger frameCount;
@property (assign) NSUInteger sampleIndex;
@end

@interface TESpriteLayer ()
- (NSUInteger)currentSampleIndex;
@end

@implementation TESpriteLayer

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"sampleIndex"] || [key isEqualToString:@"frameCount"];
}

+ (id < CAAction >)defaultActionForKey:(NSString *)aKey; {
    return (id < CAAction >)[NSNull null];
}

- (NSUInteger)currentSampleIndex {
    return ((TESpriteLayer *)[self presentationLayer]).sampleIndex;
}

- (void)display {
    if ([self.delegate respondsToSelector:@selector(displayLayer:)]) {
        [self.delegate displayLayer:self];
        
        return;
    }
    
    NSUInteger currentSampleIndex = [self currentSampleIndex];
    if (!currentSampleIndex) {
        return;
    }
    
    CGSize sampleSize = NSMakeSize(1.0 / (self.frameCount ? self.frameCount : 1.0), 1.0);
    self.contentsRect = CGRectMake((currentSampleIndex - 1) * sampleSize.width, 0, sampleSize.width, sampleSize.height);
}



@end

@interface TEAnimationView ()
@property (weak) TESpriteLayer *spriteLayer;
- (void)_initialize;
- (void)_invalidateAnimation;
@end

@implementation TEAnimationView

- (id)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize {
    self.layer = [[TESpriteLayer alloc] init];
    self.wantsLayer = YES;
    self.layer.contentsGravity = kCAGravityCenter;
    self.layer.bounds = self.bounds;
    self.layer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable | kCALayerMinXMargin | kCALayerMinYMargin;
    self.layer.delegate = self;
    self.framesPerSecond = 23;
    
    self.spriteLayer = (TESpriteLayer *)self.layer;
    
    [self addObserver:self forKeyPath:@"image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"frameWidth" options:0 context:nil];
    [self addObserver:self forKeyPath:@"framesPerSecond" options:0 context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"image"];
    [self removeObserver:self forKeyPath:@"frameWidth"];
    [self removeObserver:self forKeyPath:@"framesPerSecond"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"] || [keyPath isEqualToString:@"frameWidth"] || [keyPath isEqualToString:@"framesPerSecond"]) {
        self.spriteLayer.contents = (__bridge id)self.image.CGImage;
        self.spriteLayer.frameCount = self.image.pixelsWide / self.frameWidth;
        [self _invalidateAnimation];
    }
}

- (void)_invalidateAnimation {
    [self.spriteLayer removeAllAnimations];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"sampleIndex"];
    anim.fromValue    = @(1);
    anim.toValue      = @(self.spriteLayer.frameCount + 1);
    anim.byValue      = @(1);
    anim.duration     = (CGFloat)self.spriteLayer.frameCount / self.framesPerSecond;
    anim.repeatCount  = self.spriteLayer.frameCount == 1 ? 0 : HUGE_VALF; // just keep repeating it
    anim.autoreverses = NO; // do 1, 2, 3, 4, 5, 1, 2, 3, 4, 5
    anim.removedOnCompletion = self.spriteLayer.frameCount == 1;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.spriteLayer addAnimation:anim forKey:@"sampleIndex"]; // start
    
    NSRect frame = self.frame;
    frame.size.width = self.frameWidth;
    frame.size.height = self.image.pixelsHigh;
    self.frame = frame;
}

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    return (id <CAAction>)[NSNull null];
}

@end
