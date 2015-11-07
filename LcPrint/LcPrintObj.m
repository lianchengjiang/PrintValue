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

#define __LcString(fmt, ...)  [NSString stringWithFormat:fmt, ##__VA_ARGS__]


static NSArray *basicClusterClassList;
static NSArray *basicNormalClassList;
static NSArray *setClassList;
static inline void initClassList();

static inline NSString *__describeObj(id object, Class class);
static inline NSString *tapString(NSString *string);
static inline NSString *describeBasicClass(NSString *classString,id object);
static inline NSString *describeNSValue(NSValue *value);
static inline NSString *describeSet(NSString *setClass,NSSet *list);
static inline NSString *describeDictionary(NSDictionary *map);
static inline NSString *describeNSObject(id object, Class class);
static inline NSArray *propertyAndIvarNames(Class class);


NSString *describeObj(id object)
{
    return __describeObj(object, [object class]);
}

static inline NSString *__describeObj(id object, Class class)
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
            return describeSet(setClass, object);
        }
    }
    
    //字典类型(类族)
    if ([object isKindOfClass:[NSDictionary class]]) {
        return describeDictionary(object);
    }
    
    //自定义类型
    return describeNSObject(object, class);
}

#pragma mark - handle

static inline NSString *describeBasicClass(NSString *classString,id object)
{
    return __LcString(@"(%@ *)%@",classString,object);
}

static inline NSString *describeSet(NSString *setClass,NSSet *list)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *)[",setClass];
    for (id value in list) {
        NSString *string = __LcString(@"\n%@",describeObj(value));
        [printString appendString:tapString(string)];
    }    [printString appendString:@"\n]"];
    return printString;
}

static inline NSString *describeDictionary(NSDictionary *map)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendString:@"{"];
    for (id key in map.allKeys) {
        NSString *string = __LcString(@"\n%@:%@",key,describeObj(map[key]));
        [printString appendString:tapString(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *describeNSObject(id object, Class class)
{
    if ([NSObject isSubclassOfClass:class]) {
        return [object description];
    }
    
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *){",class];
    
    NSArray *names = propertyAndIvarNames(class);
    for (NSString *name in names) {
        id value = [object valueForKey:name];
        NSString *string = __LcString(@"\n%@ = %@",name,describeObj(value));
        [printString appendString:tapString(string)];
    }
    
    // subClass
    Class superClass = class_getSuperclass(class);
    if (![NSObject isSubclassOfClass:superClass]) {
        NSString *string = __LcString(@"\n❣️superClass : %@",
                                      __describeObj(object,superClass));
        [printString appendString:tapString(string)];
    }
    
    [printString appendString:@"\n}"];
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
        basicClusterClassList = @[@"NSString",@"NSDate",];
        basicNormalClassList = @[@"UIView",@"UIViewController",@"NSURL",];
        setClassList = @[@"NSArray",@"NSSet",@"NSOrderedSet",@"NSPointerArray"];
    });
    
    return;
}

static inline NSString *tapString(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

static inline NSArray *propertyAndIvarNames(Class class)
{
    NSMutableArray *names = [NSMutableArray array];
    uint propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        [names addObject:@(name)];
    }
    
    //ivar
    uint ivarCount;
    Ivar *ivarList = class_copyIvarList(class, &ivarCount);
    uint ivarIndex = 0;
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarList[i];
        const char *cName = ivar_getName(ivar);
        NSString *name = @(cName);
        
        //过滤Ivar和property相同的属性
        NSString *propertyName = [name stringByReplacingOccurrencesOfString:@"_" withString:@"" options:0 range:NSMakeRange(0, 1)];
        if ([names containsObject:propertyName]) {
            continue;
        }
        //使用ivarIndex 主要是为了Ivar在Property前面，并且顺序正确
        [names insertObject:name atIndex:ivarIndex];
        ivarIndex++;
    }
    return names;
}

#undef __LcString

