//
//  LcPrint+LLDB.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/7.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LcPrint+LLDB.h"
#import "LcPrintObj.h"

#if DEBUG

void o(id obj)
{
    printf("%s\n",[describeObj(obj) UTF8String]);
}

#endif
