//
//  TKRendition+ImageBrowser.m
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKRendition+ImageBrowser.h"


@implementation TKRendition (ImageBrowser)

#pragma mark - IKImageBrowserItem

- (NSString *)imageUID {
    return self.description;
}

- (NSString *)imageRepresentationType {
    //!TODO: return IKImageBrowserNSURLRepresentationType for raw data types
    return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation {
    return self.previewImage;
}

- (NSUInteger)imageVersion {
    return (NSUInteger)self.previewImage;
}

- (NSString *)imageTitle {
    return CoreThemeStateToString(self.state);
}

- (NSString *)imageSubtitle {
    return CoreThemeSizeToString(self.size);
}

@end
