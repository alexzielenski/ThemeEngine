//
//  CUIThemeGradient+Radial.m
//  carFileTool
//
//  Created by Alexander Zielenski on 8/14/14.
//  Copyright (c) 2014 Alexander Zielenski. All rights reserved.
//

#import "CUIPSDGradientEvaluator.h"
#import "ZKSwizzle.h"
/*
 function methImpl_CUIThemeGradient_drawFromPoint_toPoint_options_withContext_ {
 r14 = rcx;
 rbx = rdx;
 var_24 = xmm2;
 var_8 = xmm0;
 r15 = rdi;
 if (xmm0 != xmm2) goto loc_a0742;
 goto loc_a0740;
 
 loc_a0742:
 if (xmm1 != xmm3) goto loc_a074a;
 goto loc_a0748;
 
 loc_a074a:
 var_16 = xmm1;
 var_32 = xmm3;
 
 loc_a07bc:
 rax = [r15 colorShader];
 r12 = rax;
 
 loc_a07d2:
 rax = CGShadingCreateAxial(r15.colorSpace, r12, rbx & 0x1, (rbx & 0x2) >> 0x1);
 rbx = rax;
 CGContextDrawShading(r14, rbx);
 rax = CGShadingRelease(rbx);
 if (0x0 != 0x0) {
 rdi = r12;
 rax = CGFunctionRelease(rdi);
 }
 else {
 return rax;
 }
 return rax;
 
 loc_a0748:
 if (CPU_EFLAGS & FLG_NP) goto loc_a0756;
 goto loc_a074a;
 
 loc_a0756:
 var_16 = xmm1;
 var_32 = xmm3;
 rax = [r15.gradientEvaluator hasEdgePixel];
 if (rax == 0x0) goto loc_a07bc;
 asm{ andpd      xmm1, xmm2 };
 asm{ andpd      xmm0, xmm2 };
 asm{ maxsd      xmm0, xmm1 };
 rax = [r15 _newColorShaderForDistance:rdx];
 r12 = rax;
 goto loc_a07d2;
 
 loc_a0740:
 if (CPU_EFLAGS & FLG_NP) goto loc_a0756;
 goto loc_a0742;
 }

 
 */

#import "CUIThemeGradient+Radial.h"

@implementation CUIThemeGradient (Radial)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)drawInRect:(CGRect)arg1 relativeCenterPosition:(CGPoint)arg2 withContext:(CGContextRef)arg3 {
    CUIPSDGradientEvaluator *evaluator = ZKHookIvar(self, CUIPSDGradientEvaluator *, "gradientEvaluator");
    CGFunctionRef colorShade = self.colorShader;
    BOOL created = NO;
    if (evaluator.hasEdgePixel) {
        CGFloat distance = pow(pow(arg2.x - NSMaxX(arg1), 2) + pow(arg2.y - NSMaxY(arg1), 2), 0.5);
        colorShade = [self _newColorShaderForDistance:distance];
        created = YES;
    }
    
    CGShadingRef shader = CGShadingCreateRadial([[NSColorSpace sRGBColorSpace] CGColorSpace],
                                                arg2,
                                                0,
                                                arg2,
                                                MIN(arg1.size.width - arg2.x, arg1.size.height - arg2.y),
                                                colorShade,
                                                false,
                                                true);
    CGContextDrawShading(arg3, shader);
    CGShadingRelease(shader);
    if (created) {
        CGFunctionRelease(colorShade);
    }
}
#pragma clang diagnostic pop

@end
