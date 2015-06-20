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

@implementation TESlicePreviewInspector
@dynamic layoutInformation;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self bind:@"rendition"
      toObject:self.inspectorController
   withKeyPath:@"representedObject.selection.self"
       options:nil];
//    
//    [self bind:@"layoutInformation"
//      toObject:self
//   withKeyPath:@"rendition.layoutInformation"
//       options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];

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

@end
