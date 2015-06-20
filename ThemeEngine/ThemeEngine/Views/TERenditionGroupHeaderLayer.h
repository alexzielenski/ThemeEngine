//
//  TERenditionGroupHeaderLayer.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/20/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@interface TERenditionGroupHeaderLayer : CALayer
@property (strong) CATextLayer *textLayer;
@property (strong) CALayer *badgeLayer;
@property (strong) CATextLayer *badgeTextLayer;
@end
