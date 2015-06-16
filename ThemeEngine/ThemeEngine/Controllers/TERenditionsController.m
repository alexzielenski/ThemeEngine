//
//  TERenditionsController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TERenditionsController.h"
#import <ThemeKit/TKRendition.h>

@interface TERenditionsController ()

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
    
    [self.renditionBrowser bind:NSContentBinding
                       toObject:self.renditionsArrayController
                    withKeyPath:@"arrangedObjects"
                        options:nil];
    self.renditionBrowser.canControlQuickLookPanel = YES;
    self.inspectorController.representedObject = self.renditionsArrayController;
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

@end
