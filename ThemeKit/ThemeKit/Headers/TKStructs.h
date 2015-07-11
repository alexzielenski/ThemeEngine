//
//  TKStructs.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#ifndef TKStructs_h
#define TKStructs_h

/* CSI Format
 csi_header (above)
 
 list of metadata
 
 MAGIC VALUES
 for csi_info in a list
 
 defined as CSIInfoMagic
 
 0xE903 - 1001: Slice rects, First 4 bytes length, next num slices rects, next a list of the slice rects
 0xEB03 - 1003: Metrics – First 4 length (including num metrics), next 4 num metrics, next a list of metrics (struct of 3 CGSizes)
 0xEC03 - 1004: Composition - First 4 length, second is the blendmode, third is a float for opacity
 0xED03 - 1005: UTI Type, First 4 length, next 4 length of string, then the string
 0xEE03 - 1006: Image Metadata: First 4 length, next 4 EXIF orientation, (UTI type...?)
 0xEF03 - 1007: Bytes Per Row: first 4 length, next for BPR for bitmaps
 0xF203 - 1010: Internal Reference – First 4 length, next 4 reference magic 'INKL', next is variable
 0xF303 - 1011: Alpha Cropped Frame
 
 GRADIENT format documented in TKGradient.h
 SHAPE EFFECT format documented in CUIShapeEffectPreset.h
 
 IMAGES: 'CELM' – Core Element – Header followed by Zipped up raw image data, format coming soon
 RAW DATA: marts 'RAWD' followed by 4 bytes of zero and an unsigned int of the length of the raw data
 INTERNAL LINK: 'INKL' –
 OFFSET   SIZE   DESCRIPTION
 0        4      Magic
 4        4      Padding. Always zero
 8        16     Destination Frame
 24       2      Layout (Would usually go in the layout field of the csiheader if it wasnt a reference)
 26       4      Length of Reference Key
 30       X      Rendition Reference Key List
 
 Reference key being the key of the asset whose pixel data contains this image
 */

// CSI Stands for Core Structured Image
struct csiheader {
    unsigned int magic; // CTSI – Core Theme Structured Image
    unsigned int version; // current known version is 1
    struct {
        unsigned int isHeaderFlaggedFPO:1;
        unsigned int isExcludedFromContrastFilter:1;
        unsigned int isVectorBased:1;
        unsigned int isOpaque:1;
        unsigned int reserved:28;
    } renditionFlags;
    unsigned int width;
    unsigned int height;
    unsigned int scaleFactor; // scale * 100. 100 is 1x, 200 is 2x, etc.
    unsigned int pixelFormat; // 'ARGB' ('BGRA' in little endian), if it is 0x47413820 (GA8) then the colorspace will be gray or 'PDF ' if a pdf
    unsigned int colorspaceID:4; // colorspace ID. 0 for sRGB, all else for generic rgb, used only if pixelFormat 'ARGB'
    unsigned int reserved:28;
    struct _csimetadata {
        unsigned int modDate;  // modification date in seconds since 1970?
        unsigned short layout; // layout/type of the renditoin
        unsigned short reserved; // always zero
        char name[128];
    } metadata;
    unsigned int infolistLength; // size of the list of information after header but before bitmap
    struct _csibitmaplist {
        unsigned int bitmapCount;
        unsigned int reserved;
        unsigned int payloadSize; // size of all the proceeding information listLength + data
    } bitmaps;
};

struct slice {
    unsigned int x;
    unsigned int y;
    unsigned int width;
    unsigned int height;
};

struct metric {
    unsigned int width;
    unsigned int height;
};

struct csi_info_header {
    unsigned int magic;
    unsigned int length;
};

struct csi_slice_info {
    unsigned int magic;
    unsigned int length;
    unsigned int nslices;
    struct slice slices[0];
};

struct csi_metric_info {
    unsigned int magic;
    unsigned int length;
    unsigned int nmetrics;
    struct metric top_right_inset;
    struct metric bottom_left_inset;
    struct metric image_size;
};

typedef NS_ENUM(uint32_t, CSIInfoMagic) {
    CSIInfoMagicSlices = 1001,
    CSIInfoMagicMetrics = 1003,
    CSIInfoMagicComposition = 1004,
    CSIInfoMagicUTI = 1005,
    CSIInfoMagicBitmapInfo = 1006,
    CSIInfoMagicReference = 1010
};

typedef struct {
    CGSize edgeTR;
    CGSize edgeBL;
    CGSize imageSize;
} CUIMetrics;

typedef struct {
    
} CUISlices;

#pragma mark - Colors

// I thin it was RGBA in the old car files?
struct rgbquad {
    uint8_t b;
    uint8_t g;
    uint8_t r;
    uint8_t a;
};

struct colorkey {
    unsigned int reserved;
    char name[128];
};

struct colordef {
    unsigned int version; // excluded from filter?
    unsigned int reserved;
    struct rgbquad value;
};

#pragma mark - Renditions

struct renditionkeyfmt {
    unsigned int magic; // 'kfmt'
    unsigned int reserved;
    unsigned int num_identifiers;
    unsigned int identifier_list[0];
};

struct renditionkeytoken {
    unsigned short identifier;
    unsigned short value;
};

struct facet_key {
    const char *facet_name;
};

struct facet_value {
    struct {
        short x;
        short y;
    } hot_spot;
    
    // list of tokens with a length of sizeof(renditionkeytoken) * keyfmt.num_identifiers
    struct renditionkeytoken tokens[];
};

#pragma mark - Types

//!TODO document this
struct csibitmap {
    unsigned int _field1; // magic?
    union {
        unsigned int _field1;
        struct _csibitmapflags {
            unsigned int :1;
            unsigned int :1;
            unsigned int :30;
        } flags;
    } _field2;
    unsigned int _field3;
    unsigned int _field4;
    unsigned char data[0];
};


//!TODO Document this
struct cuieffectdata {
    unsigned int _field1;
    unsigned int _field2;
    unsigned int _field3;
    unsigned int num_effects;
    struct _cuieffectlist {
        unsigned int _field1;
        unsigned int _field2[0];
    } _field5;
};

struct _psdGradientColor {
    double red;
    double green;
    double blue;
    double alpha;
};

#endif /* TKStructs_h */
