//
//  TKBitmapRendition.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKRendition.h>
#import <ThemeKit/TKLayoutInformation.h>

@interface TKBitmapRendition : TKRendition {
    NSBitmapImageRep *_image;
}

@property (nonatomic, strong) NSBitmapImageRep *image;
@property (strong) TKLayoutInformation *layoutInformation;

+ (BOOL)shouldProcessPixels;
+ (void)setShouldProcessPixels:(BOOL)flag;

@end
