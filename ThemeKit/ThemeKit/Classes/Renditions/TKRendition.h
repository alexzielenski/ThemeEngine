//
//  TKRendition.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ThemeKit/TKTypes.h>
#import <ThemeKit/TKModelObject.h>

@class TKElement;
@class TKAssetStorage;

// Partially Abstract Root class for all rendition types
@interface TKRendition : TKModelObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, weak) TKElement *element;

@property (getter=isFPO) BOOL fpo;
@property (getter=isOpaque) BOOL opaque;
@property (getter=isVector) BOOL vector;
@property (assign) CSIPixelFormat pixelFormat;
@property CGFloat opacity;
@property TKEXIFOrientation exifOrientation;
@property CGBlendMode blendMode;
@property short layout;
@property (getter=isExcludedFromConstrastFilter) BOOL excludedFromContrastFilter;
@property (readonly) CGFloat scaleFactor;
@property short colorspaceID;
@property (assign) CoreThemeTemplateRenderingMode renderingMode;

@property (readonly) NSImage *previewImage;
@property (nonatomic, readonly, getter=isAssetPack) BOOL assetPack;

@property (copy) NSString *utiType;

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
