//
//  Describe.m
//  TPobject
//
//  Created by jiangliancheng on 15/11/3.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintObj.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "LcPrintVar.h"
#import "LcStringFromStruct.h"

#if DEBUG

static NSArray *basicClassList;
static NSArray *setClassList;
static inline void initClassList();

static inline NSString *tapString(NSString *string);
static inline NSString *describeBasicClass(NSString *classString,id object);
static inline NSString *describeNSValue(NSValue *value);
static inline NSString *describeSet(NSString *setClass,NSSet *list);
static inline NSString *describeDictionary(NSDictionary *map);
static inline NSString *describeNSObject(id object);



void LcPrintObj(id obj)
{
    printf("%s\n",[describeObj(obj) UTF8String]);
}


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
    return __String(@"(%@ *)%@",classString,object);
}

static inline NSString *describeSet(NSString *setClass,NSSet *list)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *)[",setClass];
    for (id value in list) {
        NSString *string = __String(@"\n%@",describeObj(value));
        [printString appendString:tapString(string)];
    }    [printString appendString:@"\n]"];
    return printString;
}

static inline NSString *describeDictionary(NSDictionary *map)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendString:@"{"];
    for (id key in map.allKeys) {
        NSString *string = __String(@"\n%@:%@",key,describeObj(map[key]));
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

    uint propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([object class], &propertyCount);
    
    if (propertyCount == 0) {
        return [object description];
    }
    
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *){",[object class]];
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        
        id value = [object valueForKey:@(name)];
        NSString *string = __String(@"\n%@ = %@",@(name),describeObj(value));
        [printString appendString:tapString(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *describeNSValue(NSValue *value)
{
    //NSNumber
    if (strcmp(value.objCType, @encode(short)) == 0) {
        return __String(@"(short)%@",value);
    }
    if (strcmp(value.objCType, @encode(int)) == 0) {
        return __String(@"(int)%@",value);
    }
    if (strcmp(value.objCType, @encode(long)) == 0) {
        return __String(@"(long)%@",value);
    }
    if (strcmp(value.objCType, @encode(long long)) == 0) {
        return __String(@"(long long)%@",value);
    }
    if (strcmp(value.objCType, @encode(float)) == 0) {
        return __String(@"(float)%@",value);
    }
    if (strcmp(value.objCType, @encode(double)) == 0) {
        return __String(@"(double)%@",value);
    }
    if (strcmp(value.objCType, @encode(BOOL)) == 0) {
        return __String(@"(BOOL)%@",value);
    }
    if (strcmp(value.objCType, @encode(bool)) == 0) {
        return __String(@"(bool)%@",value);
    }
    if (strcmp(value.objCType, @encode(char)) == 0) {
        return __String(@"(char)%@",value);
    }
    if (strcmp(value.objCType, @encode(unsigned short)) == 0) {
        return __String(@"(unsigned short)%@",value);
    }
    if (strcmp(value.objCType, @encode(unsigned int)) == 0) {
        return __String(@"(unsigned int)%@",value);
    }
    if (strcmp(value.objCType, @encode(unsigned long)) == 0) {
        return __String(@"(unsigned long)%@",value);
    }
    if (strcmp(value.objCType, @encode(unsigned long long)) == 0) {
        return __String(@"(unsigned long long)%@",value);
    }
    if (strcmp(value.objCType, @encode(unsigned char)) == 0) {
        return __String(@"(unsigned char)%@",value);
    }
    
    //basic type
    if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        NSString *string = LcStringFromCGPoint([value CGPointValue]);
        return __String(@"(CGPoint)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        NSString *string = LcStringFromCGSize([value CGSizeValue]);
        return __String(@"(CGSize)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGVector)) == 0) {
        NSString *string = LcStringFromCGVector([value CGVectorValue]);
        return __String(@"(CGVector)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGRect)) == 0) {
        NSString *string = LcStringFromCGRect([value CGRectValue]);
        return __String(@"(CGRect)%@",string);
    }
    if (strcmp(value.objCType, @encode(NSRange)) == 0) {
        return __String(@"(NSRange)%@",LcStringFromNSRange([value rangeValue]));
    }
    if (strcmp(value.objCType, @encode(CFRange)) == 0) {
        CFRange range;
        [value getValue:&range];
        return __String(@"(CFRange)%@",LcStringFromCFRange(range));
    }
    if (strcmp(value.objCType, @encode(CGAffineTransform))  == 0) {
        NSString *string = LcStringFromCGAffineTransform([value CGAffineTransformValue]);
        return __String(@"(CGAffineTransform)%@",string);
    }
    if (strcmp(value.objCType, @encode(CATransform3D)) == 0) {
        NSString *string = LcStringFromCATransform3D([value CATransform3DValue]);
        return __String(@"(CATransform3D)%@",string);
    }
    if (strcmp(value.objCType, @encode(UIOffset)) == 0) {
        NSString *string = LcStringFromUIOffset([value UIOffsetValue]);
        return __String(@"(UIOffset)%@",string);
    }
    if (strcmp(value.objCType, @encode(UIEdgeInsets)) == 0) {
        NSString *string = LcStringFromUIEdgeInsets([value UIEdgeInsetsValue]);
        return __String(@"(UIEdgeInsets)%@",string);
    }

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



#endif
