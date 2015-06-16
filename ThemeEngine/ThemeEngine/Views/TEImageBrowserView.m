//
//  TEImageBrowserView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEImageBrowserView.h"
#import "TERenditionBrowserCell.h"

@implementation TEImageBrowserView

- (IKImageBrowserCell *)newCellForRepresentedItem:(id)anItem {
    TERenditionBrowserCell *browserCell = [[TERenditionBrowserCell alloc] init];
    return browserCell;
}

@end
