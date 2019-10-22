//
//  TKRendition.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRendition.h"
#import "TKRendition+Private.h"
#import "TKAssetStorage+Private.h"

#import "TKColorRendition.h"
#import "TKGradientRendition.h"
#import "TKBitmapRendition.h"
#import "TKEffectRendition.h"
#import "TKRawDataRendition.h"
#import "TKPDFRendition.h"
#import "TKRawPixelRendition.h"

#import <CoreUI/Renditions/CUIRenditions.h>
#import <objc/objc.h>
#import <CommonCrypto/CommonDigest.h>

NSString *md5(const char *cStr) {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

static const void *TKRenditionChangeContext = &TKRenditionChangeContext;

@interface TKRendition ()
@property (copy) NSString *_renditionHash;
@property (readwrite) CGFloat scaleFactor;
@end

@implementation TKRendition
@dynamic state, value, size, elementID, partID, idiom, direction, presentationState, layer, type, scale;

+ (Class)renditionClassForCoreUIRendition:(CUIThemeRendition *)rendition {
    if ([rendition isKindOfClass:TKClass(_CUIExternalLinkRendition)] ||
        [rendition isKindOfClass:TKClass(_CUIInternalLinkRendition)] ||
        [rendition isKindOfClass:TKClass(_CUIThemePixelRendition)]) {
        return [TKBitmapRendition class];
        
    } else if ([rendition isKindOfClass:TKClass(_CUIThemeEffectRendition)]) {
        return [TKEffectRendition class];
        
    } else if ([rendition isKindOfClass:TKClass(_CUIThemeGradientRendition)]) {
        return [TKGradientRendition class];
        
    } else if ([rendition isKindOfClass:TKClass(_CUIPDFRendition)] || [rendition isKindOfClass:TKClass(_CUIThemePDFRendition)]) {
        return [TKPDFRendition class];
        
    } else if ([rendition isKindOfClass:TKClass(_CUIRawDataRendition)]) {
        return [TKRawDataRendition class];
    } else if ([rendition isKindOfClass:TKClass(_CUIRawPixelRendition)]) {
        return [TKRawPixelRendition class];
    }
    
    NSLog(@"Unknown class for rendition: %@", rendition);
    return [TKBitmapRendition class];
}

+ (instancetype)renditionWithCSIData:(NSData *)csiData renditionKey:(CUIRenditionKey *)key {
    if (!csiData || csiData.length == 0) {
        NSLog(@"Empty CSI Data!");
        return nil;
    }
    
    CUIThemeRendition *rendition = [[TKClass(CUIThemeRendition) alloc] initWithCSIData:csiData forKey:key.keyList];
    if (rendition == nil) return nil;
    return [TKRendition renditionWithCUIRendition:rendition csiData:csiData key:key];
}

+ (instancetype)renditionWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    return [[[TKRendition renditionClassForCoreUIRendition:rendition] alloc] _initWithCUIRendition:rendition csiData:csiData key:key];
}

- (instancetype)_initWithCUIRendition:(CUIThemeRendition *)rendition csiData:(NSData *)csiData key:(CUIRenditionKey *)key {
    if ((self = [self init])) {        
        self.renditionKey    = key;
        self.rendition       = rendition;
        self.name            = rendition.name;
        self.utiType         = rendition.utiType;
        self.exifOrientation = rendition.exifOrientation;
        self.blendMode       = rendition.blendMode;
        self.opacity         = rendition.opacity;
        
        struct csiheader header;
        [csiData getBytes:&header range:NSMakeRange(0, offsetof(struct csiheader, infolistLength) + sizeof(unsigned int))];

        self.fpo                        = header.renditionFlags.isHeaderFlaggedFPO;
        self.excludedFromContrastFilter = header.renditionFlags.isExcludedFromContrastFilter;
        self.vector                     = header.renditionFlags.isVectorBased;
        self.opaque                     = header.renditionFlags.isOpaque;
        self.layout                     = header.metadata.layout;
        self.colorspaceID               = header.colorspaceID;
        self.scaleFactor                = (CGFloat)header.scaleFactor / 100.0;
        self.pixelFormat                = header.pixelFormat;
        self.renderingMode              = rendition.templateRenderingMode;
                
        //TOOD: Find out if this impacts our ability to save
        CFDataRef *data = TKIvarPointer(self.rendition, "_srcData");
        if (data != NULL) {
            if (*data != NULL)
                CFRelease(*data);
            *data = NULL;
        }
    }
    
    return self;
}

+ (instancetype)renditionWithColorKey:(struct colorkey)key definition:(struct colordef)definition {
    return [[TKColorRendition alloc] initWithColorKey:key definition:definition];
}

