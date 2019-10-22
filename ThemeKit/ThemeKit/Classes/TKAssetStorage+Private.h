//
//  TKAssetStorage+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

@import Foundation;
#import "TKMutableAssetStorage.h"
#import <CoreUI/CUIMutableCommonAssetStorage.h>
#import <CoreUI/CUIMutableCatalog.h>

#import <CoreUI/Renditions/_CUIInternalLinkRendition.h>

@interface TKAssetStorage () <_CUIInternalLinkRenditionSourceProvider>
@property (strong) CUICommonAssetStorage *storage;
@property (strong) CUICatalog *catalog;

@property (readwrite, strong) NSArray *renditionKeyAttributes;
@property (readwrite, copy) NSString *filePath;

- (void)_beginEnumeration;
- (void)_enumerateFacets;
- (void)_enumerateAssets;
- (void)_enumerateColors;
- (void)_enumerateFonts;

- (void)_addRendition:(TKRendition *)rendition;
- (void)removeElements:(NSSet<TKElement *> *)objects;
@end

@interface TKMutableAssetStorage (Private)
@property (strong) CUIMutableCommonAssetStorage *storage;
@property (strong) CUIMutableCatalog *catalog;
@end
