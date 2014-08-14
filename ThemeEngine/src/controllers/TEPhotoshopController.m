//
//  TEPhotoshopController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/14/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEPhotoshopController.h"
#import "Photoshop.h"
@import ScriptingBridge;

// Current documents is an array of dictionaries
// Dictionaries are in the following format:

// filepath – path
// images - [] – rectangular locations of all the images

// If the current photoshop document isn't in -currentDocuments, receiveImagesFromPhotoshop returns an array of one image,
// that being the entire image

@interface TEPhotoshopController ()
@property (strong) NSMutableDictionary *currentDocuments;
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
        for (NSBitmapImageRep *rep in bitmaps) {
            [NSGraphicsContext saveGraphicsState];
            NSRect bounds = NSMakeRect(currentX + kStrokeSize, currentY + kStrokeSize, itemWidth - kStrokeSize * 2, itemHeight - kStrokeSize * 2);
            bounds = NSMakeRect(NSMidX(bounds) - rep.pixelsWide / 2, NSMidY(bounds) - rep.pixelsHigh / 2, rep.pixelsWide, rep.pixelsHigh);
            [slices addObject:[NSValue valueWithRect:bounds]];
            
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
    }
    [NSGraphicsContext restoreGraphicsState];
    
    NSString *tempPath = [[[NSTemporaryDirectory() stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier] stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"png"];
    
    [self.currentDocuments setObject:slices forKey:tempPath];
    [[rowImage representationUsingType:NSPNGFileType properties:nil] writeToFile:tempPath atomically:NO];
}

- (NSArray *)receiveImagesFromPhotoshop {
    //!TODO: Actually get the current document path from photoshop
    NSString *path = self.currentDocuments.allKeys[0];
    NSArray *slices = self.currentDocuments[path];
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    CGImageRef image = imageRep.CGImage;
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSValue *slice in slices) {
        [images addObject:[[NSBitmapImageRep alloc] initWithCGImage:CGImageCreateWithImageInRect(image, slice.rectValue)]];
    }
    
    return images;
}

@end
