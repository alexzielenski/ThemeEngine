//
//  CHGradientView.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/11/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEGradientView.h"

@interface TEGradientView ()
- (void)_initialize;
@end

@implementation TEGradientView

- (id)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"angle"];
    [self removeObserver:self forKeyPath:@"gradient"];
    [self removeObserver:self forKeyPath:@"radial"];
}

void *kCHDirtyContext;
- (void)_initialize {
    [self addObserver:self forKeyPath:@"angle" options:0 context:&kCHDirtyContext];
    [self addObserver:self forKeyPath:@"gradient" options:0 context:&kCHDirtyContext];
    [self addObserver:self forKeyPath:@"radial" options:0 context:&kCHDirtyContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kCHDirtyContext)
        [self setNeedsDisplay:YES];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (self.isRadial) {
        [self.gradient drawInRect:self.bounds relativeCenterPosition:NSMakePoint(0, 0)];
    } else {
        [self.gradient drawInRect:self.bounds angle:self.angle];
    }
}

@end
