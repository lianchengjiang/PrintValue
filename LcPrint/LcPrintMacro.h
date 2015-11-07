//
//  LcPrintMacro.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/7.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//


#define _LC_VALID_ONLY_DEBUG  1
#define _LC_VALID  (!_LC_VALID_ONLY_DEBUG||DEBUG)

#define __LcString(fmt, ...)  [NSString stringWithFormat:fmt, ##__VA_ARGS__]

