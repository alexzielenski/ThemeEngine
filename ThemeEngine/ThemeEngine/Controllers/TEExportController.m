//
//  TEExportController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEExportController.h"
#import <ThemeKit/TKBitmapRendition.h>
#import <ThemeKit/TKPDFRendition.h>

#import "NSAppleScript+Functions.h"
#import "NSURL+Paths.h"

@import Cocoa;

@interface TEExportController ()
@property (strong) NSMutableDictionary *sliceMap;
- (NSBitmapImageRep *)packedRepresentationUsingImages:(NSArray <NSBitmapImageRep *> *)images slices:(NSArray <NSValue *> **)slices;
@end

@implementation TEExportController

+ (instancetype)sharedExportController {
    static TEExportController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TEExportController alloc] init];
    });
    
    return shared;
}

- (id)init {
    if ((self = [super init])) {
        self.sliceMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)exportRenditions:(NSArray <TKRendition *> *)renditions {
    NSSet *types = [NSSet setWithArray:[renditions valueForKeyPath:@"className"]];
    if (types.count > 1) {
        NSLog(@"select different types");
        return;
    } else if (types.count == 0) {
        return;
    }
    
    TKRendition *rendition = renditions.firstObject;
    NSURL *tmpURL = [NSURL temporaryURLInSubdirectory:TKTemporaryDirectoryExports];
    
    if ([rendition isKindOfClass:[TKBitmapRendition class]]) {
        NSArray *slices = nil;
        NSBitmapImageRep *packed = [self packedRepresentationUsingImages:[renditions valueForKeyPath:@"image"] slices:&slices];
        NSURL *url = [tmpURL URLByAppendingPathComponent:[[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@"png"]];
        [[packed representationUsingType:NSPNGFileType properties:@{}] writeToURL:url atomically:NO];
        
        [[NSWorkspace sharedWorkspace] openURLs:@[ url ]
                        withAppBundleIdentifier:@"com.adobe.Photoshop"
                                        options:0
                 additionalEventParamDescriptor:nil
                              launchIdentifiers:nil];
        
        self.sliceMap[url.lastPathComponent] = slices;
        
    } else if ([rendition isKindOfClass:[TKPDFRendition class]]) {
        
        NSMutableArray *urls = [NSMutableArray array];
        for (TKPDFRendition *rend in renditions) {
            NSURL *url = [tmpURL URLByAppendingPathComponent:[[[NSUUID UUID] UUIDString] stringByAppendingString:@"pdf"]];
            [rend.rawData writeToURL:url atomically:NO];
            [urls addObject:url];
        }
        
        [[NSWorkspace sharedWorkspace] openURLs:urls
                        withAppBundleIdentifier:@"com.adobe.illustrator"
                                        options:NSWorkspaceLaunchDefault
                 additionalEventParamDescriptor:nil
                              launchIdentifiers:nil];
        
    } else {
        NSLog(@"no rule to export");
    }
    
}

- (void)importRenditions:(NSArray <TKRendition *> *)renditions {
    NSSet *types = [NSSet setWithArray:[renditions valueForKeyPath:@"className"]];
    if (types.count > 1) {
        NSLog(@"select different types");
        return;
    } else if (types.count == 0) {
        return;
    }
    
    NSURL *tmpURL = [NSURL temporaryURLInSubdirectory:TKTemporaryDirectoryExports];
    TKRendition *rendition = renditions.firstObject;
    if ([rendition isKindOfClass:[TKBitmapRendition class]]) {
        NSDataAsset *asset         = [[NSDataAsset alloc] initWithName:@"ApplescriptReceiveFromPhotoshop"];
        NSData *data               = asset.data;
        NSString *format           = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
        NSRunningApplication *bndl = [NSRunningApplication
                                      runningApplicationsWithBundleIdentifier:@"com.adobe.Photoshop"].firstObject;
        
        if (!bndl) {
            NSLog(@"photoshop is not running");
            return;
        }
        
        NSString *name             = bndl.bundleURL.lastPathComponent.stringByDeletingPathExtension;
        NSString *scriptText       = [NSString stringWithFormat:format, name, name];
        NSAppleScript *script      = [[NSAppleScript alloc] initWithSource:scriptText];
        
        NSURL *dst    = [[tmpURL URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]] URLByAppendingPathExtension:@"tiff"];
        //!TODO Do something with the rtn error
        NSString *rtn = [script executeFunction:TEAppleScriptExportFunctionName
                                  withArguments:@[ dst.path ]
                                          error:nil];
        
        NSString *documentName = [script executeFunction:TEAppleScriptGetFileFunctionName
                                           withArguments:nil
                                                   error:nil];
        NSData *d = [NSData dataWithContentsOfURL:dst];
        if (!d) {
            NSLog(@"couldnt get data");
            return;
        }
        
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:d];
        
        // Check if we have slices
        NSArray <NSValue *> *slices = self.sliceMap[documentName];
        if (slices) {
            // we can slice it back up
            CGImageRef ref = rep.CGImage;
            for (NSInteger i = 0; i < renditions.count; i++) {
                NSInteger sliceIdx = i % slices.count;
                TKBitmapRendition *rend = (TKBitmapRendition *)renditions[i];
                NSRect orig = slices[sliceIdx].rectValue;
                NSRect flipped = NSMakeRect(NSMinX(orig), rep.pixelsHigh - NSMaxY(orig), NSWidth(orig), NSHeight(orig));

                CGImageRef slice = CGImageCreateWithImageInRect(ref, flipped);
                if (!slice) {
                    NSLog(@"GOT NULL SLICE: INVESTIGATE");
                    continue;
                }
                
                NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithCGImage:slice];
                [[image representationUsingType:NSPNGFileType properties:@{}] writeToFile:[@"/Users/Alex/Desktop/slices" stringByAppendingFormat:@"/%ld.png", (long)i] atomically:NO];
                [rend setValue:image forKey:@"image"];
                CGImageRelease(slice);
            }
            
        } else {
            [renditions makeObjectsPerformSelector:@selector(setImage:) withObject:rep];
        }
        
    } else if ([rendition isKindOfClass:[TKPDFRendition class]]) {
        NSDataAsset *asset         = [[NSDataAsset alloc] initWithName:@"ApplescriptReceiveFromIllustrator"];
        NSData *data               = asset.data;
        NSString *format           = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSRunningApplication *bndl = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.adobe.illustrator"].firstObject;
        
        if (!bndl) {
            NSLog(@"illustrator is not running");
            return;
        }
        
        NSString *name             = bndl.bundleURL.lastPathComponent.stringByDeletingPathExtension;
        NSString *scriptText       = [NSString stringWithFormat:format, name, name];
        NSAppleScript *script      = [[NSAppleScript alloc] initWithSource:scriptText];
        
        NSURL *dst    = [[tmpURL URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]] URLByAppendingPathExtension:@"pdf"];
        NSString *rtn = [script executeFunction:TEAppleScriptExportFunctionName
                                  withArguments:@[ dst.path ]
                                          error:nil];
        NSData *d     = [NSData dataWithContentsOfURL:dst];
        
        if (d) {
            [renditions makeObjectsPerformSelector:@selector(setRawData:) withObject:d];
        }
        
        if (rtn) {
            NSLog(@"%@", rtn);
        }
    } else {
        NSLog(@"no rule to import");
    }
}


