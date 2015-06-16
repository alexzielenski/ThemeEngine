//
//  TERenditionsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController.h"
#import <ThemeKit/TKRendition.h>

static NSString *keyForGroupTag(NSInteger tag) {
    switch (tag) {
        case 0:
            return @"element.name";
        case 1:
            return @"type";
        case 2:
            return @"state";
        case 3:
            return @"scale";
        case 4:
            return @"size";
        case 5:
            return @"value";
        case 6:
            return @"layer";
        case 7:
            return @"idiom";
        default:
            return nil;
    }
}

static NSString *stringKeyForGroupTag(NSInteger tag) {
    switch (tag) {
        case 0:
            return @"element.name";
        case 1:
            return @"typeString";
        case 2:
            return @"stateString";
        case 3:
            return @"scaleString";
        case 4:
            return @"sizeString";
        case 5:
            return @"valueString";
        case 6:
            return @"layerString";
        case 7:
            return @"idiomString";
        default:
            return nil;
    }
}

@interface TERenditionsController ()
@property (strong) NSArray *groups;
@property (strong) NSArray *originalSortDescriptors;
@end

@implementation TERenditionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sortDescriptors = @[
                             [NSSortDescriptor sortDescriptorWithKey:@"elementID" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"partID" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"state" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO selector:@selector(caseInsensitiveCompare:)]
                             ];
    self.originalSortDescriptors = self.sortDescriptors;
    
    [self.renditionBrowser bind:NSContentBinding
                       toObject:self.renditionsArrayController
                    withKeyPath:@"arrangedObjects"
                        options:nil];
    self.renditionBrowser.canControlQuickLookPanel = YES;
    self.inspectorController.representedObject = self.renditionsArrayController;
}

- (IBAction)changeGroup:(NSPopUpButton *)sender {
    NSString *key = keyForGroupTag([sender selectedTag]);
    if (key) {
        // sort primarily by the group selected
        NSMutableArray *groups = [NSMutableArray array];
        self.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:key ascending:YES] ];
        [self.renditionsArrayController rearrangeObjects];
        NSArray *objects = self.renditionsArrayController.arrangedObjects;
        
        // This is faster than using valueForKeyPath on the array then looping again to get
        // unique values with orderedSetWithArray:
        NSMutableArray *values = [NSMutableArray array];
        NSMutableOrderedSet *uniqueValues = [NSMutableOrderedSet orderedSet];
        for (NSUInteger x = 0; x < objects.count; x++) {
            id value = [objects[x] valueForKeyPath:key];
            [values addObject:value];
            [uniqueValues addObject:value];
        }
        
        NSUInteger nextStart = 0;
        for (NSUInteger i = 0; i < uniqueValues.count; i++) {
            NSUInteger start = nextStart;
            
            if (i + 1 < uniqueValues.count) {
                id nextValue = uniqueValues[i + 1];
                nextStart = [values indexOfObject:nextValue inRange:NSMakeRange(start, values.count - start)];
            } else {
                nextStart = values.count;
            }
            
            [groups addObject:@{
                                IKImageBrowserGroupStyleKey: @(IKGroupDisclosureStyle),
                                IKImageBrowserGroupTitleKey: [objects[start] valueForKeyPath:stringKeyForGroupTag(sender.selectedTag)],
                                IKImageBrowserGroupRangeKey: [NSValue valueWithRange:NSMakeRange(start, nextStart - start)]
                                }];
        }
        self.groups = groups;
    } else {
        self.groups = nil;
        self.sortDescriptors = self.originalSortDescriptors;
        [self.renditionsArrayController rearrangeObjects];
    }
    [self.renditionBrowser reloadData];
}

- (IBAction)zoomAnchorPressed:(NSButton *)sender {
    if (sender.tag == 0) {
        self.renditionBrowser.zoomValue = self.zoomSlider.minValue;
    } else {
        self.renditionBrowser.zoomValue = self.zoomSlider.maxValue;
    }
}

static NSString *sanitizeToken(NSString *token) {
    if ([token hasPrefix:@"\""] && [token hasSuffix:@"\""]) {
        // strip quotes
        return [token substringWithRange:NSMakeRange(1, token.length - 2)];
    }
    return [token stringByAppendingString:@"*"];
}

// Search parser
// supports any of the keywords specified in TKRendition+Filtering
// format, space separated terms
// use a ! prefix to negate
// minimum query length: 2
// to search a specific property use the format: "idiom:universal" with no spaces
// sorround any token with quotes for absolute matching (no fuzzy matching)
- (IBAction)searchRenditions:(NSSearchField *)sender {
    if (sender.stringValue.length < 2) {
        self.filterPredicate = nil;
        return;
    }
    
    NSArray *tokens = [sender.stringValue componentsSeparatedByString:@" "];
    NSMutableArray *predicates = [NSMutableArray array];
    for (NSString *item in tokens) {
        NSPredicate *predicate = nil;
        
        NSString *token = item;
        
        // See if this is a negation
        BOOL negate = [token hasPrefix:@"!"];
        if (negate)
            token = [token substringFromIndex:1];
        
        // See if its a specific search with a colon
        NSArray *parameters = [token componentsSeparatedByString:@":"];

        // If its just a keyword, search every keyword
        if (parameters.count == 1) {
            token = sanitizeToken(token);
            if (token.length == 0)
                continue;
            
            predicate = [NSPredicate predicateWithFormat:
                         @"ANY keywords LIKE[cd] %@", token];
            
        // otherwise search only the specific keyword
        } else if (parameters.count == 2) {
            NSString *key = parameters[0];
            token = sanitizeToken(parameters[1]);
            if (token.length == 0)
                continue;
            
            // the user might have typed name, or type, check name and typeString keys
            // and make sure this is a real key
            NSString *keyString = [key stringByAppendingString:@"String"];
            if (![TKRendition instancesRespondToSelector:NSSelectorFromString(keyString)]) {
                if (![TKRendition instancesRespondToSelector:NSSelectorFromString(key)]) {
                    continue;
                }
            } else {
                key = keyString;
            }
            
            predicate = [NSPredicate predicateWithFormat:
                         @"%K LIKE[cd] %@", key, token];
            
        } else {
            continue;
        }
        
        if (negate) {
            predicate = [NSCompoundPredicate notPredicateWithSubpredicate:predicate];
        }
        
        [predicates addObject:predicate];
    }
    
    self.filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

#pragma mark - IKImageBrowserViewDataSource

- (NSUInteger)numberOfGroupsInImageBrowser:(IKImageBrowserView *)aBrowser {
    return self.groups.count;
}

- (NSDictionary *)imageBrowser:(IKImageBrowserView *)aBrowser groupAtIndex:(NSUInteger)index {
    return self.groups[index];
}

@end
