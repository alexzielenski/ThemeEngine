//
//  TEEffectsInspector.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/18/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEInspectorDetailController.h"
#import <ThemeKit/TKEffectRendition.h>


@class TEInspectorController;
@interface TEEffectsInspector : TEInspectorDetailController
@property (weak) IBOutlet TEInspectorController *inspectorController;
@property (weak) IBOutlet NSArrayController *effectsController;
@property TKEffect *currentEffect;
@property TKEffectPreset *preset;

@property (readonly) BOOL canEditColor1;
@property (readonly) BOOL canEditColor2;
@property (readonly) BOOL canEditOpacity1;
@property (readonly) BOOL canEditOpacity2;
@property (readonly) BOOL canEditBlurRadius;
@property (readonly) BOOL canEditBlendMode;
@property (readonly) BOOL canEditOffset;
@property (readonly) BOOL canEditAngle;
@property (readonly) BOOL canEditSoften;
@property (readonly) BOOL canEditSpread;


@end
