//
//  TKEffectPreset.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/TKEffect.h>

@interface TKEffectPreset : NSObject <NSCopying>
@property CGFloat scaleFactor;
+ (instancetype)effectPreset;

- (TKEffect *)effectWithType:(CUIEffectType)type;

- (void)addEffect:(TKEffect *)effect;
- (void)insertEffect:(TKEffect *)effect atIndex:(NSUInteger)index;

- (void)removeEffect:(TKEffect *)effect;
- (void)removeEffectAtIndex:(NSUInteger)index;

- (void)moveEffectAtIndex:(NSUInteger)index toIndex:(NSUInteger)destination;

// Just Aa used for demos
+ (NSBitmapImageRep *)shapeImage;
- (NSBitmapImageRep *)proccesedImage:(NSBitmapImageRep *)image;

@end

@interface TKEffectPreset (Properties)
@property (readonly, strong) NSArray *effects;
@end