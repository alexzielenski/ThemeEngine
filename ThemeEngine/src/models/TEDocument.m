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
                CFTAsset *asset = [CFTAsset assetWithColor:[NSColor performSelector:NSSelectorFromString(name)] name:name];
                [self.elementStore addAsset:asset];
            }
        }
    }];
    
}

@end
