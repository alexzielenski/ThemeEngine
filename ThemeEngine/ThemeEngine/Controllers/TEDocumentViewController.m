//
//  TEDocumentViewController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEDocumentViewController.h"

@interface TEDocumentViewController ()

@end

@implementation TEDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSSplitViewItem *elementsItem   = [NSSplitViewItem splitViewItemWithViewController:self.elementsController];
    NSSplitViewItem *renditionsItem = [NSSplitViewItem splitViewItemWithViewController:self.renditionsController];
    NSSplitViewItem *inspectorItem  = [NSSplitViewItem splitViewItemWithViewController:self.inspectorController];

    [self addSplitViewItem:elementsItem];
    [self addSplitViewItem:renditionsItem];
    [self addSplitViewItem:inspectorItem];

    renditionsItem.holdingPriority = NSLayoutPriorityDefaultLow - 1;

    elementsItem.preferredThicknessFraction = 0.24;
    renditionsItem.preferredThicknessFraction = 0.6;
    inspectorItem.preferredThicknessFraction = 0.24;
    
    elementsItem.minimumThickness = 160.0;
    inspectorItem.minimumThickness = 230.0;
    
    elementsItem.canCollapse   = YES;
    renditionsItem.canCollapse = NO;
    inspectorItem.canCollapse  = YES;
}

- (NSSplitView *)splitView {
    return (NSSplitView *)self.view;
}

- (IBAction)sidebarToggle:(NSSegmentedControl *)sender {
    NSSplitViewItem *elementsItem = [self splitViewItemForViewController:self.elementsController];
    NSSplitViewItem *inspectorItem = [self splitViewItemForViewController:self.inspectorController];

    if (elementsItem.collapsed == [sender isSelectedForSegment:0])
        [elementsItem.animator setCollapsed:![sender isSelectedForSegment:0]];
    if (inspectorItem.collapsed == [sender isSelectedForSegment:1])
        [inspectorItem.animator setCollapsed:![sender isSelectedForSegment:1]];
    
    [self.splitView adjustSubviews];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return subview == self.elementsController.view || subview == self.inspectorController.view ||
    [super splitView:splitView canCollapseSubview:subview];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return dividerIndex == 0 || dividerIndex == 2 ||
    [super splitView:splitView shouldHideDividerAtIndex:dividerIndex];
}

@end
