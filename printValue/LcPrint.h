//
//  LcPrint.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/5.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LcPrintObj.h"


#ifndef LcPrint_h
#define LcPrint_h

#if DEBUG
#define __FILE_PATH__     [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]

#define LcPrint(x)  printf("❤️ %s, %s, Line:%d \n%s\n", __FILE_PATH__, __PRETTY_FUNCTION__, __LINE__,       \
                        [describeVar(@encode(__typeof__(x)),x) UTF8String]);

#else

#define LcPrint(x)

#endif

extern void LcPrintObj(id obj);

#endif /* LcPrint_h */
