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
//! NOTE: We are expecting collecitonProperties to be a static dictionary. If it is not, the app will likely
//! crash
+ (NSDictionary<NSString *, NSArray *> *)collectionProperties;
// @{ @"keypath": @"Action Name" };
//! NOTE: We are expecting undoProperties to be a static dictionary. If it is not, the app will likely
//! crash
+ (NSDictionary<NSString *, NSString *> *)undoProperties;

// This method is called when a change happens
// The change count is used to indicate dirty status of
// renditions to decide whether or not they should be committed to
// the store
- (void)updateChangeCount:(NSDocumentChangeType)change;

// Return YES if you want this class to create its own undo manager
// return NO if you will set it manually
- (BOOL)wantsUndoManager;

// Return YES if you want this class to set up observers at instantiation
// to handle undo registration.
- (BOOL)wantsUndoHandling;

@end
