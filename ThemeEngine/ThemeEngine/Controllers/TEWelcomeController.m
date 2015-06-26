//
//  TEWelcomeController.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/26/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TEWelcomeController.h"
#import "NSColor+TE.h"
#import "TERecentCell.h"

@interface TEWelcomeController ()
@property (strong) NSArray *URLs;
- (void)openRecent:(id)sender;
@end

@implementation TEWelcomeController

- (void)windowDidLoad {
    self.URLs = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    
    [super windowDidLoad];
    self.backgroundView.backgroundColor = [NSColor themeEnginePurpleColor];
    
    self.window.styleMask       = NSBorderlessWindowMask;
    self.window.backgroundColor = [NSColor clearColor];
    self.window.opaque          = NO;
    
    self.window.contentView.wantsLayer          = YES;
    self.window.contentView.layer.masksToBounds = YES;
    self.window.contentView.layer.cornerRadius  = 8.0;
    
    self.recentsTable.target = self;
    self.recentsTable.doubleAction = @selector(openRecent:);
    
    [self.recentsTable reloadData];
}

- (void)openRecent:(id)sender {
    NSInteger row = self.recentsTable.clickedRow;
    NSURL *url = self.URLs[row];
    
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url
                                                                           display:YES
                                                                 completionHandler:^(NSDocument * __nullable document, BOOL documentWasAlreadyOpen, NSError * __nullable error) {
                                                                 }];
    [self.window performClose: self];
}

- (void)showWindow:(nullable id)sender {
    [super showWindow:sender];
    [self.window center];
}

#pragma mark - Actions

- (void)createOSXDocument:(id)sender {
    NSLog(@"OSX");
}

- (void)createiOSDocument:(id)sender {
    NSLog(@"iOS");
}

- (void)openDocument:(id)sender {
    [[NSDocumentController sharedDocumentController] openDocument:sender];
}

#pragma mark - Table

- (void)windowDidBecomeKey:(NSNotification *)notification {
    self.URLs = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    [self.recentsTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(nonnull NSTableView *)tableView {
    return MIN([self.URLs count], 10);
}

- (NSView *)tableView:(nonnull NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    TERecentCell *cell = [tableView makeViewWithIdentifier:@"RecentCell" owner:self];
    NSURL *url = self.URLs[row];
    NSImage *image = nil;
    
    if ([url.pathExtension.lowercaseString isEqualToString:@"car"]) {
        image = [NSImage imageNamed:@"Car"];
    } else {
        [url getResourceValue:&image
                       forKey:NSURLEffectiveIconKey
                        error:nil];
    
        if (image == nil)
            image = [NSImage imageNamed:@"Car"];
    }
    
    cell.subTitleLabel.stringValue = url.path;
    cell.textField.stringValue = url.lastPathComponent.stringByDeletingPathExtension;
    cell.imageView.image = image;
    return cell;
}

@end
