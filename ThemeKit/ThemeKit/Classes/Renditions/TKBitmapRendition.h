//
//  TKBitmapRendition.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <ThemeKit/TKRendition.h>

@interface TKBitmapRendition : TKRendition {
    NSBitmapImageRep *_image;
}
@property (nonatomic, strong) NSBitmapImageRep *image;
@end
