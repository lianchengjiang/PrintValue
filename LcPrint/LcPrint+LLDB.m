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
#import "LcPrintAdvance.h"

#if DEBUG

void o(id obj)
{
    printf("❤️RootClass: %s\n",[describeObj(obj) UTF8String]);
}

void v(id view)
{
    if (![view isKindOfClass:[UIView class]]) {
        printf("this is not a view, please use 'p o(x)' instead\n");
    }
    
    printf("❤️%s\n",[describeViews(view) UTF8String]);
}

#endif
