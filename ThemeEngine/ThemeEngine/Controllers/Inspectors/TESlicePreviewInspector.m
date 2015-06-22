//
//  TESlicePreviewInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TESlicePreviewInspector.h"
#import <ThemeKit/TKBitmapRendition.h>

@interface TESlicePreviewInspector ()
@property (strong) TKBitmapRendition *rendition;
@property (strong) TKLayoutInformation *layoutInformation;
@end

static const void *kTESlicePreviewSlicesUpdatedContext = &kTESlicePreviewSlicesUpdatedContext;

@implementation TESlicePreviewInspector
@dynamic canChangeBottomEdge, canChangeLeftEdge, canChangeRightEdge, canChangeTopEdge;
@dynamic layoutInformation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self bind:@"rendition"
      toObject:self
   withKeyPath:@"inspector.contentController.selection.self"
       options:nil];
}

- (void)viewDidAppear {
    [super viewDidAppear];

    // Fix strange bug where the first selection would never show
    if ([self.rendition isKindOfClass:[TKBitmapRendition class]]) {
        self.sliceImageView.image         = self.rendition.image;
        self.sliceImageView.renditionType = self.rendition.type;
        self.sliceImageView.sliceRects    = self.layoutInformation.sliceRects;
    }
}

- (void)awakeFromNib {
    if (self.sliceImageView) {
        
        [self.sliceImageView bind:@"image"
                         toObject:self
                      withKeyPath:@"rendition.image"
                          options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];
        
        [self.sliceImageView bind:@"renditionType"
                         toObject:self
                      withKeyPath:@"rendition.type"
                          options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];
        
        [self.sliceImageView bind:@"sliceRects"
                         toObject:self
                      withKeyPath:@"layoutInformation.sliceRects"
                          options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];
        
        [self.sliceImageView addObserver:self
                              forKeyPath:@"sliceRects"
                                 options:0
                                 context:&kTESlicePreviewSlicesUpdatedContext];
    }
}

- (void)dealloc {
    [self unbind:@"rendition"];
    [self.sliceImageView unbind:@"image"];
    [self.sliceImageView unbind:@"renditionType"];
    [self.sliceImageView unbind:@"sliceRects"];
    [self.sliceImageView removeObserver:self forKeyPath:@"sliceRects" context:&kTESlicePreviewSlicesUpdatedContext];
    [self.sliceImageView removeObserver:self forKeyPath:@"sliceRects" context:&kTESlicePreviewSlicesUpdatedContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &kTESlicePreviewSlicesUpdatedContext && [self.rendition isKindOfClass:[TKBitmapRendition class]]) {
        self.rendition.layoutInformation.sliceRects = self.sliceImageView.sliceRects;
    }
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    if (objects.count != 1)
        return NSStackViewVisibilityPriorityNotVisible;
    
    TKBitmapRendition *first = objects.firstObject;
    if ([first isKindOfClass:[TKBitmapRendition class]]
        && first.type != CoreThemeTypeSixPart
        && first.type != CoreThemeTypeAnimation
        && first.type != CoreThemeTypeAssetPack) {
        return NSStackViewVisibilityPriorityMustHold;
    }
    
    return NSStackViewVisibilityPriorityNotVisible;
}

- (TKLayoutInformation *)layoutInformation {
    if ([self.rendition isKindOfClass:[TKBitmapRendition class]])
        return self.rendition.layoutInformation;
    return nil;
}

- (void)setLayoutInformation:(TKLayoutInformation *)layoutInformation {
    if ([self.rendition isKindOfClass:[TKBitmapRendition class]])
        self.rendition.layoutInformation = layoutInformation;
}

+ (NSSet *)keyPathsForValuesAffectingLayoutInformation {
    return [NSSet setWithObject:@"rendition.layoutInformation"];
}

#pragma mark - Hiding Editors

- (BOOL)canChangeLeftEdge {
    return self.rendition.type == CoreThemeTypeNinePart ||
    self.rendition.type == CoreThemeTypeThreePartHorizontal;
}

- (BOOL)canChangeTopEdge {
    return self.rendition.type == CoreThemeTypeNinePart ||
    self.rendition.type == CoreThemeTypeThreePartVertical;
}

- (BOOL)canChangeRightEdge {
    return self.canChangeLeftEdge;
}

- (BOOL)canChangeBottomEdge {
    return self.canChangeTopEdge;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasPrefix:@"canChange"]) {
        return [NSSet setWithObject:@"rendition.type"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}
@end
