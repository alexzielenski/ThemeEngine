//
//  CFTAsset+Pasteboard.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/12/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTAsset.h"
#import "CFTEffectWrapper+Pasteboard.h"
#import "CFTGradient+Pasteboard.h"

#define kCFTAssetPboardType @"private.cftasset"

@interface CFTAsset (Pasteboard) <NSPasteboardWriting, NSPasteboardReading>

+ (instancetype)assetWithPasteboard:(NSPasteboard *)pasteboard;

@end
