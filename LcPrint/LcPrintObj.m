//
//  LcPrintObj.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/6.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LcPrintObj.h"
#import <objc/runtime.h>
#import "LcPrint.h"
#import "LcStringFromStruct.h"
#import "LcPrintMacro.h"
#import "LcPrintUtility.h"

static NSMutableArray *stackClassList;

static NSArray *basicClusterClassList;
static NSArray *basicNormalClassList;
static NSArray *setClassList;
static inline void initClassList();

static inline NSString *__describeObj(id object, Class class, BOOL circle);
static inline NSString *describeBasicClass(NSString *classString,id object);
static inline NSString *describeNSValue(NSValue *value);
static inline NSString *describeSet(NSString *setClass,NSSet *list, BOOL circle);
static inline NSString *describeDictionary(NSDictionary *map, BOOL circle);
static inline NSString *describeNSObject(id object, Class class,  BOOL circle);


NSString *describeObj(id object, BOOL circlePrintSuper)
{
    return __describeObj(object, [object class], circlePrintSuper);
}

static inline NSString *__describeObj(id object, Class class, BOOL circle)
{
    initClassList();
    
    if (object == nil)
    {
        return @"nil";
    }
    //基础的类族类型:类族类型都需要使用isKindOfClass:判断
    for (NSString *classString in basicClusterClassList)
    {
        if ([object isKindOfClass:NSClassFromString(classString)]){
            return describeBasicClass(classString,object);
        }
    }
    
    //基础的普通类型
    if ([basicNormalClassList containsObject:NSStringFromClass(class)]) {
        return describeBasicClass(NSStringFromClass(class), object);
    }
    
    //NSValue类型(类族)
    if ([object isKindOfClass:[NSValue class]]) {
        return describeNSValue(object);
    }
    
    //容器类型(类族)
    for (NSString *setClass in setClassList) {
        if ([object isKindOfClass:NSClassFromString(setClass)]) {
            return describeSet(setClass, object, circle);
        }
    }
    
    //字典类型(类族)
    if ([object isKindOfClass:[NSDictionary class]]) {
        return describeDictionary(object, circle);
    }
    
    //自定义类型
    return describeNSObject(object, class, circle);
}

#pragma mark - handle

static inline NSString *describeBasicClass(NSString *classString,id object)
{
    if ([object isEqual:__lc_unknown_type]) {
        return object;
    }
    return __LcString(@"(%@ *)%@",classString,object);
}

static inline NSString *describeSet(NSString *setClass,NSSet *list, BOOL circle)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *)[",setClass];
    for (id value in list) {
        NSString *string = __LcString(@"\n%@",describeObj(value, circle));
        [printString appendString:__lc_tap_string(string)];
    }    [printString appendString:@"\n]"];
    return printString;
}

static inline NSString *describeDictionary(NSDictionary *map, BOOL circle)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendString:@"{"];
    for (id key in map.allKeys) {
        NSString *string = __LcString(@"\n%@:%@",key,describeObj(map[key], circle));
        [printString appendString:__lc_tap_string(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *describeNSObject(id object, Class class, BOOL circle)
{
    if ([NSObject isSubclassOfClass:class]) {
        return [object description];
    }
    
    if ([stackClassList containsObject:NSStringFromClass(class)]) {
        return [object description];
    }
    
    [stackClassList addObject:NSStringFromClass(class)];
    
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *){",class];
    
    //循环打印父类
    if (circle) {
        Class superClass = class_getSuperclass(class);
        if (![NSObject isSubclassOfClass:superClass]) {
            NSString *string = __LcString(@"\n%@",(__describeObj(object,superClass, circle)));
            [printString appendString:__lc_tap_string(string)];
        }
    }
    
    //打印本类的属性
    NSArray *names = __lc_property_ivar_name_list(class);
    
    //如果本类没有属性，并且不打印父类，则直接返回description
    if (names.count == 0 && !circle) {
        return [object description];
    }
    
    for (NSString *name in names) {
        id value = __lc_value_for_key(object, name);
        NSString *string = __LcString(@"\n%@ = %@",name,describeObj(value, circle));
        [printString appendString:__lc_tap_string(string)];
    }
    
    [printString appendFormat:@"\n}(%@ *)",class];

    [stackClassList removeObject:NSStringFromClass(class)];
    
    return printString;
}

static inline NSString *describeNSValue(NSValue *value)
{
    
#define CheckBasicType(TYPE)                            \
if (strcmp(value.objCType, @encode(TYPE)) == 0) {       \
    return __LcString(@"(%s)%@",__STRING(TYPE),value);  \
}

    CheckBasicType(short);
    CheckBasicType(int);
    CheckBasicType(long);
    CheckBasicType(long long);
    CheckBasicType(float);
    CheckBasicType(double);
    CheckBasicType(double);
    CheckBasicType(BOOL);
    CheckBasicType(bool);
    CheckBasicType(char);
    CheckBasicType(unsigned short);
    CheckBasicType(unsigned int);
    CheckBasicType(unsigned long);
    CheckBasicType(unsigned long long);
    CheckBasicType(unsigned char);
    
#undef CheckBasicType

#define CheckStructType(TYPE)                                   \
if (strcmp(value.objCType, @encode(TYPE)) == 0) {               \
    TYPE var;                                                   \
    [value getValue:&var];                                      \
    return __LcString(@"(CFRange)%@",LcStringFrom##TYPE(var));  \
}

    CheckStructType(CGPoint);
    CheckStructType(CGSize);
    CheckStructType(CGVector);
    CheckStructType(CGRect);
    CheckStructType(NSRange);
    CheckStructType(CFRange);
    CheckStructType(CGAffineTransform);
    CheckStructType(CATransform3D);
    CheckStructType(UIOffset);
    CheckStructType(UIEdgeInsets);
    
#undef CheckStructType
    
    return [value description];
}


#pragma mark - help

static inline void initClassList()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stackClassList = [NSMutableArray array];
        basicClusterClassList = @[@"NSString",@"NSDate",@"UIColor",];
        basicNormalClassList = @[@"UIView",@"UIViewController",@"NSURL",@"UIWindow",@"UILabel",@"UIButton",@"UIActivity",@"UIActivityIndicatorView",@"UIActionSheet",@"UIActivityViewController",@"UIAlertView",@"UIControl",@"UIDevice",@"UIDocument",@"UIEvent",@"UIFont",@"UIImage",@"UINib",@"UIPageControl",@"UIPickerView",@"UIScreen",@"UITableViewCell",@"UITableView"];
        setClassList = @[@"NSArray",@"NSSet",@"NSOrderedSet",@"NSPointerArray"];
    });
    
    return;
}




