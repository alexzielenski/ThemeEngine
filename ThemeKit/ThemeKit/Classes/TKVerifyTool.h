//
//  TKVerifyTool.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 7/11/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreUI/CUIThemeRendition.h>


@interface TKVerifyTool : NSObject

+ (CUIThemeRendition *)fixedRenditionForCSIData:(NSData *)csiData key:(CUIRenditionKey *)key outName:(NSString **)name;
+ (void)correctSliceRects:(struct slice *)sliceRects layout:(CoreThemeLayout)layout count:(NSInteger)count forSize:(struct metric)imageSize;
+ (void)correctMetrics:(struct csi_metric_info *)info forSize:(struct metric)imageSize;

@end
