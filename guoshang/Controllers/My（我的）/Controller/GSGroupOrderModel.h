//
//  GSGroupOrderModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSGroupOrderModel : NSObject
//订单ID
@property (nonatomic,copy) NSString *order_id;
//订单编码
@property (nonatomic,copy) NSString *order_sn;
//标题
@property (nonatomic,copy) NSString *title;

//团购状态
@property (nonatomic,copy) NSString *status;
//最大用户参团人数
@property (nonatomic,copy) NSString *max_user_amount;

@property (nonatomic,copy) NSString *user_num;
@property (nonatomic,copy) NSString *group_price;
//团购Id
@property (nonatomic,copy) NSString *tuan_id;
//图片
@property (nonatomic,copy) NSString *goods_img;
//状态描述
@property (nonatomic,copy) NSString *status_desc;
//团购价格
@property (nonatomic,copy) NSString *price;
//团购描述
@property (nonatomic,copy) NSString *descrip;
//状态显示代付款等
@property (nonatomic,copy) NSString *o_status_desc;
@property (nonatomic,copy) NSString *refund;
@end

