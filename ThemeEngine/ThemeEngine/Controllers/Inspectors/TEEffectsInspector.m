//
//  TEEffectsInspector.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEEffectsInspector.h"
#import <ThemeKit/TKEffectRendition.h>

@interface TEEffectsInspector ()

@end

@implementation TEEffectsInspector
@dynamic canEditAngle, canEditBlendMode, canEditBlurRadius, canEditColor1, canEditColor2, canEditOffset, canEditOpacity1, canEditOpacity2, canEditSoften, canEditSpread;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self bind:@"preset"
      toObject:self.inspectorController
   withKeyPath:@"representedObject.selection.effectPreset"
       options:@{ NSRaisesForNotApplicableKeysBindingOption: @(NO) }];
    ((NSStackView *)self.inspectorView).detachesHiddenViews = YES;
    
    [self bind:@"currentEffect"
      toObject:self.effectsController
   withKeyPath:@"selection.self"
       options:nil];
}

- (void)dealloc {
    [self unbind:@"currentEffect"];
    [self unbind:@"preset"];
}

- (NSStackViewVisibilityPriority)visibilityPriorityForInspectedObjects:(NSArray *)objects {
    if (objects.count != 1)
        return NSStackViewVisibilityPriorityNotVisible;
    return [[objects valueForKey:@"className"] containsObject:[TKEffectRendition className]] ?
    NSStackViewVisibilityPriorityMustHold : NSStackViewVisibilityPriorityNotVisible;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasPrefix:@"canEdit"]) {
        return [NSSet setWithObject:@"currentEffect"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}

#pragma mark - Properties

- (BOOL)canEditAngle {
    switch (self.currentEffect.type) {
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditBlendMode {
    switch (self.currentEffect.type) {
        case CUIEffectTypeColorFill:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditBlurRadius {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditColor1 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeColorFill:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeGradientFill:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditColor2 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeGradientFill:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOffset {
    switch (self.currentEffect.type) {
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOpacity1 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeColorFill:
        case CUIEffectTypeGradientFill:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
        case CUIEffectTypeOutputOpacity:
        case CUIEffectTypeShapeOpacity:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOpacity2 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditSoften {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditSpread {
    switch (self.currentEffect.type) {
        case CUIEffectTypeOuterGlow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}


@end
