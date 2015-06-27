//
//  TEElementsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEElementsController.h"
#import "TEExportController.h"

static NSArray<NSArray *> *filterPredicates = nil;

@interface TEElementsController () <NSTableViewDataSource, NSTableViewDelegate>
- (void)scopeChanged:(TETexturedScope *)scope;
@end

@implementation TEElementsController

+ (void)initialize {
    filterPredicates = @[
                         @[ [NSImage imageNamed:@"ScopeMediaTemplate"], [NSPredicate predicateWithFormat:@"NONE renditions.isColor == YES && NONE renditions.isEffect == YES && NONE renditions.isRawData == YES"], @"Bitmaps" ],
                         @[ [NSImage imageNamed:@"ScopeColorTemplate"], [NSPredicate predicateWithFormat:@"ALL renditions.isColor == YES"], @"Colors" ],
                         @[ [NSImage imageNamed:@"ScopeFXTemplate"], [NSPredicate predicateWithFormat:@"ALL renditions.isEffect == YES"], @"Effects" ],
                         @[ [NSImage imageNamed:@"ScopeRawDataTemplate"], [NSPredicate predicateWithFormat:@"ALL renditions.isRawData == YES"], @"Raw Data" ]
                         ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortDescriptors = @[
                             [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]
                             ];
    
    self.tableView.verticalMotionCanBeginDrag = NO;
    
    for (NSUInteger i = 0; i < filterPredicates.count; i++) {
        id value = filterPredicates[i][0];
        if ([value isKindOfClass:[NSString class]])
            [self.elementScope setLabel:value forSegment:i];
        else
            [self.elementScope setImage:value forSegment:i];
        
        [(NSSegmentedCell *)self.elementScope.cell setToolTip: filterPredicates[i][2] forSegment: i];
    }
    
    // initialize default value
    [self scopeChanged:self.elementScope];
    
    self.elementScope.target = self;
    self.elementScope.action = @selector(scopeChanged:);
    
    self.tableView.enclosingScrollView.automaticallyAdjustsContentInsets = NO;
    self.tableView.enclosingScrollView.contentInsets = NSEdgeInsetsMake(28, 0, 0, 0);
    
    NSView *contentView = self.tableView.enclosingScrollView.contentView;

    self.tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableHeaderView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:0
                                                                    multiplier:0
                                                                      constant:28.0]];
    [contentView addSubview:self.tableHeaderView];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-28)-[headerView]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{ @"headerView": self.tableHeaderView }]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{ @"headerView": self.tableHeaderView }]];
    
}

- (void)scopeChanged:(TETexturedScope *)scope {
    if (scope.selectedSegment < filterPredicates.count)
        self.filterPredicate = filterPredicates[scope.selectedSegment][1];
    if (self.tableView.numberOfRows > 0)
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (NSView *)tableView:(NSTableView *)aTableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSTableCellView *cell = [aTableView makeViewWithIdentifier:@"ElementCell" owner:self];
    cell.textField.allowsExpansionToolTips = YES;
    return cell;
}

- (IBAction)receiveFromEditor:(id)sender {

}

- (IBAction)sendToEditor:(id)sender {
    
}

@end
