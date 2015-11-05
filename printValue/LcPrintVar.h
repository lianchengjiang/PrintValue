//
//  LcPrintVar.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/5.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG

#define __String(fmt, ...)  [NSString stringWithFormat:fmt, ##__VA_ARGS__]

extern NSString *describeVar(const char * type, ...);


#endif