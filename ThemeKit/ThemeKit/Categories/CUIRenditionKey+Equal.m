//
//  CUIRenditionKey+Equal.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "CUIRenditionKey+Equal.h"

@implementation CUIRenditionKey (Equal)

- (BOOL)isEqual:(CUIRenditionKey *)object {
    if (![object isKindOfClass:[CUIRenditionKey class]])
        return NO;
    
    return self.themeIdentifier           == object.themeIdentifier &&
            self.themeGraphicsClass       == object.themeGraphicsClass &&
            self.themeMemoryClass         == object.themeMemoryClass &&
            self.themeSizeClassVertical   == object.themeSizeClassVertical &&
            self.themeSizeClassHorizontal == object.themeSizeClassHorizontal &&
            self.themeSubtype             == object.themeSubtype &&
            self.themeIdiom               == object.themeIdiom &&
            self.themeScale               == object.themeScale &&
            self.themeLayer               == object.themeLayer &&
            self.themePresentationState   == object.themePresentationState &&
            self.themePreviousState       == object.themePreviousState &&
            self.themeState               == object.themeState &&
            self.themeDimension2          == object.themeDimension2 &&
            self.themeDimension1          == object.themeDimension1 &&
            self.themePreviousValue       == object.themePreviousValue &&
            self.themeValue               == object.themeValue &&
            self.themeDirection           == object.themeDirection &&
            self.themeSize                == object.themeSize &&
            self.themePart                == object.themePart &&
            self.themeElement             == object.themeElement;
}

@end
