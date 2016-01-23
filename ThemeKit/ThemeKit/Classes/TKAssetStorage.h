//
//  TKAssetStorage.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKElement.h>
#import <ThemeKit/TKTypes.h>

extern NSString *const TKAssetStorageDidFinishLoadingNotification;

/**
 *  TKAssetStorage represents a car file on disk. It populates its elements and renditions lists
 * based on the contents of the car file. You can use this class to obtain a list of all elements or
 * renditions available in the car file. If you wish to save your car file, refer to TKMutableAssetStorage
 */
@interface TKAssetStorage : NSObject
/**
 *  Set of TKElements belonging to this asset storage
 *  @see TKElement
 */
@property (readonly, strong) NSSet<TKElement *> *elements;
/**
 *  Undo manager to which we register the undo actions.
 *  @warning Settings this property to nil will still have the performance hit
 *  of registering undo properties. Create a category on all subclasses of TKModelObject
 *  and override `-(BOOL)wantsUndoHandling`
 *  @warning This property must be non-nil for `dirty` to be marked.
 *  @see TKModelObject
 */
@property (strong) NSUndoManager *undoManager;
/**
 *  Path to the asset storage
 *  @warning This path is not reliable. CoreUI's backing layout often creates
 *  temporary file storage for asset catalogs
 */
@property (readonly, copy) NSString *path;
/**
 *  Path passed to initWithPath:forWriting:
 *  @warning This path may or may not be used
 */
@property (readonly, copy) NSString *filePath;
/**
 *  Indicator of if any renditions in this storage have had changes registered to them.
 *  @warning This property will not be useful if the rendition's `-wantsUndoHandling` returns NO.
 */
@property (assign, getter=isDirty) BOOL dirty;

/**
 *  List of allowed attributes for this Asset Catalog.
 *  @see TKThemeAttribute
 */
@property (readonly, strong) NSArray *renditionKeyAttributes;

/**
 *  Creates an asset storage object
 *
 *  @param path Path to your .car file
 *
 *  @return A new asset storage object for managing the car file
 */
+ (instancetype)assetStorageWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path;

/**
 *  @param name Name of the element you want to find.
 *
 *  @return an element with `name`, or NULL, if there is none
 */
- (TKElement *)elementWithName:(NSString *)name;

/**
 *  Gives a list of all renditions for all elements in this asset storage
 *
 *  @return an NSSet of TKRendition
 *  @see TKRendition
 */
- (NSSet<TKRendition *> *)allRenditions;

@end
