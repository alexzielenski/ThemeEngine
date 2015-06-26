//
//  TESplashButtonView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESplashButtonView.h"

@interface TESplashButtonView ()
@property (strong) NSTrackingArea *mouseOverArea;
@end

@implementation TESplashButtonView
@dynamic cornerRadius, actionName;

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    self.wantsLayer = YES;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    [self removeTrackingArea:self.mouseOverArea];
    
    self.mouseOverArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                      options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                                        owner:self
                                                     userInfo:nil];
    [self addTrackingArea:self.mouseOverArea];
}

- (void)mouseEntered:(nonnull NSEvent *)theEvent {
    if (!self.layer.backgroundColor)
        self.layer.backgroundColor = [self.highlightColor CGColor];
}

- (void)mouseExited:(nonnull NSEvent *)theEvent {
    if (self.layer.backgroundColor != [self.pressColor CGColor])
        self.layer.backgroundColor = nil;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(nonnull NSEvent *)theEvent {
    self.layer.backgroundColor = [self.pressColor CGColor];
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)mouseUp:(nonnull NSEvent *)theEvent {
    
    
    if (NSPointInRect([self convertPoint:theEvent.locationInWindow fromView:nil], self.bounds)) {
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
        }
        
        self.layer.backgroundColor = [self.highlightColor CGColor];
    } else {
        self.layer.backgroundColor = nil;
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (NSString *)actionName {
    return NSStringFromSelector(self.action);
}

- (void)setActionName:(NSString *)actionName {
    self.action = NSSelectorFromString(actionName);
}

@end

@implementation TESplashImageView

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

@end
