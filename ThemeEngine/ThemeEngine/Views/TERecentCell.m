//
//  TERecentCell.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERecentCell.h"

@implementation TERecentCell

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    
    if (backgroundStyle == NSBackgroundStyleDark ||
        backgroundStyle == NSBackgroundStyleLowered) {
        self.subTitleLabel.textColor = [NSColor selectedControlTextColor];
    } else {
        self.subTitleLabel.textColor = [NSColor controlTextColor];
    }

}

@end
