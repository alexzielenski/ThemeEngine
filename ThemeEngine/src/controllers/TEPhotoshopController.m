//
//  TEPhotoshopController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/14/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEPhotoshopController.h"

// Current documents is an array of dictionaries
// Dictionaries are in the following format:

// filepath – path
// images - [] – rectangular locations of all the images

// If the current photoshop document isn't in -currentDocuments, receiveImagesFromPhotoshop returns an array of one image,
// that being the entire image

@interface TEPhotoshopController ()
@property (strong) NSMutableDictionary *currentDocuments;
- (NSDictionary *)exportDocumentToPath:(NSString *)path withPhotoshopInstance:(NSString *)ps;
@end

@implementation TEPhotoshopController

+ (instancetype)sharedPhotoshopController {
    static TEPhotoshopController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (id)init {
    if ((self = [super init])) {
        self.currentDocuments = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#define kImagePadding 12
#define kStrokeSize 1

- (void)sendImagesToPhotoshop:(NSArray *)images withLayout:(NSIndexSet *)layout dimensions:(NSSize)dimensions {
    NSMutableArray *rows = [NSMutableArray array];
    NSUInteger currentRow = 0;
    while (currentRow < dimensions.height) {
        NSRange range = NSMakeRange(currentRow * dimensions.width, dimensions.width);
        NSIndexSet *indices = [layout indexesInRange:range options:NSEnumerationConcurrent passingTest:^BOOL(NSUInteger idx, BOOL *stop) {
            return YES;
        }];
        if (indices.count > 0) {
            NSArray *bitmaps = [images objectsAtIndexes:indices];
            
            if (bitmaps.count > 0)
                [rows addObject:bitmaps];
        }
        currentRow++;
    }
    if (rows.count == 0)
        return;
    
    CGFloat itemWidth  = [[[rows valueForKeyPath:@"@unionOfArrays.pixelsWide"] valueForKeyPath:@"@max.self"] doubleValue];
    CGFloat itemHeight = [[[rows valueForKeyPath:@"@unionOfArrays.pixelsHigh"] valueForKeyPath:@"@max.self"] doubleValue];
    NSUInteger numCols = [[rows valueForKeyPath:@"@max.@count"] unsignedIntegerValue];
    
    itemWidth += kStrokeSize * 2;
    itemHeight += kStrokeSize * 2;
    
    CGFloat maxWidth = itemWidth * numCols;
    CGFloat maxHeight = itemHeight * rows.count;
    maxWidth += kImagePadding * (numCols - 1);
    maxHeight += kImagePadding * (rows.count - 1);
    
    NSMutableArray *slices = [NSMutableArray array];
    
    NSBitmapImageRep *rowImage = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                         pixelsWide:maxWidth
                                                                         pixelsHigh:maxHeight
                                                                      bitsPerSample:8
                                                                    samplesPerPixel:4
                                                                           hasAlpha:YES
                                                                           isPlanar:NO
                                                                     colorSpaceName:NSDeviceRGBColorSpace
                                                                        bytesPerRow:4 * maxWidth
                                                                       bitsPerPixel:32];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rowImage]];
    
    [[NSColor redColor] set];
    CGFloat currentY = 0;
    for (NSArray *bitmaps in rows.reverseObjectEnumerator.allObjects) {
        CGFloat currentX = 0;
        NSMutableArray *rowSlices = [NSMutableArray array];
        
        for (NSBitmapImageRep *rep in bitmaps) {
            [NSGraphicsContext saveGraphicsState];
            NSRect bounds = NSMakeRect(currentX + kStrokeSize, currentY + kStrokeSize, itemWidth - kStrokeSize * 2, itemHeight - kStrokeSize * 2);
            bounds = NSMakeRect(round(NSMidX(bounds) - rep.pixelsWide / 2), round(NSMidY(bounds) - rep.pixelsHigh / 2), rep.pixelsWide, rep.pixelsHigh);
            [rowSlices addObject:[NSValue valueWithRect:bounds]];
            
            NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSInsetRect(bounds, -kStrokeSize * 2, -kStrokeSize * 2)];
            
            [rep drawInRect:bounds
                   fromRect:NSZeroRect
                  operation:NSCompositeSourceOver
                   fraction:1.0
             respectFlipped:NO
                      hints:nil];
            
            [path setLineWidth:2.0];
            [path setClip];
            [path stroke];
            
            currentX += itemWidth + kImagePadding;
            [NSGraphicsContext restoreGraphicsState];
        }
        currentY += itemHeight + kImagePadding;
        [slices addObject:rowSlices];
    }
    [NSGraphicsContext restoreGraphicsState];
    //!TODO: Do something with all of these applescript errors waiting to happen
    NSString *tempPath = [[[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"png"];
    
    [self.currentDocuments setObject:slices forKey:tempPath.lastPathComponent];
    [[rowImage representationUsingType:NSPNGFileType properties:nil] writeToFile:tempPath atomically:NO];
    
    NSString *ps = [[[[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to set appPath to name of application file id \"com.adobe.Photoshop\" "] executeAndReturnError:nil] stringValue];
    if (!ps) {
        NSLog(@"failed to get photoshop instance");
        return;
    }
    
    NSString *script = [NSString stringWithFormat:@"tell application \"%@\"\n\tset filePath to (POSIX file \"%@\") as string\n\topen file filePath\nend tell", ps, tempPath];
    [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
}

- (NSArray *)receiveImagesFromPhotoshop {
    NSDictionary *err = nil;
    NSString *ps = [[[[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to set appPath to name of application file id \"com.adobe.Photoshop\" "] executeAndReturnError:&err] stringValue];
    
    if (!ps || err.count) {
        NSLog(@"failed to get photoshop instance and got error: %@", err);
        return nil;
    }
    
    NSString *script = [NSString stringWithFormat:@"tell application \"%@\" to return the POSIX path of (file path of current document as alias)", ps];
    
    
    NSString *path = [[[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil] stringValue];
    
    if ([self.currentDocuments.allKeys containsObject:path.lastPathComponent]) {
        
        if ((err = [self exportDocumentToPath:path withPhotoshopInstance:ps])) {
            NSLog(@"failed to export photoshop document and got error: %@", err);
            return nil;
        }
            
        NSArray *slices = self.currentDocuments[path.lastPathComponent];
        NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithData:[NSData dataWithContentsOfFile:path]];
        CGImageRef image = imageRep.CGImage;
    
        NSMutableArray *images = [NSMutableArray array];
        
        for (NSArray *row in slices.reverseObjectEnumerator.allObjects) {
            for (NSValue *slice in row) {
                NSRect orig = slice.rectValue;
                NSRect flipped = NSMakeRect(NSMinX(orig), imageRep.pixelsHigh  - NSMaxY(orig), NSWidth(orig), NSHeight(orig));
                [images addObject:[[NSBitmapImageRep alloc] initWithCGImage:CGImageCreateWithImageInRect(image, flipped)]];
            }
        }
        
        return images;
    }
    
    NSString *tempPath = [[[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"png"];
    
    if ((err = [self exportDocumentToPath:tempPath withPhotoshopInstance:ps])) {
        NSLog(@"failed to export photoshop document and got error: %@", err);
        return nil;
    }
    
    return @[[[NSBitmapImageRep alloc] initWithData:[NSData dataWithContentsOfFile:tempPath]]];
}

- (NSDictionary *)exportDocumentToPath:(NSString *)path withPhotoshopInstance:(NSString *)ps {
    NSString *script = [NSString stringWithFormat:@"tell application \"%@\"\n\tset aDoc to current document\n\texport aDoc in file (\"%@\" as string) as save for web with options {class:save for web export options, web format:PNG, png eight: false}\nend tell", ps, path];
    
    NSDictionary *err = nil;
    [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:&err];
    
    return err;
}

@end
