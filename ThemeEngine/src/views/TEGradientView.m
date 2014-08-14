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
    [self removeObserver:self forKeyPath:@"gradient.angle"];
    [self removeObserver:self forKeyPath:@"gradient"];
    [self removeObserver:self forKeyPath:@"gradient.radial"];
}

void *kCHDirtyContext;
- (void)_initialize {
    [self addObserver:self forKeyPath:@"gradient.angle" options:0 context:&kCHDirtyContext];
    [self addObserver:self forKeyPath:@"gradient" options:0 context:&kCHDirtyContext];
    [self addObserver:self forKeyPath:@"gradient.radial" options:0 context:&kCHDirtyContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kCHDirtyContext)
        [self setNeedsDisplay:YES];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
    // Drawing code here.
    if (self.gradient.isRadial) {
        [self.gradient.themeGradient drawInRect:self.bounds relativeCenterPosition:NSMakePoint(NSMidX(self.bounds), NSMidY(self.bounds)) withContext:[[NSGraphicsContext currentContext] graphicsPort]];
    } else {
        [self.gradient.themeGradient
         drawInRect:self.bounds
         angle:self.gradient.angle
         withContext:[[NSGraphicsContext currentContext] graphicsPort]];
    }
}

@end
