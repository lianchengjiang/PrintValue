//
//  ViewController.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/4.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "ViewController.h"
#import "Describe.h"
#import "Model.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SonModel *son = [SonModel new];
    son.string = @"string";
    son.number = @(3);
    son.URL = [NSURL URLWithString:@"https://www.baidu.com/"];
    son.date = [NSDate date];
    
    Model *model = [Model new];
    model.array = @[son,son];
    model.dictionary = @{@"key":son};
    model.set = [NSSet setWithObjects:son,@"son2", nil];

    NSLog(@"describe:\n%@",describe(model));
    
}

- (void)test
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
