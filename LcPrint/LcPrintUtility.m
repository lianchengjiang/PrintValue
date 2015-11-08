//
//  LcPrintUtility.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/8.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintUtility.h"
#import <objc/runtime.h>

static inline NSString *propertyNameFromIvarName(NSString *name);


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

#pragma mark - inline

static inline NSString *propertyNameFromIvarName(NSString *name)
{
    return [name stringByReplacingOccurrencesOfString:@"_"
                                           withString:@""
                                              options:0
                                                range:NSMakeRange(0, 1)];
}
