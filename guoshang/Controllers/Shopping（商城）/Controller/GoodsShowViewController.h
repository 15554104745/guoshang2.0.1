//
//  GoodsShowViewController.h
//  guoshang
//
//  Created by 张涛 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GoodsShowViewController : UIViewController

@property (copy, nonatomic) NSString * goodId;
//数据数组
@property (strong, nonatomic) NSMutableArray * dataArray;
//图片数组
@property (strong, nonatomic) NSMutableArray * picArray;

@property (nonatomic, strong) UIScrollView * scrollView;

@property(nonatomic,strong)NSString * from;

@end
