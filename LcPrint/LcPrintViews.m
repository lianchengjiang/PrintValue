//
//  LcPrintAdvance.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/7.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintViews.h"
#import "LcPrintMacro.h"


static inline NSString *__describeViews(UIView *view, NSUInteger level);

NSString *describeViews(UIView *view)
{
    return __describeViews(view, 0);
}

static inline NSString *tapString(NSString *string, NSUInteger tapNum)
{
    if (string.length == 0) {
        return @"";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    for (int i = 0; i <= tapNum; i++) {
        [mutableString insertString:@"\t" atIndex:0];
    }
    
    return mutableString;
}

static inline NSString *__describeViews(UIView *view, NSUInteger level)
{
    NSMutableString *describe = [NSMutableString stringWithFormat:@"%tu 💙",level];
    [describe appendString:tapString(view.description, level)];
    NSUInteger subLevel = level + 1;
    for (UIView *subView in view.subviews) {
        [describe appendFormat:@"\n%@",__describeViews(subView, subLevel)];
    }
    return describe;
}

