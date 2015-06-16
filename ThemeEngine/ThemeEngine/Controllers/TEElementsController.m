//
//  TEElementsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEElementsController.h"

static NSArray<NSArray *> *filterPredicates = nil;

@interface TEElementsController ()
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
}

- (void)scopeChanged:(TETexturedScope *)scope {
    if (scope.selectedSegment < filterPredicates.count)
        self.filterPredicate = filterPredicates[scope.selectedSegment][1];
}

@end
