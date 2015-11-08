//
//  LcPrintInner.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/8.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintInner.h"
#import "LcPrintMacro.h"
#import <objc/runtime.h>
#import "LcPrintUtility.h"

static inline NSString *__describeInner(id object, Class class, BOOL circle);

NSString *describInner(id object, BOOL circlePrintSuper)
{
    return __describeInner(object, [object class], circlePrintSuper);
}

static inline NSString *__describeVar(Class class)
{
    NSMutableString *varString = [NSMutableString string];
    [varString appendFormat:@"@Ivar{"];
    NSArray *nameList = __lc_ivar_name_list(class);
    for (NSString *name in nameList) {
        [varString appendFormat:@"\n\t%@",name];
    }
    [varString appendFormat:@"\n}"];
    return varString;
}

static inline NSString *__describeProperty(Class class)
{
    NSMutableString *propertyString = [NSMutableString string];
    [propertyString appendFormat:@"@Property{"];
    NSArray *nameList = __lc_property_name_list(class);
    for (NSString *name in nameList) {
        [propertyString appendFormat:@"\n\t%@",name];
    }
    [propertyString appendFormat:@"\n}"];
    return propertyString;
}

static inline NSString *__describeMethod(Class class)
{
    NSMutableString *methodString = [NSMutableString string];
    [methodString appendString:@"@Method{"];
    
    //normal class
    NSArray *nameList = __lc_method_name_list(class);
    for (NSString *name in nameList) {
        [methodString appendFormat:@"\n\t-%@",name];
    }
    
    //meta class
    const char *className = [NSStringFromClass(class) UTF8String];
    NSArray *metaNameList = __lc_method_name_list(objc_getMetaClass(className));
    for (NSString *name in metaNameList) {
        [methodString appendFormat:@"\n\t+%@",name];
    }
    
    [methodString appendString:@"\n}"];
    return methodString;
}


static inline NSString *__describeInner(id object, Class class, BOOL circle)
{
    NSMutableString *describe = [NSMutableString string];
    
    [describe appendFormat:@"(%@ *){",class];
    //super class
    if (circle && ![NSObject isSubclassOfClass:class]) {
        NSString *superInner = __describeInner(object, class_getSuperclass(class), circle);
        [describe appendString:__lc_tap_string(__LcString(@"\n%@",superInner))];
    }

    [describe appendString:__lc_tap_string(__LcString(@"\n%@",__describeVar(class)))];
    [describe appendString:__lc_tap_string(__LcString(@"\n%@",__describeProperty(class)))];
    [describe appendString:__lc_tap_string(__LcString(@"\n%@",__describeMethod(class)))];
    [describe appendFormat:@"\n}(%@ *)",class];
    return describe;
}


