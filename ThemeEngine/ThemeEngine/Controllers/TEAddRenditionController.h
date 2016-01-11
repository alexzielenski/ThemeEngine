//
//  TEAddRenditionController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 7/25/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ThemeKit/ThemeKit.h>

@interface TEAddRenditionController : NSWindowController
@property (strong) NSArray<TKElement *> *elements;
- (void)beginWithWindow:(NSWindow *)window completionHandler:(void (^)(TKRendition *rendition))handler;
@end
