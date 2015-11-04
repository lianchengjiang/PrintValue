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

static inline NSArray *baseClassList();
static inline NSArray *setClassList();
static inline NSString *tapString(NSString *string);

static inline NSString *printValueOfBaseClass(NSString *classString,id model);
static inline NSString *printValueOfSet(NSString *setClass,NSSet *list);
static inline NSString *printValueOfDictionary(NSDictionary *map);
static inline NSString *printValueOfModel(id model);


NSString *printValue(id model)
{
    if (model == nil)
    {
        return @"nil";
    }

    for (NSString *classString in baseClassList())
    {
        if ([model isKindOfClass:NSClassFromString(classString)]){
            return printValueOfBaseClass(classString,model);
        }
    }
    
    for (NSString *setClass in setClassList()) {
        if ([model isKindOfClass:NSClassFromString(setClass)]) {
            return printValueOfSet(setClass, (NSSet *)model);
        }
    }
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        return printValueOfDictionary((NSDictionary *)model);
    }
    
    return printValueOfModel(model);
}

#pragma mark - handle

static inline NSString *printValueOfBaseClass(NSString *classString,id model)
{
    return [NSString stringWithFormat:@"(%@ *)%@",classString,model];
}

static inline NSString *printValueOfSet(NSString *setClass,NSSet *list)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendFormat:@"(%@ *)[",setClass];
    for (id value in list) {
        NSString *string = [NSString stringWithFormat:@"\n%@",printValue(value)];
        [value appendString:tapString(string)];
    }    [printString appendString:@"\n]"];
    return printString;
}

static inline NSString *printValueOfDictionary(NSDictionary *map)
{
    NSMutableString *printString = [NSMutableString string];
    [printString appendString:@"{"];
    for (id key in map.allKeys) {
        NSString *string = [NSString stringWithFormat:@"\n%@:%@",key,printValue(map[key])];
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
        NSString *string = [NSString stringWithFormat:@"\n%@ = %@",@(name),printValue(value)];
        [printString appendString:tapString(string)];
    }
    [printString appendString:@"\n}"];
    return printString;
}


#pragma mark - NSString
static inline NSArray *baseClassList()
{
    static NSArray *baseClassList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseClassList = @[@"NSString",@"NSNumber",@"NSAttributedString",@"NSBundle",
                          @"NSCache",@"NSCalendar",@"NSCharacterSet",@"NSCoder",
                          @"NSData",@"NSDate",@"NSFormatter",@"NSIndexPath",
                          @"NSIndexSet",@"NSInvocation",@"NSItemProvider",
                          @"NSNotification",@"NSThread",@"NSTimer",@"NSTimeZone",
                          @"NSURL"];
    });
    return baseClassList;
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
    //最后一个字符不要，避免最后是换行符把下一行也加tap了。
    NSRange range = NSMakeRange(0, string.length - 1);
    NSString *tapString = [string stringByReplacingOccurrencesOfString:@"\n"
                                                            withString:@"\n\t"
                                                               options:0
                                                                 range:range];
    tapString = [NSString stringWithFormat:@"\t%@",tapString];
    return tapString;
    
}
