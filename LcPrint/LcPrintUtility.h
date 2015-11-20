//
//  LcPrintUtility.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/8.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSArray *__lc_property_ivar_name_list(Class class);
extern NSArray *__lc_property_name_list(Class class);
extern NSArray *__lc_ivar_name_list(Class class);
extern NSArray *__lc_method_name_list(Class class);
extern NSString *__lc_tap_string(NSString *string);

extern id __lc_value_for_key(id object, NSString *key);
    extern NSString *__lc_unknown_type;
