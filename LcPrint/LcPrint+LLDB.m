//
//  LcPrint+LLDB.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/7.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LcPrint+LLDB.h"
#import "LcPrintObj.h"
#import "LcPrintViews.h"
#import "LcPrintMacro.h"

#if _LC_VALID

void o(id obj)
{
    printf("%s\n",[describeObj(obj, NO) UTF8String]);
}

void oo(id obj)
{
    printf("%s\n",[describeObj(obj, YES) UTF8String]);
}

void v(id view)
{
    if (![view isKindOfClass:[UIView class]]) {
        printf("this is not a view, please use 'p o(x)' instead\n");
    }
    
    printf("%s\n",[describeViews(view) UTF8String]);
}

#endif
