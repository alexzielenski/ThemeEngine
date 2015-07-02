//
//  TEDocumentViewController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/16/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEDocumentViewController.h"

@interface TEDocumentViewController ()
@property (nonatomic, strong) NSSplitViewItem *elementsItem;
@property (nonatomic, strong) NSSplitViewItem *renditionsItem;
@property (nonatomic, strong) NSSplitViewItem *inspectorItem;
@end

const void *kTEDocumentControllerCollapseContext = &kTEDocumentControllerCollapseContext;

@implementation TEDocumentViewController
@dynamic splitView;
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.splitView.delegate != self)
        self.splitView.delegate = self;
    
    self.elementsItem   = [NSSplitViewItem sidebarWithViewController:self.elementsController];
    self.renditionsItem = [NSSplitViewItem splitViewItemWithViewController:self.renditionsController];
    self.inspectorItem  = [NSSplitViewItem splitViewItemWithViewController:self.inspectorController];

    [self addSplitViewItem:self.elementsItem];
    [self addSplitViewItem:self.renditionsItem];
    [self addSplitViewItem:self.inspectorItem];

    self.renditionsItem.holdingPriority = NSLayoutPriorityDefaultLow - 1;

    self.elementsItem.preferredThicknessFraction = 0.24;
    self.renditionsItem.preferredThicknessFraction = 0.6;
    self.inspectorItem.preferredThicknessFraction = 0.24;
    
    self.elementsItem.minimumThickness = 160.0;
    self.inspectorItem.minimumThickness = 230.0;
    self.inspectorItem.maximumThickness = 600.0;
    self.inspectorItem.springLoaded = NO;
    
    self.elementsItem.canCollapse   = YES;
    self.renditionsItem.canCollapse = NO;
    self.inspectorItem.canCollapse  = YES;
    
    [self addObserver:self
           forKeyPath:@"elementsItem.collapsed"
              options:0
              context:&kTEDocumentControllerCollapseContext];
    [self addObserver:self
           forKeyPath:@"inspectorItem.collapsed"
              options:0
              context:&kTEDocumentControllerCollapseContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &kTEDocumentControllerCollapseContext) {
        [self.paneControl setSelected:!self.elementsItem.isCollapsed forSegment:0];
        [self.paneControl setSelected:!self.inspectorItem.isCollapsed forSegment:1];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"elementsItem.collapsed"];
    [self removeObserver:self forKeyPath:@"inspectorItem.collapsed"];
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
    return /* DISABLES CODE */ (YES) ||
    [super splitView:splitView shouldHideDividerAtIndex:dividerIndex];
}

@end
