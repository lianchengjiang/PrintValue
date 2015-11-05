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
#import "LcStringFromStruct.h"

#if DEBUG

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvarargs"


#define checkNumType(NumType)                                           \
    if (strcmp(type, @encode(NumType)) == 0) {                          \
        NumType param = (NumType)va_arg(variable_param_list, NumType);  \
        return __String(@"(%s)%@",__STRING(NumType),@(param));                   \
}

#define checkStructType(StructType)                                     \
    if (strcmp(type, @encode(StructType)) == 0) {                       \
        StructType param = va_arg(variable_param_list, StructType);     \
        return __String(@"(%s)%@",__STRING(StructType),LcStringFrom##StructType(param)); \
    }


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
        return __String(@"(char)'%c'",param);
    }
    if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char param = va_arg(variable_param_list, unsigned char);
        return __String(@"(unsigned char)'%c'",param);
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
    checkNumType(char *);
    
//    checkStructType(Class);
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
    
    void * param = (void *)va_arg(variable_param_list, void *);
    return [NSString stringWithFormat:@"%p", param];
}

#pragma mark - inline




#undef checkNumType
#undef checkStructType

#pragma clang diagnostic pop

#endif
