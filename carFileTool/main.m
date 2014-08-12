//
//  main.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/8/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CFTElementStore.h"

/*
 
 function methImpl_CUICommonAssetStorage_assetKeysMatchingBlock_ {
 r14 = rdx;
 var_96 = **__stack_chk_guard;
 objc_sync_enter(rdi);
 rdi = rdi;
 rax = [rdi keyFormat];
 rdi = *(int32_t *)(rax + 0x8);
 if (rdi >= 0x10) {
 rdi = rdi + 0x1;
 rax = calloc(rdi, 0x4);
 var_24 = rax;
 rdi = *(int32_t *)(r15 + 0x8);
 }
 else {
 var_24 = &var_32;
 }
 rax = _BOMTreeIteratorNew(r13._imagedb, 0x0, rdi + rdi, 0x0);
 rbx = rax;
 var_16 = r15;
 var_8 = 0x0;
 
 loc_a3017:
 rax = _BOMTreeIteratorIsAtEnd(rbx);
 if (rax != 0x0) goto loc_a3125;
 goto loc_a3027;
 
 loc_a3125:
 _BOMTreeIteratorFree(rbx);
 if (var_24 != &var_32) {
 free(rdi);
 }
 rax = [var_8 autorelease];
 rbx = rax;
 objc_sync_exit(r13);
 if (**__stack_chk_guard == var_96) {
 rax = rbx;
 return rax;
 }
 else {
 rax = __stack_chk_fail();
 rbx = rax;
 objc_sync_exit(r13);
 rax = _Unwind_Resume(rbx);
 }
 return rax;
 
 loc_a3027:
 rax = _BOMTreeIteratorKey(rbx);
 r15 = rax;
 rax = _BOMTreeIteratorKeySize(rbx);
 r12 = rax;
 rax = [r13 swapped];
 if (rax != 0x0) {
 [r13 _swapRenditionKeyArray:r15];
 }
 _CUIFillRenditionKeyForCARKeyArray(var_24, r15, var_16);
 rax = (*(r14 + 0x10))(r14, var_24, var_16);
 if (rax != 0x0) {
 if (var_8 == 0x0) {
 rax = [NSMutableSet alloc];
 rax = [rax init];
 var_8 = rax;
 }
 rax = [NSData dataWithBytes:r15 length:r12];
 [var_8 addObject:rax];
 }
 rax = [r13 swapped];
 if (rax != 0x0) {
 [r13 _swapRenditionKeyArray:r15];
 }
 _BOMTreeIteratorNext(rbx);
 goto loc_a3017;
 }
 */


#import <objc/runtime.h>
#import <Opee/Opee.h>
#import "CUIPSDGradientEvaluator.h"
#import "CUIPSDGradient.h"
#import "CUIPSDGradientColorStop.h"
#import "CFTEffectWrapper.h"

void *ZKIvarPointer(id self, const char *name) {
    Ivar ivar = class_getInstanceVariable(object_getClass(self), name);
    return ivar == NULL ? NULL : (__bridge void *)self + ivar_getOffset(ivar);
}

void CGImageWriteToFile(CGImageRef image, NSString *path)
{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
 
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
}

#import "CUICommonAssetStorage.h"

/*
 Value at 0, 4, 8, 24, 32, 40, 56
 
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CUIShapeEffectPreset *preset = [[CUIShapeEffectPreset alloc] init];
        [preset addColorFillWithRed:255 green:0 blue:0 opacity:1.0 blendMode:kCGBlendModeColor];
        [preset addDropShadowWithColorRed:0 green:0 blue:0 opacity:1 blur:1 spread:4 offset:2 angle:3];
        
        CFTEffectWrapper *wrapper = [CFTEffectWrapper effectWrapperWithEffectPreset:preset];
        
        [wrapper.effectPreset.CUIEffectDataRepresentation writeToFile:@"/Users/Alex/Desktop/data" atomically:NO];
        [preset.CUIEffectDataRepresentation writeToFile:@"/Users/Alex/Desktop/data 2" atomically:NO];
        
    }
    return 0;
}
