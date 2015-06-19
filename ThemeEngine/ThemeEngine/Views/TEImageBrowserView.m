//
//  TEImageBrowserView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEImageBrowserView.h"
#import "TERenditionBrowserCell.h"

@interface NSView (Private)
- (void)_viewDidChangeAppearance:(id)arg1;
@end

@implementation TEImageBrowserView

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];

}

- (void)_viewDidChangeAppearance:(id)arg1 {
    if ([[[NSAppearance currentAppearance] name] isEqualToString:NSAppearanceNameVibrantDark]) {
        [self setValue:[NSColor blackColor] forKey:IKImageBrowserBackgroundColorKey];
        [self setValue:@{ NSForegroundColorAttributeName: [NSColor controlTextColor] } forKey:IKImageBrowserCellsTitleAttributesKey];
    } else {
        [self setValue:[NSColor whiteColor] forKey:IKImageBrowserBackgroundColorKey];

        // .737255, 0.705882, 0.643137, 0.870588
        [self setValue:@{ NSForegroundColorAttributeName: [NSColor colorWithDeviceCyan:0.737255
                                                                               magenta:0.705882
                                                                                yellow:0.643137
                                                                                 black:0.870588
                                                                                 alpha:1.0] } forKey:IKImageBrowserCellsTitleAttributesKey];

    }
    
    [super _viewDidChangeAppearance: arg1];
}

- (void)layout {
    [super layout];
}

- (IKImageBrowserCell *)newCellForRepresentedItem:(id)anItem {
    TERenditionBrowserCell *browserCell = [[TERenditionBrowserCell alloc] init];
    return browserCell;
}

- (void)reloadData {
    [super reloadData];
    self.enclosingScrollView.contentInsets = self.enclosingScrollView.contentInsets;
}

@end
