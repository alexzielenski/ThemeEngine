//
//  TKLayoutInformation+Private.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKLayoutInformation.h"
#import <CoreUI/Metadata/CUIRenditionMetrics.h>
#import <CoreUI/Metadata/CUIRenditionSliceInformation.h>

@interface TKLayoutInformation ()

+ (instancetype)layoutInformationWithCSIData:(NSData *)csiData;
- (instancetype)initWithCSIData:(NSData *)csiData;
@end