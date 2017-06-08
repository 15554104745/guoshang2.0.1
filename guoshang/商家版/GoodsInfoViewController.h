//
//  GoodsInfoViewController.h
//  guoshang
//
//  Created by JinLian on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsInfoViewController : UIViewController

@property (copy, nonatomic) NSString * goodId;
//数据数组
@property (strong, nonatomic) NSMutableArray * dataArray;
//图片数组
@property (strong, nonatomic) NSMutableArray * picArray;

//判断是从用户版进入还是从商家版进入  用户版为1  商家版为2
@property (nonatomic, assign)NSInteger userStyle;

//判断是从库存获取详情信息还是 从其他页面获取信息  库存为0   其他页面为非0
@property (nonatomic, assign)int incomStyle;



@end

