//
//  TKModelObject.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/22/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKCollectionType) {
    TKCollectionTypeArray      = 0,
    TKCollectionTypeSet        = 1,
    TKCollectionTypeOrderedSet = 2,
};

@interface TKModelObject : NSObject
@property (strong) NSUndoManager *undoManager;
@property (nonatomic, readonly, assign) NSUInteger changeCount;
@property (nonatomic, readonly, assign) NSUInteger lastChangeCount;

@property (readonly, getter=isDirty) BOOL dirty;

// For undo to observe every element in the collection
// { @"collection": @[ @"Undo Name", @(TKCollectionType), @{ @"collectionItemKeyPath": @"Action Name" } ] }
+ (NSDictionary<NSString *, NSArray *> *)collectionProperties;
// @{ @"keypath": @"Action Name" };
+ (NSDictionary<NSString *, NSString *> *)undoProperties;

- (void)updateChangeCount:(NSDocumentChangeType)change;
- (BOOL)wantsUndoManager;

// Dynamically disables undo registration
- (BOOL)wantsUndoHandling;

@end
