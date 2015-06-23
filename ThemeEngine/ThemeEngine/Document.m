//
//  Document.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "Document.h"

static NSString *const TKCarPathSystemAppearance = @"/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/SystemAppearance.car";
static NSString *const TKCarPathAssets           = @"/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources/Assets.car";

@interface Document () <NSTableViewDelegate>

@end

@implementation Document

- (instancetype)init {
    if ((self = [super init])) {
        // Add your subclass-specific initialization here.
        self.assetStorage = [TKAssetStorage assetStorageWithPath:TKCarPathSystemAppearance];
        self.undoManager = self.assetStorage.undoManager;
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    aController.window.titleVisibility = NSWindowTitleHidden;
    aController.window.appearance = [NSAppearance currentAppearance];
    aController.window.titlebarAppearsTransparent = YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromURL:(nonnull NSURL *)url ofType:(nonnull NSString *)typeName error:(NSError * __nullable __autoreleasing * __nullable)outError {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager isWritableFileAtPath:url.path]) {
        //!TODO: Prompt to user to ask if we should move to a temporary location
        //! or open just for viewing
        return NO;
    }
    
    return YES;
}

+ (BOOL)autosavesDrafts {
    return NO;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

@end
