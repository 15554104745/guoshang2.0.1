//
//  GoodsInfoSecondViewController.h
//  guoshang
//
//  Created by JinLian on 16/7/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoSecondViewController : UIViewController

@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray * recommendArray;
@property (copy, nonatomic) NSString * goods_id;
@property (copy, nonatomic) NSString * attr_id;
@property (copy, nonatomic) NSString * is_exchange;
@property (copy, nonatomic) NSString * goods_attr_desc;
@property (copy, nonatomic) NSString * goods_desc;
@property (assign, nonatomic) NSInteger goodsCount;
@property (assign, nonatomic) BOOL isCollection;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * tempArray;

@end
