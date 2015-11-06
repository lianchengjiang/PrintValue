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
    LcPrint((int)1);
    LcPrint((short)1);
    LcPrint((long)1);
    LcPrint((unsigned int)1);
    LcPrint((unsigned short)1);
    LcPrint((unsigned long)1);
    LcPrint((float)1.72);
    LcPrint((double)1.432);
    LcPrint(YES);
    LcPrint((char)'c');
    LcPrint((unsigned char)'a');
    LcPrint([self class]);
    
    CGPoint point = CGPointMake(3.8, 4.1);
    CGSize size = CGSizeMake(8.3, 9.9);
    CGVector vector = CGVectorMake(0.4, 7.4);
    NSRange range = NSMakeRange(3, 4);
    CFRange cfRange = CFRangeMake(2, 6.6);
    CGAffineTransform transform = CGAffineTransformMake(1.3, 2.4, 4.5, 3, 6, 6.3);
    CATransform3D transform3D = CATransform3DIdentity;
    UIOffset offset = UIOffsetMake(5.2, 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(9.3, 3.2, 2.1, 4.5);
    CGRect rect = CGRectMake(0, 0.4, 8.3, 8.1);
    
    LcPrint(point);
    LcPrint(size);
    LcPrint(vector);
    LcPrint(range);
    LcPrint(cfRange);
    LcPrint(transform);
    LcPrint(transform3D);
    LcPrint(offset);
    LcPrint(insets);
    LcPrint(rect);
    
    Model *model = [Model new];
    model.string = @"modelString";
    model.number = @(3.54);
    model.URL = [NSURL URLWithString:@"http://www.baidu.com"];
    model.date = [NSDate date];
    model.array = @[@"a",@"b",@"c"];
    model.dictionary = @{@"key":@"valur"};
    model.set = [NSSet setWithObjects:@"set1",@"set2", nil];
    model.point = point;
    model.size = size;
    model.vector = vector;
    model.nsRange = range;
    model.cfRange = cfRange;
    model.transform = transform;
    model.transform3D = transform3D;
    model.offset = offset;
    model.edge = insets;
    model.rect = rect;
    
    LcPrint(model);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
