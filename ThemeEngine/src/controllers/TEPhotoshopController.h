//
//  TEPhotoshopController.h
//  carFileTool
//
//  Created by Alexander Zielenski on 8/14/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEPhotoshopController : NSObject

+ (instancetype)sharedPhotoshopController;

- (void)sendImagesToPhotoshop:(NSArray *)images withLayout:(NSIndexSet *)layout dimensions:(NSSize)dimensions;
- (NSArray *)receiveImagesFromPhotoshop;

@end
