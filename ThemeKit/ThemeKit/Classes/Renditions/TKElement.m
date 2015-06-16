//
//  TKElement.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKElement.h"
#import "TKElement+Private.h"
#import "TKAssetStorage.h"
#import "TKRendition+Private.h"

@interface TKElement ()
@property (readwrite, weak) TKAssetStorage *storage;
@property (readwrite, copy) NSString *name;
@end

@implementation TKElement 

+ (instancetype)elementWithRenditions:(NSSet<TKRendition *> *)renditions name:(NSString *)name storage:(TKAssetStorage *)storage {
    return [[[self class] alloc] initWithRenditions:renditions name:name storage:storage];
}
- (instancetype)initWithRenditions:(NSSet<TKRendition *> *)renditions name:(NSString *)name storage:(TKAssetStorage *)storage {
    if ((self = [super init])) {
        self.renditions = [[NSMutableSet<TKRendition *> alloc] init];
        self.name = name;
        self.storage = storage;
        
        [self addRenditions:renditions];
    }
    
    return self;
}

- (instancetype)init {
    [NSException raise:@"Invalid Instantiation" format:@"You may not create new instances of TKElement"];
    return nil;
}

#pragma mark - Managing Renditions

- (void)addRenditions:(NSSet<TKRendition *> *)renditions {
    [renditions setValue:self forKeyPath:@"element"];
    [(NSMutableSet *)self.renditions unionSet:renditions];
}

- (void)addRendition:(TKRendition *)asset {
    [self addRenditions:[NSSet<TKRendition *> setWithObject:asset]];
}

- (void)removeRenditions:(NSSet<TKRendition *> *)renditions {
    [(NSMutableSet *)self.renditions minusSet:renditions];
}

- (void)removeRendition:(TKRendition *)asset {
    [self removeRenditions:[NSSet<TKRendition *> setWithObject:asset]];
}

@end
