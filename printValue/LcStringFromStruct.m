//
//  LcStringFromStruct.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/5.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcStringFromStruct.h"

NSString *LcStringFromCATransform3D(CATransform3D transform)
{
    NSString *string1 = __String(@"{\n\tm11 = %g, m12 = %g, m13 = %g, m14 = %g",transform.m11,transform.m12,transform.m13,transform.m14);
    NSString *string2 = __String(@"\n\tm21 = %g, m22 = %g, m23 = %g, m24 = %g",transform.m21,transform.m22,transform.m23,transform.m24);
    NSString *string3 = __String(@"\n\tm31 = %g, m32 = %g, m33 = %g, m34 = %g",transform.m31,transform.m32,transform.m33,transform.m34);
    NSString *string4 = __String(@"\n\tm41 = %g, m42 = %g, m43 = %g, m44 = %g\n}",transform.m31,transform.m32,transform.m33,transform.m34);
    return __String(@"%@%@%@%@",string1,string2,string3,string4);
}

NSString *LcStringFromCGPoint(CGPoint var)
{
    return __String(@"{x = %g, y = %g}",var.x,var.y);
}

NSString *LcStringFromCGSize(CGSize var)
{
    return __String(@"{width = %g, height = %g}",var.width,var.height);
}

NSString *LcStringFromCGVector(CGVector var)
{
    return __String(@"{dx = %g, dy = %g}",var.dx,var.dy);
}

NSString *LcStringFromCGAffineTransform(CGAffineTransform var)
{
    NSString *string1 = __String(@"{\n\ta = %g, b = %g, c = %g, d = %g",var.a,var.b,var.c,var.d);
    NSString *string2 = __String(@"\n\ttx = %g, ty = %g\n}",var.tx,var.ty);
    return __String(@"%@%@",string1,string2);
}

NSString *LcStringFromUIOffset(UIOffset var)
{
    return __String(@"{horizontal = %g, vertical = %g}",var.horizontal,var.vertical);
}

NSString *LcStringFromUIEdgeInsets(UIEdgeInsets var)
{
    return __String(@"{top = %g, left = %g, bottom = %g, right = %g}",
                    var.top,var.left,var.bottom,var.right);
}

NSString *LcStringFromCGRect(CGRect var)
{
    return __String(@"{%@, %@}",LcStringFromCGPoint(var.origin),LcStringFromCGSize(var.size));
}

NSString *LcStringFromNSRange(NSRange range)
{
    return __String(@"{location = %lu, length = %lu}",range.location,range.length);
}

NSString *LcStringFromCFRange(CFRange range)
{
    return __String(@"{location = %lu, length = %lu}",range.location,range.length);
}


