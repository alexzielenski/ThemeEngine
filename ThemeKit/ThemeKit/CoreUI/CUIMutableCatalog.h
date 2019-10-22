//
//  CUIMutableCatalog.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 9/26/19.
//  Copyright © 2019 Alex Zielenski. All rights reserved.
//

#ifndef CUIMutableCatalog_h
#define CUIMutableCatalog_h

#import <CoreUI/CUICatalog.h>

@interface CUIMutableCatalog : CUICatalog {

    unsigned _checkRespondsTo : 1;
    unsigned _respondsToCheck : 1;

}
-(id)_baseKeyForName:(id)arg1 ;
-(unsigned long long)_storageRefForRendition:(id)arg1 representsODRContent:(BOOL*)arg2 ;
-(id)_baseImageKeyForName:(id)arg1 ;
-(void)insertCGImage:(CGImageRef)arg1 name:(id)arg2 scale:(double)arg3 idiom:(long long)arg4 subtype:(long long)arg5 ;
-(id)init;
-(void)dealloc;
-(id)initWithName:(id)arg1 ;
-(void)removeImageNamed:(id)arg1 scale:(double)arg2 idiom:(long long)arg3 subtype:(long long)arg4 ;
-(void)removeImageNamed:(id)arg1 withDescription:(id)arg2 ;
-(void)insertCGImage:(CGImageRef)arg1 withName:(id)arg2 andDescription:(id)arg3 ;
-(id)initWithName:(id)arg1 fromBundle:(id)arg2 error:(id*)arg3 ;
@end

#endif /* CUIMutableCatalog_h */
