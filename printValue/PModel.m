//
//  PModel.m
//  TPModel
//
//  Created by jiangliancheng on 15/11/3.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "PModel.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define __String(fmt, ...)  [NSString stringWithFormat:fmt, ##__VA_ARGS__]

static inline NSArray *basicClassList();
static inline NSArray *setClassList();
static inline NSString *tapString(NSString *string);

static inline NSString *NSStringFromCATransform3D(CATransform3D transform);

static inline NSString *printValueOfBasicClass(NSString *classString,id model);
static inline NSString *printValueOfNSValue(NSValue *value);
static inline NSString *printValueOfSet(NSString *setClass,NSSet *list);
static inline NSString *printValueOfDictionary(NSDictionary *map);
static inline NSString *printValueOfModel(id model);


NSString *printValue(id model)
{
    if (model == nil)
    {
        return @"nil";
    }

    for (NSString *classString in basicClassList())
    {
        if ([model isKindOfClass:NSClassFromString(classString)]){
            return printValueOfBasicClass(classString,model);
        }
    }
    
    if ([model isKindOfClass:[NSValue class]]) {
        return printValueOfNSValue(model);
    }
    
    for (NSString *setClass in setClassList()) {
        if ([model isKindOfClass:NSClassFromString(setClass)]) {
            return printValueOfSet(setClass, model);
        }
    }
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        return printValueOfDictionary(model);
    }
    
    return printValueOfModel(model);
}

#pragma mark - handle

static inline NSString *printValueOfBasicClass(NSString *classString,id model)
{
    return __String(@"(%@ *)%@",classString,model);
}

static inline NSString *printValueOfSet(NSString *setClass,NSSet *list)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *)[",setClass];
    for (id value in list) {
        NSString *string = __String(@"\n%@",printValue(value));
        [printString appendString:tapString(string)];
    }    [printString appendString:@"\n]"];
    return printString;
}

static inline NSString *printValueOfDictionary(NSDictionary *map)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendString:@"{"];
    for (id key in map.allKeys) {
        NSString *string = __String(@"\n%@:%@",key,printValue(map[key]));
        [printString appendString:tapString(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *printValueOfModel(id model)
{
    NSMutableString *printString = [NSMutableString string];

    uint propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([model class], &propertyCount);
    
    if (propertyCount == 0) {
        return [model description];
    }
    
    [printString appendFormat:@"(%@ *){",[model class]];
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        id value = [model valueForKey:@(name)];
        NSString *string = __String(@"\n%@ = %@",@(name),printValue(value));
        [printString appendString:tapString(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}

static inline NSString *printValueOfNSValue(NSValue *value)
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
        NSString *string = NSStringFromCGPoint([value CGPointValue]);
        return __String(@"(CGPoint)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        NSString *string = NSStringFromCGSize([value CGSizeValue]);
        return __String(@"(CGSize)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGVector)) == 0) {
        NSString *string = NSStringFromCGVector([value CGVectorValue]);
        return __String(@"(CGVector)%@",string);
    }
    if (strcmp(value.objCType, @encode(CGRect)) == 0) {
        NSString *string = NSStringFromCGRect([value CGRectValue]);
        return __String(@"(CGRect)%@",string);
    }
    if (strcmp(value.objCType, @encode(NSRange)) == 0) {
        return __String(@"(NSRange)%@",NSStringFromRange([value rangeValue]));
    }
    if (strcmp(value.objCType, @encode(CFRange)) == 0) {
        CFRange range;
        [value getValue:&range];
        return __String(@"(CFRange){%lu,%lu}",range.location,range.length);
    }
    if (strcmp(value.objCType, @encode(CGAffineTransform))  == 0) {
        NSString *string = NSStringFromCGAffineTransform([value CGAffineTransformValue]);
        return __String(@"(CGAffineTransform)%@",string);
    }
    if (strcmp(value.objCType, @encode(CATransform3D)) == 0) {
        NSString *string = NSStringFromCATransform3D([value CATransform3DValue]);
        return __String(@"(CATransform3D)%@",string);
    }
    if (strcmp(value.objCType, @encode(UIOffset)) == 0) {
        NSString *string = NSStringFromUIOffset([value UIOffsetValue]);
        return __String(@"(UIOffset)%@",string);
    }
    if (strcmp(value.objCType, @encode(UIEdgeInsets)) == 0) {
        NSString *string = NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]);
        return __String(@"(UIEdgeInsets)%@",string);
    }

    return [value description];
}



#pragma mark - NSString
                        
static inline NSArray *basicClassList()
{
    static NSArray *basicClassList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        basicClassList = @[@"NSString",@"NSURL",@"NSDate"];
    });
    return basicClassList;
}

static inline NSArray *setClassList()
{
    static NSArray *setClassList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setClassList = @[@"NSArray",@"NSSet",@"NSOrderedSet",@"NSPointerArray"];
    });
    return setClassList;
}

static inline NSString *tapString(NSString *string)
{
    return [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

static inline NSString *NSStringFromCATransform3D(CATransform3D transform)
{
    NSString *string1 = __String(@"{\n\tm11 = %g, m12 = %g, m13 = %g, m14 = %g",transform.m11,transform.m12,transform.m13,transform.m14);
    NSString *string2 = __String(@"\n\tm21 = %g, m22 = %g, m23 = %g, m24 = %g",transform.m21,transform.m22,transform.m23,transform.m24);
    NSString *string3 = __String(@"\n\tm31 = %g, m32 = %g, m33 = %g, m34 = %g",transform.m31,transform.m32,transform.m33,transform.m34);
    NSString *string4 = __String(@"\n\tm41 = %g, m42 = %g, m43 = %g, m44 = %g\n}",transform.m31,transform.m32,transform.m33,transform.m34);
    return __String(@"%@%@%@%@",string1,string2,string3,string4);
}