#define kImagePadding 12
#define kStrokeSize 1
- (NSBitmapImageRep *)packedRepresentationUsingImages:(NSArray <NSBitmapImageRep *> *)images slices:(NSArray <NSValue *> **)exportSlices {
    if (images.count == 1) {
        return images.firstObject;
    }
    
    // Grid Layout
    NSInteger const numCols  = 4;
    NSInteger const numRows  = ceil((CGFloat)images.count / (CGFloat)numCols);

    // Evenly space out all the images
    CGFloat const itemWidth  = [[images valueForKeyPath:@"@max.pixelsWide"] doubleValue];
    CGFloat const itemHeight = [[images valueForKeyPath:@"@max.pixelsHigh"] doubleValue];
    
    // Composited Image Dimensions
    CGFloat const maxWidth   = (itemWidth + kImagePadding) * numCols + kImagePadding;
    CGFloat const maxHeight  = (itemHeight + kImagePadding) * numRows + kImagePadding;

    // Array to store every slice in
    NSMutableArray *slices = [NSMutableArray array];
    
    NSBitmapImageRep *packed = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                       pixelsWide:maxWidth
                                                                       pixelsHigh:maxHeight
                                                                    bitsPerSample:8
                                                                  samplesPerPixel:4
                                                                         hasAlpha:YES
                                                                         isPlanar:NO
                                                                   colorSpaceName:NSDeviceRGBColorSpace
                                                                      bytesPerRow:4 * maxWidth
                                                                     bitsPerPixel:32];
    
    // Stroke color for bounds of image
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:packed]];
    [[NSColor redColor] set];
    
    for (NSInteger i = 0; i < images.count; i++) {
        NSInteger x = i % numCols;
        NSInteger y = numRows - 1 - (NSInteger)(i / numCols);
        NSBitmapImageRep *rep = images[i];

        NSRect bounds = NSMakeRect(kImagePadding + x * (itemWidth + kImagePadding),
                                   kImagePadding + y * (itemHeight + kImagePadding),
                                   itemWidth,
                                   itemHeight);
        bounds = NSMakeRect(round(NSMidX(bounds) - rep.pixelsWide / 2),
                            round(NSMidY(bounds) - rep.pixelsHigh / 2),
                            rep.pixelsWide, rep.pixelsHigh);
        
        // Enumerate in reverse order
        [rep drawInRect:bounds
               fromRect:NSZeroRect
              operation:NSCompositeSourceOver
               fraction:1.0
         respectFlipped:NO
                  hints:nil];
        
        // Draw Stroke
        NSRect strokeRect = NSInsetRect(bounds, -kStrokeSize, -kStrokeSize);
        // Bottom Left to Top Left
        NSRectFill(NSMakeRect(NSMinX(strokeRect), NSMinY(strokeRect), 1.0, NSHeight(strokeRect)));
        // Top Left to Top Right
        NSRectFill(NSMakeRect(NSMinX(strokeRect), NSMaxY(strokeRect) - 1.0, NSWidth(strokeRect), 1.0));
        // Top Right to Bottom Right
        NSRectFill(NSMakeRect(NSMaxX(strokeRect) - 1.0, NSMinY(strokeRect), 1.0, NSHeight(strokeRect)));
        // Bottom Right to Bottom Left
        NSRectFill(NSMakeRect(NSMinX(strokeRect), NSMinY(strokeRect), NSWidth(strokeRect), 1.0));
        
        [slices insertObject:[NSValue valueWithRect:bounds] atIndex:i];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    if (exportSlices != NULL)
        *exportSlices = slices;
    
    return packed;
}

@end
