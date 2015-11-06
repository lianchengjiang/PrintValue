//
//  LcPrint.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/5.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _LC_VALID_ONLY_DEBUG  1

#define _LC_VALID  (!_LC_VALID_ONLY_DEBUG||DEBUG)


#if _LC_VALID

#define __FILE_PATH__     [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]
#define LcPrint(x)  printf("❤️%s, %s, Line:%d\n%s = %s\n", __FILE_PATH__, __PRETTY_FUNCTION__, __LINE__, __STRING(x), [describeVar(@encode(typeof(x)),x) UTF8String])

#else

#define LcPrint(x)

#endif

extern NSString *describeObj(id object);
extern NSString *describeVar(const char *type, ...);
extern void LcPrintObj(id obj);


