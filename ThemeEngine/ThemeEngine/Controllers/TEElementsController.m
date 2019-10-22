//
//  TEElementsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEElementsController.h"
#import "TEExportController.h"
#import "TEAddRenditionController.h"

static NSArray<NSArray *> *filterPredicates = nil;

@interface TEFlippedView : NSView
@end

@implementation TEFlippedView

- (BOOL)isFlipped {
    return YES;
}

@end

@interface TEElementsController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) TEAddRenditionController *addRenditionController;
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
    
    NSView *contentView = self.tableView.enclosingScrollView.contentView;
    NSScrollView *scrollView = self.tableView.enclosingScrollView;
    NSTableView *table = self.tableView;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.focusRingType = NSFocusRingTypeNone;
    self.tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSView *container = [[TEFlippedView alloc] initWithFrame:contentView.bounds];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:table];

    NSRect tbf   = table.frame;
    tbf.origin.y = 29;
    table.frame  = tbf;

    [container addSubview:self.tableHeaderView];
    container.wantsLayer = YES;
    [self.tableHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableHeaderView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:0
                                                                    multiplier:1.0
                                                                      constant:29.0]];

    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[header]-0-[table]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{ @"header": self.tableHeaderView, @"table": self.tableView }]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{ @"header": self.tableHeaderView }]];
    
    [contentView addSubview:container];
    scrollView.documentView = container;

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(container)]];
}

- (void)scopeChanged:(TETexturedScope *)scope {
    if (scope.selectedSegment < filterPredicates.count)
        self.filterPredicate = filterPredicates[scope.selectedSegment][1];
    
    if (self.tableView.numberOfRows > 0)
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self.tableView reloadData];
}

- (NSView *)tableView:(NSTableView *)aTableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSTableCellView *cell = [aTableView makeViewWithIdentifier:@"ElementCell" owner:self];
    cell.textField.allowsExpansionToolTips = YES;
    return cell;
}

- (IBAction)addElement:(id)sender {
    NSLog(@"add element");
}

- (IBAction)addRendition:(id)sender {
    NSLog(@"add rends");
    if (!self.addRenditionController) {
        self.addRenditionController = [[TEAddRenditionController alloc] initWithWindowNibName:@"AddRendition"];
    }
    
    [self.addRenditionController beginWithWindow:self.view.window completionHandler:^(TKRendition *rendition) {
        NSLog(@"%@", rendition);
    }];
}

- (IBAction)removeSelection:(id)sender {
    NSLog(@"remove elements");
}

@end
