//
//  Model.h
//  PrintValueSample
//
//  Created by jiangliancheng on 15/11/4.
//  Copyright © 2015年 jiangliancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FatherModel : NSObject
{
    CGSize size;
}
//@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGVector vector;
@property (nonatomic, assign)CGRect rect;
@property (nonatomic, assign)NSRange nsRange;
@property (nonatomic, assign)CFRange cfRange;
@property (nonatomic, assign)CGAffineTransform transform;
@property (nonatomic, assign)CATransform3D transform3D;
@property (nonatomic, assign)UIOffset offset;
@property (nonatomic, assign)UIEdgeInsets edge;


@end



@interface Model : FatherModel
{
    NSURL *_URL;
}
//@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)NSNumber *number;
//@property (nonatomic, strong)NSURL *URL;
@property (nonatomic, strong)NSSet *set;
@property (nonatomic, strong)NSDictionary *dictionary;




@end

@interface SonModel : Model
{
    NSString * _string;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, assign)CGPoint point;
@property (nonatomic, strong)NSArray *array;

- (void)setIvar;

@end

