//
//  TKRendition.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKTypes.h>

@class TKElement;
// Partially Abstract Root class for all rendition types
@interface TKRendition : NSObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, weak) TKElement *element;
@property (readonly) NSImage *previewImage;

@property (nonatomic, readonly, assign) NSUInteger changeCount;
@property (nonatomic, readonly, assign) NSUInteger lastChangeCount;

@property (readonly, getter=isDirty) BOOL dirty;
@property (nonatomic, readonly, getter=isAssetPack) BOOL assetPack;

@property (readonly) CoreThemeSize size;
@property (readonly) CoreThemeValue value;
@property (readonly) CoreThemeState state;
@property (readonly) NSUInteger elementID;
@property (readonly) NSUInteger partID;
@property (readonly) CoreThemeIdiom idiom;
@property (readonly) CoreThemeDirection direction;
@property (readonly) CoreThemePresentationState presentationState;
@property (readonly) CoreThemeType type;
@property (readonly) CoreThemeLayer layer;
@property (readonly) CGFloat scale;

// Hash unique to this rendition key
- (NSString *)renditionHash;
- (void)computePreviewImageIfNecessary;

@end
