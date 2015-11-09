//
//  LcPrintUtility.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/8.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintUtility.h"
#import <objc/runtime.h>
#import "LcPrintMacro.h"
#import <UIKit/UIKit.h>

static inline NSString *propertyNameFromIvarName(NSString *name);
static inline id __lc_custom_value_for_key(id object, NSString *key);
static inline const char *__lc_useful_type_from_ivar_type(const char *ivarType);
static inline const BOOL __lc_has_contain_char(char *string, char c);

NSString *__lc_unknown_type = @"unknown type";

NSArray *__lc_ivar_name_list(Class class)
{
    NSMutableArray *nameList = [NSMutableArray array];
    uint count;
    Ivar *ivarList = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *name = ivar_getName(ivar);
        [nameList addObject:@(name)];
    }
    return nameList;
}

NSArray *__lc_property_name_list(Class class)
{
    NSMutableArray *nameList = [NSMutableArray array];
    uint count;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        [nameList addObject:@(name)];
    }
    return nameList;
}

NSArray *__lc_property_ivar_name_list(Class class)
{
    NSArray *propertyList = __lc_property_name_list(class);
    NSArray *ivarList = __lc_ivar_name_list(class);
    
    NSMutableArray *nameList = [NSMutableArray array];
    //添加与property不重复的ivar
    for (NSString *name in ivarList) {
        NSString *propertyName = propertyNameFromIvarName(name);
        if ([propertyList containsObject:propertyName]) {
            continue;
        }
        [nameList addObject:name];
    }
    
    [nameList addObjectsFromArray:propertyList];
    return nameList;
}

NSArray *__lc_method_name_list(Class class)
{
    NSMutableArray *selList = [NSMutableArray array];
    uint count;
    Method *methodList = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        [selList addObject:NSStringFromSelector(sel)];
    }
    return selList;
}

NSString *__lc_tap_string(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

id __lc_value_for_key(id object, NSString *key)
{
    id value;
    
#if __USE_SYSTEM_KVO
    @try {
        value = [object valueForKey:key];
    }
    @catch (NSException *exception) {
        return nil;
    }
#else
    
    value = __lc_custom_value_for_key(object, key);
#endif
    return value;
}

#pragma mark - inline

//type 类型参见https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

#define GET_VALUE_FROM(TYPE)    \
if (strcmp(type, @encode(TYPE)) == 0) { \
    value = @(*(TYPE*)var);  \
    goto FINISH;    \
}


static inline id __lc_value_for_sel(id object, SEL sel)
{
    NSMethodSignature *sig = [object methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:sel];
    [invocation invokeWithTarget:object];
    [invocation retainArguments];
    id value;
    const char *type = sig.methodReturnType;
    if (strcmp(type, @encode(void)) == 0) {
        return nil;
    }
    
    //unknown type
    if (__lc_has_contain_char((char*)type, '?')||
        __lc_has_contain_char((char*)type, ':')||
        __lc_has_contain_char((char*)type, 'b')||
        __lc_has_contain_char((char*)type, '(')||
        __lc_has_contain_char((char*)type, '['))
    {
        return __lc_unknown_type;
    }
    
    if (strcmp(type, @encode(id)) == 0||
        strcmp(type, @encode(Class)) == 0)
    {
        //使用NSInvocation的参数都是__unsafe_unretained类型，这里直接使用value也不会retain，导致ARC错误
        __unsafe_unretained id buffer;
        [invocation getReturnValue:&buffer];
        value = buffer;
    }
    else
    {
        NSUInteger length = [sig methodReturnLength];
        void *var = (void *)malloc(length);
        [invocation getReturnValue:var];
        
        GET_VALUE_FROM(char);
        GET_VALUE_FROM(int);
        GET_VALUE_FROM(short);
        GET_VALUE_FROM(long);
        GET_VALUE_FROM(long long);
        GET_VALUE_FROM(unsigned char);
        GET_VALUE_FROM(uint);
        GET_VALUE_FROM(ushort);
        GET_VALUE_FROM(unsigned long);
        GET_VALUE_FROM(unsigned long long);
        GET_VALUE_FROM(float);
        GET_VALUE_FROM(double);
        GET_VALUE_FROM(BOOL);
        GET_VALUE_FROM(bool);
        
        value = [NSValue value:var withObjCType:type];
        free(var);
    }
    
FINISH:
    return value;
}

static inline id __lc_value_for_ivar(id object, Ivar ivar)
{
    const char *ivarType = ivar_getTypeEncoding(ivar);
    const char *type = __lc_useful_type_from_ivar_type(ivarType);
    
    //void
    if (strcmp(type, @encode(void)) == 0) {
        return nil;
    }
    
    //unknown type
    if (__lc_has_contain_char((char*)type, '?')||
        __lc_has_contain_char((char*)type, ':')||
        __lc_has_contain_char((char*)type, 'b')||
        __lc_has_contain_char((char*)type, '(')||
        __lc_has_contain_char((char*)type, '['))
    {
        return __lc_unknown_type;
    }

    
    //id
    if (strcmp(type, @encode(id)) == 0) {
        return object_getIvar(object, ivar);
    }
    
    //NSValue or NSNumber
    id value;
    ptrdiff_t offset = ivar_getOffset(ivar);
    void *var = (__bridge void*)object + offset;
    
    GET_VALUE_FROM(char);
    GET_VALUE_FROM(int);
    GET_VALUE_FROM(short);
    GET_VALUE_FROM(long);
    GET_VALUE_FROM(long long);
    GET_VALUE_FROM(unsigned char);
    GET_VALUE_FROM(uint);
    GET_VALUE_FROM(ushort);
    GET_VALUE_FROM(unsigned long);
    GET_VALUE_FROM(unsigned long long);
    GET_VALUE_FROM(float);
    GET_VALUE_FROM(double);
    GET_VALUE_FROM(BOOL);
    GET_VALUE_FROM(bool);
    
    value = [NSValue value:var withObjCType:type];
FINISH:
    
    return value;
}

#undef GET_VALUE_FROM

static inline id __lc_custom_value_for_key(id object, NSString *key)
{
    id value = nil;

    SEL sel = NSSelectorFromString(key);
    if ([object respondsToSelector:sel]) {
        value = __lc_value_for_sel(object, sel);
    }
    
    Class class = [object class];
    
    Ivar ivar = class_getInstanceVariable(class, [key UTF8String]);
    if (!ivar) {
        ivar = class_getInstanceVariable(class, [__LcString(@"_%@",key) UTF8String]);
    }
    if (ivar) {
        value = __lc_value_for_ivar(object, ivar);
    }
    
    return value;
}


static inline NSString *propertyNameFromIvarName(NSString *name)
{
    return [name stringByReplacingOccurrencesOfString:@"_"
                                           withString:@""
                                              options:0
                                                range:NSMakeRange(0, 1)];
}

//ivar_getTypeEncoding获取的type会添加很多其他信息，不能直接使用，所以需要将这些信息去掉。这些信息一般都存放在""中
static inline const char *__lc_useful_type_from_ivar_type(const char *ivarType)
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%s",ivarType];
    
    //将双引号中间的东西去掉
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"[^\"]*\"" options:0 error:NULL];
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    for (int i = (int)results.count - 1; i >= 0; i--) {
        NSTextCheckingResult *result = results[i];
        [string deleteCharactersInRange:result.range];
    }
    const char *type = [string UTF8String];
    return type;
}


static inline const BOOL __lc_has_contain_char(char *string, char c)
{
    NSRange range = [__LcString(@"%s",string) rangeOfString:__LcString(@"%c",c)];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}






