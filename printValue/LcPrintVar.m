//
//  LcPrintVar.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/5.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintVar.h"
#import <UIKit/UIKit.h>
#import "LcPrintObj.h"

#if DEBUG

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"


#define checkNumType(NumType)                                           \
    if (strcmp(type, @encode(NumType)) == 0) {                          \
        NumType param = (NumType)va_arg(variable_param_list, NumType);  \
        return __String(@"(%s)%@",#NumType,@(param));                   \
}

#define checkStructType(StructType)                                     \
    if (strcmp(type, @encode(StructType)) == 0) {                       \
        StructType param = va_arg(variable_param_list, StructType);     \
        return __String(@"(%s)%@",#StructType,NSStringFrom##StructType(param)); \
    }

extern NSString *NSStringFromCATransform3D(CATransform3D transform);
static inline NSString *NSStringFromNSRange(NSRange range);
static inline NSString *NSStringFromCFRange(CFRange range);

static inline NSString *__describeVar(const char *type, va_list variable_param_list);


NSString *describeVar(const char *type, ...)
{
    va_list variable_param_list;
    va_start(variable_param_list, type);
    
    if (strcmp(type, @encode(id)) == 0) {
        id obj = va_arg(variable_param_list, id);
        return describeObj(obj);
    }
    
    return __describeVar(type, variable_param_list);
}

static inline NSString *__describeVar(const char *type, va_list variable_param_list)
{
    if (strcmp(type, @encode(BOOL)) == 0) {
        BOOL param = va_arg(variable_param_list, BOOL);
        return __String(@"(BOOL)%@",param?@"YES":@"NO");
    }
    if (strcmp(type, @encode(char)) == 0) {
        char param = va_arg(variable_param_list, char);
        return __String(@"(char)%c",param);
    }
    if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char param = va_arg(variable_param_list, unsigned char);
        return __String(@"(char)%c",param);
    }
    
    checkNumType(int);
    checkNumType(short);
    checkNumType(long);
    checkNumType(long long);
    checkNumType(unsigned int);
    checkNumType(unsigned short);
    checkNumType(unsigned long);
    checkNumType(unsigned long long);
    checkNumType(float);
    checkNumType(double);
    
    checkStructType(CGPoint);
    checkStructType(CGSize);
    checkStructType(CGVector);
    checkStructType(CGRect);
    checkStructType(NSRange);
    checkStructType(CFRange);
    checkStructType(CGAffineTransform);
    checkStructType(CATransform3D);
    checkStructType(UIOffset);
    checkStructType(UIEdgeInsets);
    
    return @"UnKnown Type😂";
}

#pragma mark - inline

NSString *NSStringFromCATransform3D(CATransform3D transform)
{
    NSString *string1 = __String(@"{\n\tm11 = %g, m12 = %g, m13 = %g, m14 = %g",transform.m11,transform.m12,transform.m13,transform.m14);
    NSString *string2 = __String(@"\n\tm21 = %g, m22 = %g, m23 = %g, m24 = %g",transform.m21,transform.m22,transform.m23,transform.m24);
    NSString *string3 = __String(@"\n\tm31 = %g, m32 = %g, m33 = %g, m34 = %g",transform.m31,transform.m32,transform.m33,transform.m34);
    NSString *string4 = __String(@"\n\tm41 = %g, m42 = %g, m43 = %g, m44 = %g\n}",transform.m31,transform.m32,transform.m33,transform.m34);
    return __String(@"%@%@%@%@",string1,string2,string3,string4);
}

static inline NSString *NSStringFromNSRange(NSRange range)
{
    return NSStringFromRange(range);
}

static inline NSString *NSStringFromCFRange(CFRange range)
{
    return __String(@"{%lu,%lu}",range.location,range.length);
}


#undef checkNumType
#undef checkStructType

#pragma clang diagnostic pop

#endif
