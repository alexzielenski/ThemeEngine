//
//  main.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFElementStore.h"

void CGImageWriteToFile(CGImageRef image, NSString *path)
{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *path = @(argv[1]);
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/SystemAppearance.car copy" toPath:path error:nil];
        
        CFElementStore *store = [CFElementStore storeWithPath:path];
        
        /**
         Example showing how to change a gradient image within a store. This will change all window active gradients to a disgusting red-green
         */
        CFElement *element = [store elementWithName:@"WindowFrame_Background_Active"];
        for (CFAsset *asset in [element assetsWithType:kCoreThemeTypeGradient]) {
            CUIPSDGradient *gradient = [CUIPSDGradient cuiPSDGradientWithColors:@[ (__bridge id)CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0), (__bridge id)CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0) ]
                                                                      locations:@[ @0, @1]
                                                              midpointLocations:@[ ]
                                                                          angle:270
                                                                       isRadial:NO];
            asset.gradient = gradient;
        }
        
        /**
         // This example shows how to manipulate an element represented by an image
         // it gets all sizes, states of the title bar controls on windows and turns it into
         // a nasty blue to match our titlebar
         */
        element = [store elementWithName:@"WindowFrame_WindowControlButtons"];
        for (CFAsset *asset in element.assets) {
            NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                            pixelsWide:CGImageGetWidth(asset.image)
                                                                            pixelsHigh:CGImageGetHeight(asset.image)
                                                                         bitsPerSample:8
                                                                       samplesPerPixel:4
                                                                              hasAlpha:YES
                                                                              isPlanar:NO
                                                                        colorSpaceName:NSDeviceRGBColorSpace
                                                                           bytesPerRow:4 * CGImageGetWidth(asset.image)
                                                                          bitsPerPixel:32];
            NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:ctx];
            [[NSColor blueColor] set];
            NSRectFill(NSMakeRect(0, 0, rep.pixelsWide, rep.pixelsHigh));
            [ctx setCompositingOperation:NSCompositeDestinationIn];
            CGContextDrawImage(ctx.graphicsPort, NSMakeRect(0, 0, rep.pixelsWide, rep.pixelsHigh), asset.image);
            
            [NSGraphicsContext restoreGraphicsState];
            
            asset.image = rep.CGImage;
        }
        
        /**
         // To top off our disgusting theme the example below demonstrates how to create a shape effect
         // By making menu bar images that use apple's templating turn yellow (currently I only see it on the apple logo with opaque menubar)
         */
        element = [store elementWithName:@"Menubar Image"];
        for (CFAsset *asset in element.assets) {
            CUIShapeEffectPreset *preset = [[CUIShapeEffectPreset alloc] init];
            [preset addColorFillWithRed:255
                                  green:255
                                   blue:0
                                opacity:1.0
                              blendMode:kCGBlendModeNormal];
            asset.effectPreset = preset;
        }
        
        /**
         // Example to show to how to change a named text color. This makes the rim around a window black
         // You can find names for colors by opening the car in a hex editor, scrolling down and looking for
         // the strings
         */
        struct _rgbquad rgb;
        rgb.r = 0;
        rgb.g = 0;
        rgb.b = 0;
        rgb.a = 255;
        [(CUIMutableCommonAssetStorage *)store.assetStorage setColor:rgb forName:"CUIWindowRimColor" excludeFromFilter:NO];
        
//        for (CFAsset *asset in store.allAssets) {
//            if (asset.image != NULL)
//                CGImageWriteToFile(asset.image, [@"/Users/Alex/Desktop/dump2" stringByAppendingPathComponent:asset.name]);
//        }
        
        [store save];
    }
    return 0;
}
