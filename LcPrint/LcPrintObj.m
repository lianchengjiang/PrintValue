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


static NSArray *basicClassList;
static NSArray *setClassList;
static inline void initClassList();

static inline NSString *tapString(NSString *string);
static inline NSString *describeBasicClass(NSString *classString,id object);
static inline NSString *describeNSValue(NSValue *value);
static inline NSString *describeSet(NSString *setClass,NSSet *list);
static inline NSString *describeDictionary(NSDictionary *map);
static inline NSString *describeNSObject(id object);
static inline NSArray *propertyAndIvarNames(Class class);


NSString *describeObj(id object)
{
    initClassList();
    
    if (object == nil)
    {
        return @"nil";
    }
    
    for (NSString *classString in basicClassList)
    {
        if ([object isKindOfClass:NSClassFromString(classString)]){
            return describeBasicClass(classString,object);
        }
    }
    
    if ([object isKindOfClass:[NSValue class]]) {
        return describeNSValue(object);
    }
    
    for (NSString *setClass in setClassList) {
        if ([object isKindOfClass:NSClassFromString(setClass)]) {
            return describeSet(setClass, object);
        }
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        return describeDictionary(object);
    }
    
    return describeNSObject(object);
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

static inline NSString *describeNSObject(id object)
{
    if ([object isMemberOfClass:[NSObject class]]) {
        return [object description];
    }
    
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *){",[object class]];
    
    NSArray *names = propertyAndIvarNames([object class]);
    for (NSString *name in names) {
        id value = [object valueForKey:name];
        NSString *string = __LcString(@"\n%@ = %@",name,describeObj(value));
        [printString appendString:tapString(string)];
    }
    
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *describeNSValue(NSValue *value)
{
    
#define CheckBasicType(TYPE)                                \
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
        basicClassList = @[@"NSString",@"NSURL",@"NSDate",@"UIView",@"UIViewController"];
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
        NSString *propertyName = [name stringByReplacingOccurrencesOfString:@"_"
                                                                 withString:@""
                                                                    options:0
                                                                      range:NSMakeRange(0, 1)];
        if (![names containsObject:propertyName]) {
            
            //使用ivarIndex 主要是为了Ivar在Property前面，并且顺序正确
            [names insertObject:name atIndex:ivarIndex];
            ivarIndex++;
        }
    }
    return names;
}

