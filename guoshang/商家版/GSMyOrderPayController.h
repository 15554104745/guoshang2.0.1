//
//  GSMyOrderPayController.h
//  guoshang
//
//  Created by 金联科技 on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMyOrderModel.h"
#import "GSOrderDetailViewController.h"
@interface GSMyOrderPayController : UIViewController

//商店id
@property (nonatomic,copy) NSString *shopID;
//订单id
@property (nonatomic,copy) NSString *orderID;
//总价
@property (nonatomic,copy) NSString *all_goods_price;
//数量
@property (nonatomic,copy) NSString *all_goods_count;
@property (nonatomic,assign)GSOrderType  orderType;
//订单列表进入是NO 详情页面进入是YES
@property (nonatomic,assign) BOOL isOrder;
- (void)pusheVC;

@end
