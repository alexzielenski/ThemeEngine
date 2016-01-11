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
#import "NSDocumentController+Untitled.h"

@interface TEWelcomeController () <NSWindowDelegate>
@property (strong) NSArray *URLs;
- (void)openRecent:(id)sender;
@end

@implementation TEWelcomeController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.backgroundView.backgroundColor = [NSColor themeEnginePurpleColor];
    
    self.window.styleMask       = NSBorderlessWindowMask;
    self.window.backgroundColor = [NSColor clearColor];
    self.window.opaque          = NO;
    
    self.window.contentView.wantsLayer          = YES;
    self.window.contentView.layer.masksToBounds = YES;
    self.window.contentView.layer.cornerRadius  = 8.0;

    self.recentsTable.target               = self;
    self.recentsTable.doubleAction         = @selector(openRecent:);
    self.recentsTable.allowsEmptySelection = NO;
}

- (void)keyDown:(nonnull NSEvent *)theEvent {
    if (theEvent.keyCode == 36 &&
        self.window.firstResponder == self.recentsTable) {
        [self openRecent:self.recentsTable];
        
    } else {
        [super keyDown:theEvent];
    }
}

- (void)openRecent:(id)sender {
    NSInteger row = self.recentsTable.selectedRow;
    NSURL *url = self.URLs[row];
    
    [[TEDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url
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
    [[TEDocumentController sharedDocumentController] openDocument:sender];
}

#pragma mark - Table

- (void)dismissController:(nullable id)sender {
    [super dismissController:sender];
    [self.window performClose:sender];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    self.URLs = [[TEDocumentController sharedDocumentController] recentDocumentURLs];
    [self.recentsTable reloadData];
    [self.window makeFirstResponder:self.recentsTable];
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
    
    cell.textField.target          = self;
    cell.textField.action          = @selector(openRecent:);
    cell.subTitleLabel.stringValue = url.path;
    cell.textField.stringValue     = url.lastPathComponent.stringByDeletingPathExtension;
    cell.imageView.image           = image;
    return cell;
}

@end