- (instancetype)initWithColorKey:(struct colorkey)key definition:(struct colordef)definition {
    [NSException raise:@"Invalid Selector" format:@"TKRendition does not implement initWithColorKey: definition"];
    return nil;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.undoManager = nil;
        [self addObserver:self
               forKeyPath:@"changeCount"
                  options:0
                  context:&TKRenditionChangeContext];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@"changeCount"
                 context:&TKRenditionChangeContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == &TKRenditionChangeContext) {
        self._previewImage = nil;
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSImage *)previewImage {
    [self computePreviewImageIfNecessary];
    return self._previewImage;
}

- (void)computePreviewImageIfNecessary {
    if (!self._previewImage) {
        self._previewImage = [NSImage imageNamed:@"NSApplicationIcon"];
    }
}

- (NSUndoManager *)undoManager {
    return self.element.storage.undoManager;
}

#pragma mark - Saving

- (void)removeFromStorage {
    [self.cuiAssetStorage removeAssetForKey:self.keyData];
}

- (void)commitToStorage {
    CSIGenerator *generator = self.generator;
    generator.utiType                    = self.utiType;
    generator.templateRenderingMode      = self.renderingMode;
    generator.isVectorBased              = self.isVector;
    generator.isRenditionFPO             = self.isFPO;
    generator.excludedFromContrastFilter = self.isExcludedFromConstrastFilter;
    generator.name                       = self.name;
    generator.blendMode                  = self.blendMode;
    generator.opacity                    = self.opacity;
    generator.exifOrientation            = self.exifOrientation;
    generator.colorSpaceID               = self.colorspaceID;
    generator.scaleFactor                = self.scale;
    
    
    NSData *csiData = nil;
    
    @try {
        csiData = [generator CSIRepresentationWithCompression:YES];
    }
    
    @catch (NSException *exception) {
        NSLog(@"%@ caught %@", self.name, exception);
        NSLog(@"refs: %@", [generator valueForKey:@"_references"]);
    }
    
    @finally {
        if (csiData == nil) {
            NSLog(@"Got null csidata, backing out...");
            return;
        }
        
        [self.cuiAssetStorage setAsset:csiData forKey:self.keyData];
    }
}

- (CSIGenerator *)generator {
    [NSException raise:@"Invalid Callee"
                format:@"called -generator or -commitToStorage on abstract TKRendition class Contact the developer with this message if this happens. Backing rendition: %@", self.rendition];
    return nil;
}

#pragma mark - KVC

+ (NSDictionary<NSString *, NSString *> *)undoProperties {
    static NSDictionary *TKRenditionProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TKRenditionProperties = @{
                                  TKKey(exifOrientation): @"Change EXIF Orientation",
                                  TKKey(blendMode): @"Change Blend Mode",
                                  TKKey(scaleFactor): @"Change Scale Factor",
                                  @"opaque": @"Change Opaque Status",
                                  @"vector": @"Change Vector Status",
                                  @"fpo": @"Change FPO Status",
                                  TKKey(opacity): @"Change Opacity",
                                  TKKey(utiType): @"Change UTI",
                                  TKKey(renderingMode): @"Change Template Mode"
                                  };
    });
    
    return TKRenditionProperties;
}

+ (NSSet *)keyPathsForValuesAffectingPreviewImage {
    return [NSSet setWithObject:TKKey(_previewImage)];
}

#pragma mark - Properties

- (CUIMutableCommonAssetStorage *)cuiAssetStorage {
    return (CUIMutableCommonAssetStorage *)self.element.storage.storage;
}

- (NSData *)keyData {
    return TKConvertRenditionKeyToCARKey([NSData dataWithBytesNoCopy:(void *)self.renditionKey.keyList
                                                              length:60 freeWhenDone:NO],
                                         self.cuiAssetStorage);
}

- (CoreThemeValue)value {
    return self.renditionKey.themeValue;
}

- (CoreThemeState)state {
    return self.renditionKey.themeState;
}

- (CoreThemeSize)size {
    return self.renditionKey.themeSize;
}

- (NSUInteger)elementID {
    return self.renditionKey.themeElement;
}

- (NSUInteger)partID {
    return self.renditionKey.themePart;
}

- (CoreThemeIdiom)idiom {
    return self.renditionKey.themeIdiom;
}

- (CoreThemeDirection)direction {
    return self.renditionKey.themeDirection;
}

- (CoreThemeLayer)layer {
    return self.renditionKey.themeLayer;
}

- (CoreThemePresentationState)presentationState {
    return self.renditionKey.themePresentationState;
}

- (CoreThemeType)type {
    return self.rendition.type;
}

- (CGFloat)scale {
    return (CGFloat)self.renditionKey.themeScale;
}

- (NSString *)renditionHash {
    if (!self._renditionHash) {
WITH(self.renditionKey)
        self._renditionHash = md5((const char *)_.keyList);
ENDWITH
    }
    
    return self._renditionHash;
}

@end
