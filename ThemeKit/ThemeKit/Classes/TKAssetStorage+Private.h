//
//  TKAssetStorage+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKMutableAssetStorage.h"
#import <CoreUI/CUIMutableCommonAssetStorage.h>
#import <CoreUI/Renditions/_CUIInternalLinkRendition.h>

@interface TKAssetStorage () <_CUIInternalLinkRenditionSourceProvider>
@property (strong) CUICommonAssetStorage *storage;
@property (readwrite, strong) NSArray *renditionKeyAttributes;

- (void)_beginEnumeration;
- (void)_enumerateAssets;
- (void)_enumerateColors;
- (void)_enumerateFonts;

- (void)_addRendition:(TKRendition *)rendition;
@end

@interface TKMutableAssetStorage (Private)
@property (strong) CUIMutableCommonAssetStorage *storage;
@end
