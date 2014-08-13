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
    
    [self.elementViewController bind:@"elements" toObject:self.elementArrayController withKeyPath:@"selectedObjects" options:nil];
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

@end
