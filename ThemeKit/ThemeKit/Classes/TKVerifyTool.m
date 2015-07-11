//
//  TKVerifyTool.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 7/11/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKVerifyTool.h"

static NSInteger sliceSort(NSValue *first, NSValue *second, void *context) {
    NSRect r1 = first.rectValue;
    NSRect r2 = second.rectValue;
    
    // Sort primarily by x value
    // if x is equal, sort by y
    if (r1.origin.x > r2.origin.x)
        return NSOrderedDescending;
    else if (r1.origin.x < r2.origin.x)
        return NSOrderedAscending;
    
    if (r1.origin.y > r2.origin.y)
        return NSOrderedDescending;
    else if (r1.origin.y < r2.origin.y)
        return NSOrderedAscending;
    
    return NSOrderedSame;
}

@implementation TKVerifyTool

+ (CUIThemeRendition *)fixedRenditionForCSIData:(NSData *)csiData key:(CUIRenditionKey *)key outName:(NSString **)name {
    NSMutableData *data = csiData.mutableCopy;
    
    // Get the info list
    struct csiheader *header = (struct csiheader *)data.bytes;

    if (name != NULL)
        *name = @(header->metadata.name);
    
    struct metric size = {
        .width  = header->width,
        .height = header->height
    };
    
    void *ptr = data.mutableBytes;
    // skip the header to the info
    ptr += sizeof(struct csiheader);
    // enumerate while inside the info list
    void *end = (uint8_t *)ptr + header->infolistLength;

    while (ptr < end) {
        struct csi_info_header *info = ptr;
        if (info->magic == CSIInfoMagicSlices) {
            struct csi_slice_info *slice_info = (struct csi_slice_info *)info;
            [self correctSliceRects:((void *)slice_info + offsetof(struct csi_slice_info, slices))
                             layout:header->metadata.layout != CoreThemeLayoutInternalLink ? header->metadata.layout : key.themeSubtype
                              count:slice_info->nslices
                            forSize:size];
            
        } else if (info->magic == CSIInfoMagicMetrics) {
            struct csi_metric_info *metric_info = (struct csi_metric_info *)info;
            [self correctMetrics:metric_info forSize:size];
        }
        
        ptr = (uint8_t *)ptr + info->length + sizeof(info);
    }
    
    return [[TKClass(CUIThemeRendition) alloc] initWithCSIData:data forKey:key.keyList];
}

+ (void)correctSliceRects:(struct slice *)sliceRects layout:(CoreThemeLayout)layout count:(NSInteger)count forSize:(struct metric)imageSize {
    if (count < 1)
        return;
    
    // We have to loop because we can't assume that the slices are sorted in a broken image
    CoreThemeType type;
    
    if ((layout >= CoreThemeLayoutOnePartFixedSize && layout < CoreThemeLayoutThreePartHScale) ||
        layout == CoreThemeLayoutAnimationFilmstrip) {
        // We can repair right here
        sliceRects[0].width = MIN(sliceRects[0].width, imageSize.width);
        sliceRects[0].height = imageSize.height;
        
        return;
        
    } else if (layout >= CoreThemeLayoutThreePartHScale && layout < CoreThemeLayoutThreePartVTile) { // threepart horizontal
        type = CoreThemeTypeThreePartHorizontal;
        
    } else if (layout >= CoreThemeLayoutThreePartVTile && layout < CoreThemeLayoutNinePartTile) { // threepart vertical
        type = CoreThemeTypeThreePartVertical;
        
    } else if (layout >= CoreThemeLayoutNinePartTile && layout < CoreThemeLayoutSixPart) {
        type = CoreThemeTypeNinePart;
    } else {
        NSLog(@"Cannot repair slices. Unsupported type: %u", layout);
        return;
    }
    
    NSMutableArray *sorted = [NSMutableArray array];
    for (int x = 0; x < count; x++) {
        struct slice slice = sliceRects[x];
        [sorted addObject:[NSValue valueWithRect:NSMakeRect(slice.x, slice.y, slice.width, slice.height)]];
    }
    
    [sorted sortUsingFunction:sliceSort
                      context:NULL];
    
    // Now we can generate insets, validate them
    NSEdgeInsets insets = TKInsetsFromSliceRects(sorted, type);
    
    // validate
    insets.left   = MAX(MIN(round(insets.left), imageSize.width - insets.right - 1.0), 0);
    insets.top    = MAX(MIN(round(insets.top), imageSize.height - insets.bottom - 1.0), 0);
    insets.right  = MAX(MIN(round(insets.right), imageSize.width - insets.left - 1.0), 0);
    insets.bottom = MAX(MIN(round(insets.bottom), imageSize.height - insets.top - 1.0), 0);

    // then generate rects
    NSArray <NSValue *> *slices = [TKSlicesFromInsets(insets, NSMakeSize(imageSize.width, imageSize.height), type) sortedArrayUsingFunction:sliceSort context:NULL];
    for (NSInteger x = 0; x < count; x++) {
        struct slice slice;
        NSRect rectValue = slices[x].rectValue;
        slice.x = rectValue.origin.x;
        slice.y = rectValue.origin.y;
        slice.width = rectValue.size.width;
        slice.height = rectValue.size.height;
        
        sliceRects[x] = slice;
    }
}

+ (void)correctMetrics:(struct csi_metric_info *)info forSize:(struct metric)imageSize {
    info->image_size = imageSize;
    info->top_right_inset.width = info->top_right_inset.width > imageSize.width - 1 ? 0 : info->top_right_inset.width;
    info->top_right_inset.height = info->top_right_inset.height > imageSize.height - 1 ? 0 : info->top_right_inset.height;
    
    info->bottom_left_inset.width = MIN(info->bottom_left_inset.width, imageSize.width - info->top_right_inset.width - 1);
    info->bottom_left_inset.height = MIN(info->bottom_left_inset.height, imageSize.height - info->top_right_inset.height - 1);
}

@end
