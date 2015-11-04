//
//  ViewController.m
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/4.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import "ViewController.h"
#import "PModel.h"



@interface HotWordItem :NSObject

@property(nonatomic, copy)NSString *title;///< 是真正的检索关键词
@property(nonatomic, copy)NSURL *url;
@property(nonatomic, copy)NSDate *date;
@property(nonatomic, copy)NSIndexSet *indexSet;
@property(nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)CGRect rect;
@property(nonatomic, strong)NSData *data;
@property(nonatomic, assign)CATransform3D transform;
//ignore
@property(nonatomic, assign)CGFloat fontSize;   // 字体大小
@end

@interface HotWordModel : NSObject
@property(nonatomic, strong)NSArray<HotWordItem *> *itemList;
@property(nonatomic, copy)NSString *nsclickP;
@end

@implementation HotWordItem
@end

@implementation HotWordModel
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString *string = [NSMutableString stringWithString:@"aa"];
    [string appendString:@"bb"];
    
    HotWordItem *item = [HotWordItem new];
    item.url = [NSURL URLWithString:@"http://www.baidu.com"];
    item.title = @"aa";
    item.date = [NSDate date];
    item.indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 40)];
    item.indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    item.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:NO];
    item.transform = CATransform3DIdentity;
    
    HotWordModel *model = [HotWordModel new];
    model.itemList = @[item,item];

//    NSLog(@"%@",printValue(model));
    printValue(self);
    
}

- (void)test
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
