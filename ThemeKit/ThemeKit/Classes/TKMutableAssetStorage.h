//
//  TKMutableAssetStorage.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKAssetStorage.h>
#import <ThemeKit/TKTypes.h>

/**
 *  Mutable version of TKAssetStorage that allows you to save changes made to renditions
 */
@interface TKMutableAssetStorage : TKAssetStorage
/**
 *  Commits all changes to renditions to disk
 *
 *  @param update Set this to YES if you wish for all renditions to be marked as non-dirty, and synced
 * to disk. An example of when you would want this to be NO is in a "Save As" function where the document
 * is saved to a new location but still represents the old one.
 *
 *  @warning Documents will not be committed if their change counts have not changed since the last save.
 * either update their change counts manually, or make sure -wantsUndoHandling returns true
 *
 *  @see TKModelObject
 */
- (void)writeToDiskUpdatingChangeCounts:(BOOL)update;

- (void)addRendition:(TKRendition *)rendition;
- (void)removeRendition:(TKRendition *)rendition;

@end
