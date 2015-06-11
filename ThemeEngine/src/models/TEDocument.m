//
//  CHDocument.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "TEDocument.h"

@interface TEDocument ()
@property (readwrite, strong) CFTElementStore *elementStore;
@property (readwrite, strong) NSArray *sortDescriptors;
@end

@implementation TEDocument

- (id)init  {
    if ((self = [super init])) {
        self.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] ];
        
    }
    return self;
}

- (NSString *)windowNibName {
    return @"TEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    [self.elementContentView addSubview:self.elementViewController.view];
    self.elementViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSView *elements = self.elementViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(elements);
    [self.elementContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[elements]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [self.elementContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[elements]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    
    self.elementViewController.elementStore = self.elementStore;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager isWritableFileAtPath:url.path.stringByDeletingLastPathComponent]) {
        BOOL success = [self.elementStore save];
        if (![self.elementStore.path isEqualToString:url.path] && success) {
            return [manager copyItemAtPath:self.elementStore.path toPath:url.path error:outError];
        }
        
        return success;
    } else {
        *outError = [NSError errorWithDomain:@"com.alexzielenski.themeengine.errordomain" code:0 userInfo:@{ NSLocalizedDescriptionKey: @"Insufficient privileges" }];
        return NO;
    }
    
    return YES;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *tempPath = [[[NSTemporaryDirectory() stringByAppendingPathComponent:[NSBundle.mainBundle bundleIdentifier]] stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"car"];
    
    if (![manager createDirectoryAtPath:tempPath.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:outError]) {
        return NO;
    }
    
    if (![[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:tempPath] error:outError]) {
        return NO;
    }
    
    self.elementStore = [CFTElementStore storeWithPath:tempPath];
    self.undoManager = self.elementStore.undoManager;
    return YES;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

- (void)dealloc {
    // remove temporary storage
    if ([self.elementStore.path hasPrefix:NSTemporaryDirectory()])
        [[NSFileManager defaultManager] removeItemAtPath:self.elementStore.path error:nil];
}

#pragma mark - actions

- (IBAction)addColor:(id)sender {
    static NSMenu *colorMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorMenu = [[NSMenu alloc] init];
        NSDictionary *colors = [NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"colors" ofType:@"plist"]];
        NSArray *keys = [colors.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        for (NSString *key in keys) {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:colors[key] action:NULL keyEquivalent:@""];
            item.representedObject = key;
            [colorMenu addItem:item];
        }
    });
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Choose a color:";
    [alert addButtonWithTitle:@"Done"];
    [alert addButtonWithTitle:@"Cancel"];
    NSPopUpButton *popUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 250, 22)];
    popUp.menu = colorMenu;
    alert.accessoryView = popUp;
    
    [alert beginSheetModalForWindow:[self.windowControllers[0] window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1000) {
            NSString *name = popUp.selectedItem.representedObject;
            CFTElement *element = [self.elementStore elementWithName:@"Colors"];
            if (![[element.assets valueForKeyPath:@"name"] containsObject:name]) {
                CFTAsset *asset = [CFTAsset assetWithColor:[NSColor performSelector:NSSelectorFromString(name)] name:name storage:self.elementStore.assetStorage];
                [self.elementStore addAsset:asset];
            }
        }
    }];
}

- (IBAction)export:(NSMenuItem *)sender {
    // Exports all the assets in the current document to a folder structure
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.title = @"Export";
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    panel.resolvesAliases = YES;
    panel.canCreateDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    if (panel.runModal != NSFileHandlingPanelOKButton) {
        NSLog(@"Export panel cancelled");
        return;
    }
    
    NSURL *url = panel.URL;
    
    NSUInteger writes = 0;
    NSSet *allAssets = self.elementStore.allAssets;
    
    for (CFTAsset *asset in allAssets) {
        // only way to get a unique name
        NSString *name = [asset.name stringByAppendingFormat:@".%@.%@.%@.%@.%@.%@.%@.%@.%@.%lld.%lld%lld%lld.%lld%lld.%@",
                          CoreThemeLayerToString(asset.key.themeLayer),
                          CoreThemeIdiomToString(asset.key.themeIdiom),
                          CoreThemeSizeToString(asset.key.themeSize),
                          CoreThemeValueToString(asset.key.themeValue),
                          CoreThemeDirectionToString(asset.key.themeDirection),
                          CoreThemeStateToString(asset.key.themeState),
                          CoreThemePresentationStateToString(asset.key.themePresentationState),
                          CoreThemeLayoutToString(asset.layout),
                          CoreThemeTypeToString(asset.type),
                          asset.key.themeIdentifier,
                          asset.key.themeSubtype,
                          asset.key.themePreviousState,
                          asset.key.themePreviousValue,
                          asset.key.themeDimension1,
                          asset.key.themeDimension2,
                          CFTScaleToString(asset.scale)];
        if (!(CoreThemeTypeIsBitmap(asset.type) || asset.type == kCoreThemeTypePDF)) {
            continue;
        }
        
        if (asset.type == kCoreThemeTypePDF) {
            NSString *destination = [url URLByAppendingPathComponent:[name stringByAppendingPathExtension:@"pdf"]].path;
            [asset.pdfData writeToFile:destination atomically:NO];
        } else {
            NSString *destination = [url URLByAppendingPathComponent:[name stringByAppendingPathExtension:@"png"]].path;
            [[asset.image representationUsingType:NSPNGFileType properties:nil]
             writeToFile:destination atomically:NO];
        }
        
        writes++;
    }
    
    NSLog(@"wrote %llu files", (unsigned long long)writes);
    
}

@end
