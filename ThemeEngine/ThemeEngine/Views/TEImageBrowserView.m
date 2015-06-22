//
//  TEImageBrowserView.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/15/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEImageBrowserView.h"
#import "TERenditionBrowserCell.h"
#import <objc/objc-auto.h>

@interface IKImageBrowserGridGroup : NSObject
- (BOOL)expanded;
- (BOOL)highlighted;
- (NSRange)range;
- (NSString *)title;
@end

@interface IKImageWrapper : NSObject
+ (id)imageWithPath:(id)arg1;
- (struct CGSize)size;;
@end

@interface IKOpenGLRenderer : NSObject
- (void)drawImage:(id)arg1 inRect:(struct CGRect)arg2 fromRect:(struct CGRect)arg3 alpha:(float)arg4;
- (void)setColorRed:(float)arg1 Green:(float)arg2 Blue:(float)arg3 Alpha:(float)arg4;
- (void)fillRect:(struct CGRect)arg1;
- (void)drawText:(id)arg1 inRect:(struct CGRect)arg2 withAttributes:(id)arg3 withAlpha:(float)arg4;
- (void)fillRoundedRect:(struct CGRect)arg1 radius:(float)arg2 cacheIt:(BOOL)arg3;
- (void)flushRenderer;
- (void)emptyCaches;
@end

@interface NSView (Private)
- (void)_viewDidChangeAppearance:(id)arg1;
- (void)setClickableArea:(struct CGRect)arg1 target:(id)arg2 selector:(SEL)arg3 info:(id)arg4;
- (void)drawDisclosureGroupHeader:(id)arg1 inRect:(struct CGRect)arg2;
- (id)renderer;
- (void)_expandButtonClicked:(id)arg1;
- (BOOL)_groupIsSelected:(id)arg1;
@end

@interface TEImageBrowserView ()
@property (strong) NSArray *lightIndicators;
@property (strong) NSArray *darkIndicators;
@property (strong) NSColor *selectionColor;
@property (weak) NSArray *currentIndicators;
@end

static NSMutableDictionary *titleAttributes;
static NSMutableDictionary *bezelAttributes;

@implementation TEImageBrowserView

