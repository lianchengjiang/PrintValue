//
//  LcPrint+LLDB.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/7.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "LcPrintMacro.h"

#if _LC_VALID


extern void o(id obj);  //print object's value. you can use it in lldb: `p o()`
extern void oo(id obj); //circle print super class's value. use it in lldb: `p oo()`
extern void v(id view); //circle print view's subview. use it in lldb: `p v()`
extern void i(id obj);  //print object's inner. use it in lldb: `p i()`
extern void ii(id obj); //circle print super class of object's inner. use it in lldb: `p ii()`

#endif