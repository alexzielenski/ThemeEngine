//
//  TKGradientRendition.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKRendition.h>
#import <ThemeKit/TKGradient.h>

@interface TKGradientRendition : TKRendition {
    TKGradient *_gradient;
}

@property (strong) TKGradient *gradient;
@end