- (void)drawDisclosureGroupHeader:(IKImageBrowserGridGroup *)arg1 inRect:(struct CGRect)arg2 {
//    [super drawDisclosureGroupHeader:arg1 inRect:arg2];
    
    // draw the background
    IKOpenGLRenderer *renderer = [self renderer];
    if ([self _groupIsSelected:arg1]) {
        NSColor *select = [self.selectionColor colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        [renderer setColorRed:select.redComponent Green:select.greenComponent Blue:select.blueComponent Alpha:select.alphaComponent];
    } else {
        NSColor *gray = [[[NSColor grayColor] colorWithAlphaComponent:0.3] colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        [renderer setColorRed:gray.redComponent Green:gray.greenComponent Blue:gray.blueComponent Alpha:gray.alphaComponent];
    }
    
    [renderer fillRect:arg2];
    
    NSUInteger idx = -1;
    if (!arg1.highlighted) {
        idx = arg1.expanded ? 2 : 0;
    } else {
        idx = 1;
    }
    
    IKImageWrapper *wrap = self.currentIndicators[idx];
    
    // draw the dislosure indicator
    CGRect disclosureRect = arg2;
    disclosureRect.origin.x += 15;
    disclosureRect.size = wrap.size;
    disclosureRect.origin.y = round(NSMidY(disclosureRect) + disclosureRect.size.height / 2 - 2.0);
    
    [renderer drawImage:wrap
                 inRect:disclosureRect
               fromRect:NSZeroRect
                  alpha:1.0];
    
    [self setClickableArea:disclosureRect
                    target:self
                  selector:@selector(_expandButtonClicked:)
                      info:@{ @"rect": [NSValue valueWithRect:disclosureRect], @"group": arg1  }];
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titleAttributes                                = [NSMutableDictionary dictionary];
        titleAttributes[NSFontAttributeName]           = [NSFont boldSystemFontOfSize:12.0];
        NSMutableParagraphStyle *pg                    = [[NSMutableParagraphStyle alloc] init];
        pg.lineBreakMode                               = NSLineBreakByTruncatingTail;
        pg.alignment                                   = NSTextAlignmentLeft;
        pg.baseWritingDirection                        = NSWritingDirectionNatural;
        titleAttributes[NSParagraphStyleAttributeName] = pg;

        bezelAttributes                                = [NSMutableDictionary dictionary];
        bezelAttributes[NSParagraphStyleAttributeName] = pg;
        bezelAttributes[NSFontAttributeName]           = [NSFont boldSystemFontOfSize:10.0];
    });
    
    [titleAttributes setObject:[NSColor controlTextColor] forKey:NSForegroundColorAttributeName];
    [bezelAttributes setObject:[NSColor controlTextColor] forKey:NSForegroundColorAttributeName];
    
    
    // draw the bezel
    NSString *bezelCount = [NSString stringWithFormat:@"%lu", (unsigned long)arg1.range.length];
    NSSize size = [bezelCount sizeWithAttributes:bezelAttributes];
    NSRect bezelRect = NSZeroRect;
    bezelRect.size = size;
    bezelRect.size.height += 4.0;
    bezelRect.size.width += 10.0;
    bezelRect.origin.x = NSMaxX(arg2) - 20.0 - bezelRect.size.width;
    bezelRect.origin.y = arg2.origin.y;
    bezelRect.origin.y = NSMidY(bezelRect) - 2.0;
    bezelRect = NSIntegralRect(bezelRect);
    
    NSColor *bezelColor = [[[NSColor blackColor] colorWithAlphaComponent:0.1] colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    [renderer setColorRed:bezelColor.redComponent Green:bezelColor.greenComponent Blue:bezelColor.blueComponent Alpha:bezelColor.alphaComponent];
    [renderer fillRoundedRect:bezelRect radius:4.0 cacheIt:YES];
    

    bezelRect.origin.x += 5;
    bezelRect.origin.y += 2;
    bezelRect.size = size;
    [renderer drawText:bezelCount
                inRect:bezelRect
        withAttributes:bezelAttributes
             withAlpha:1.0];
    
    // draw the title
    CGRect titleRect = disclosureRect;
    
    size = [arg1.title sizeWithAttributes:titleAttributes];
    titleRect.size = size;
    titleRect.origin.x = NSMaxX(disclosureRect) + 8.0;
    titleRect.origin.y = NSMidY(titleRect) - titleRect.size.height / 2 - 2.0;

    // limit title width
    if (NSMaxX(titleRect) >= NSMinX(bezelRect) - 20.0) {
        titleRect.size.width -= (NSMaxX(titleRect) - NSMinX(bezelRect)) + 20.0;
    }
    

    [renderer drawText:arg1.title
                inRect:titleRect
        withAttributes:titleAttributes
             withAlpha:1.0];

}

- (void)_viewDidChangeAppearance:(id)arg1 {
    NSBundle *bndl = [NSBundle bundleForClass:[IKImageBrowserCell class]];
    if (!self.lightIndicators) {
        NSString *openPath = [bndl pathForResource:@"ik-disclosure-open-inv" ofType:@"pdf"];
        NSString *closedPath = [bndl pathForResource:@"ik-disclosure-closed-inv" ofType:@"pdf"];
        NSString *clickedPath = [bndl pathForResource:@"ik-disclosure-clicked-inv" ofType:@"pdf"];
        
        self.lightIndicators = @[
                                 [IKImageWrapper imageWithPath:closedPath],
                                 [IKImageWrapper imageWithPath:clickedPath],
                                 [IKImageWrapper imageWithPath:openPath]
                                 ];
        
    }
    
    if (!self.darkIndicators) {
        NSString *openPath = [bndl pathForResource:@"ik-disclosure-open" ofType:@"pdf"];
        NSString *closedPath = [bndl pathForResource:@"ik-disclosure-closed" ofType:@"pdf"];
        NSString *clickedPath = [bndl pathForResource:@"ik-disclosure-clicked" ofType:@"pdf"];
        
        self.darkIndicators = @[
                                [IKImageWrapper imageWithPath:closedPath],
                                [IKImageWrapper imageWithPath:clickedPath],
                                [IKImageWrapper imageWithPath:openPath]
                                ];
    }
    
    if ([[[NSAppearance currentAppearance] name] isEqualToString:NSAppearanceNameVibrantDark]) {
        [self setValue:[NSColor windowBackgroundColor] forKey:IKImageBrowserBackgroundColorKey];
        self.enclosingScrollView.backgroundColor = [NSColor windowBackgroundColor];
        [self setValue:@{ NSForegroundColorAttributeName: [NSColor controlTextColor] } forKey:IKImageBrowserCellsTitleAttributesKey];
        self.currentIndicators = self.lightIndicators;
        self.selectionColor = [NSColor selectedMenuItemColor];
        
    } else {
        self.selectionColor = [NSColor selectedControlColor];
        self.enclosingScrollView.backgroundColor = [NSColor whiteColor];
        [self setValue:[NSColor whiteColor] forKey:IKImageBrowserBackgroundColorKey];

        // .737255, 0.705882, 0.643137, 0.870588
        [self setValue:@{ NSForegroundColorAttributeName: [NSColor colorWithDeviceCyan:0.737255
                                                                               magenta:0.705882
                                                                                yellow:0.643137
                                                                                 black:0.870588
                                                                                 alpha:1.0] } forKey:IKImageBrowserCellsTitleAttributesKey];
        self.currentIndicators = self.darkIndicators;
    }
    
    [self.renderer emptyCaches];
    [self.renderer flushRenderer];
    [super _viewDidChangeAppearance: arg1];
}

- (void)layout {
    [super layout];
}

- (IKImageBrowserCell *)newCellForRepresentedItem:(id)anItem {
    TERenditionBrowserCell *browserCell = [[TERenditionBrowserCell alloc] init];
    return browserCell;
}

- (void)reloadData {
    [super reloadData];
    self.enclosingScrollView.contentInsets = self.enclosingScrollView.contentInsets;
}

@end
