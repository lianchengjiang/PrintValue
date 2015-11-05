//
//  ViewController.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/4.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "LcPrint.h"
#import "LcPrintVar.h"
#import "LcPrintObj.h"

#define TEST_TYPE(TYPE)     {   \
TYPE a = (TYPE)97;              \
LcPrint(a)                      \
}


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    
    [self test];
}


- (void)test
{
    TEST_TYPE(int);
    TEST_TYPE(short);
    TEST_TYPE(long);
    TEST_TYPE(long long);
    TEST_TYPE(unsigned int);
    TEST_TYPE(unsigned short);
    TEST_TYPE(unsigned long);
    TEST_TYPE(unsigned long long);
    TEST_TYPE(float);
    TEST_TYPE(double);
    TEST_TYPE(BOOL);
    TEST_TYPE(char);
    TEST_TYPE(unsigned char);
    
    LcPrint([self class]);
    LcPrint(CGPointMake(3.8, 4.1));
    LcPrint(CGSizeMake(8.3, 9));
    LcPrint(CGVectorMake(0.4, 7.4));
    LcPrint(NSMakeRange(3, 6.4));
    LcPrint(CFRangeMake(2, 6.6));
    LcPrint(CGAffineTransformMake(1.3, 2.4, 4.5, 3, 6, 6.3));
    LcPrint(CATransform3DIdentity);
    LcPrint(UIOffsetMake(5.2, 2));
    LcPrint(UIEdgeInsetsMake(9, 3, 2, 4));
    LcPrint(CGRectMake(0, 0.4, 8.3, 8.1));
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
