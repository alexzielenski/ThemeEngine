//
//  TELayerEffectsViewController.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/15/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TELayerEffectsViewController.h"
@import QuartzCore.CATransaction;

@interface TELayerEffectsViewController ()
@property (assign) NSUInteger addIndex;
- (void)addAction:(NSButton *)sender;
- (void)removeAction:(NSButton *)sender;
@end

@implementation TELayerEffectsViewController
@dynamic canEditAngle, canEditBlendMode, canEditBlurRadius, canEditColor1, canEditColor2, canEditOffset, canEditOpacity1, canEditOpacity2, canEditSoften, canEditSpread;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"EffectsColumn"];
    column.resizingMask = NSTableColumnAutoresizingMask;
    column.width = 300;
    column.minWidth = column.width;
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    self.tableView.backgroundColor = [NSColor clearColor];
    self.tableView.floatsGroupRows = NO;
    self.tableView.focusRingType = NSFocusRingTypeNone;
    self.tableView.columnAutoresizingStyle = NSTableViewFirstColumnOnlyAutoresizingStyle;
    //    self.effectTableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleGap;
    [self.tableView addTableColumn:column];
    
    [self addObserver:self forKeyPath:@"effectWrapper" options:0 context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"effectWrapper"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"effectWrapper"]) {
        self.currentEffect = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Properties

- (BOOL)canEditAngle {
    switch (self.currentEffect.type) {
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditBlendMode {
    switch (self.currentEffect.type) {
        case CUIEffectTypeColorFill:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditBlurRadius {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditColor1 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeColorFill:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeGradient:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditColor2 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeGradient:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOffset {
    switch (self.currentEffect.type) {
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOpacity1 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeDropShadow:
        case CUIEffectTypeExtraShadow:
        case CUIEffectTypeColorFill:
        case CUIEffectTypeGradient:
        case CUIEffectTypeInnerGlow:
        case CUIEffectTypeInnerShadow:
        case CUIEffectTypeOuterGlow:
        case CUIEffectTypeOutputOpacity:
        case CUIEffectTypeShapeOpacity:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditOpacity2 {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditSoften {
    switch (self.currentEffect.type) {
        case CUIEffectTypeBevelAndEmboss:
        case CUIEffectTypeInnerShadow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)canEditSpread {
    switch (self.currentEffect.type) {
        case CUIEffectTypeOuterGlow:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key hasPrefix:@"canEdit"]) {
        return [NSSet setWithObject:@"currentEffect.type"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

- (void)addAction:(NSButton *)sender {
    self.addIndex = [self.tableView rowForView:sender];
    [self.addMenu popUpMenuPositioningItem:nil
                                atLocation:NSMakePoint(NSMaxX(sender.bounds), sender.bounds.size.height)
                                    inView:sender];
}

- (void)removeAction:(NSButton *)sender {
    NSInteger idx = [self.tableView rowForView:sender];
    [self.effectWrapper removeEffectAtIndex:idx];
    if (self.effectWrapper.effects.count > 0)
        [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx] withAnimation:NSTableViewAnimationEffectGap];
    else
        [self.tableView reloadData];
    NSRect f = self.tableView.frame;
    f.size.height -= self.tableView.rowHeight + self.tableView.intercellSpacing.height;
    f.size.height = MAX(self.tableView.rowHeight, f.size.height);
    self.tableView.frame = f;
}

- (IBAction)addSelection:(NSMenuItem *)sender {
    NSUInteger idx = self.addIndex;
    [self.effectWrapper insertEffect:[CFTEffect effectWithType:(CUIEffectType)sender.tag] atIndex:idx];
    NSRect f = self.tableView.frame;
    f.size.height = (self.tableView.rowHeight + self.tableView.intercellSpacing.height) * (self.tableView.numberOfRows + (self.effectWrapper.effects.count > 1 ? 1 : 0));
    self.tableView.frame = f;
    if (self.effectWrapper.effects.count > 1)
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:idx]
                              withAnimation:NSTableViewAnimationSlideDown];
    else {
        [self.tableView reloadData];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.effectWrapper.effects.count ?: 1;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [[NSTableCellView alloc] initWithFrame:NSMakeRect(4, 0, tableView.frame.size.width, 18)];
    CFTEffect *effect = nil;
    if (self.effectWrapper.effects.count > 0)
        effect = (CFTEffect *)self.effectWrapper.effects[row];
    CUIEffectType type = effect.type;
    cellView.wantsLayer = YES;
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, cellView.frame.size.width, 18)];
    textField.wantsLayer = YES;
    textField.bordered = NO;
    textField.selectable = NO;
    textField.drawsBackground = NO;
    [cellView addSubview:textField];
    
    if (self.effectWrapper.effects.count == 0)
        textField.stringValue = @"No items to show";
    else
        textField.stringValue = CUIEffectTypeToString(type);
    
    
    
    cellView.textField = textField;
    cellView.identifier = [@(type) stringValue];

#define kButtonSize 9.0
    NSButton *addButton = [[NSButton alloc] initWithFrame:NSMakeRect(NSMaxX(cellView.frame) - kButtonSize - 20, NSMidY(cellView.frame) - kButtonSize / 2, kButtonSize, kButtonSize)];
    addButton.target = self;
    addButton.action = @selector(addAction:);
    addButton.bezelStyle = NSRegularSquareBezelStyle;
    addButton.bordered = NO;
    addButton.image = [NSImage imageNamed:@"NSAddTemplate"];
    [cellView addSubview:addButton];
    
    NSButton *removeButton = [[NSButton alloc] initWithFrame:NSMakeRect(NSMinX(addButton.frame) - kButtonSize - 8, NSMinY(addButton.frame), kButtonSize, kButtonSize)];
    removeButton.target = self;
    removeButton.action = @selector(removeAction:);
    removeButton.bezelStyle = NSRegularSquareBezelStyle;
    removeButton.bordered = NO;
    removeButton.image = [NSImage imageNamed:@"NSRemoveTemplate"];
    [cellView addSubview:removeButton];
    
    
    return cellView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return self.effectWrapper.effects.count > 0;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (self.tableView.selectedRow != -1)
        self.currentEffect = self.effectWrapper.effects[self.tableView.selectedRow];
    else
        self.currentEffect = nil;
}

#define kTEDetailType @"asdasdasd"

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard setPropertyList:@[ @(rowIndexes.firstIndex) ] forType:kTEDetailType];
    [aTableView registerForDraggedTypes:@[kTEDetailType]];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
    if (info.draggingSource == self.tableView && operation == NSTableViewDropAbove)
        return NSDragOperationMove;
    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    if (info.draggingSource != self.tableView)
        return NO;
    NSUInteger originalRow = [[[info.draggingPasteboard propertyListForType:kTEDetailType] firstObject] unsignedIntegerValue];
    [self.effectWrapper moveEffectAtIndex:originalRow toIndex:row];
    [aTableView moveRowAtIndex:originalRow toIndex:row];
    return YES;
}

@end
