//
//  CHDocument.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CHDocument.h"

@interface CHDocument ()
@property (readwrite, strong) CFTElementStore *elementStore;
@property (readwrite, strong) NSArray *sortDescriptors;
@end

@implementation CHDocument

- (id)init  {
    if ((self = [super init])) {
        self.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] ];

    }
    return self;
}

- (NSString *)windowNibName {
    return @"CHDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    [self.elementViewController bind:@"elements" toObject:self.elementArrayController withKeyPath:@"selectedObjects" options:nil];
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    [self.elementStore save];
    return [[NSFileManager defaultManager] copyItemAtPath:self.elementStore.path toPath:url.path error:outError];
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSString *tempPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"car"];
    if (![[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:tempPath] error:outError]) {
        return NO;
    }
    
    self.elementStore = [CFTElementStore storeWithPath:tempPath];
    return YES;
}

+ (BOOL)autosavesInPlace {
    return NO;
}

@end
