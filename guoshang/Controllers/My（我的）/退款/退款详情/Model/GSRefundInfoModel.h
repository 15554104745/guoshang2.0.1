//
//  GSRefundInfoModel.h
//  guoshang
//
//  Created by 金联科技 on 16/10/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSRefundInfoModel : NSObject

//id
@property (nonatomic,copy) NSString *ID;

//产品ID
@property (nonatomic,copy) NSString *goods_id;
//店铺ID
@property (nonatomic,copy) NSString *shop_id;

//订单编号
@property (nonatomic,copy) NSString *order_sn;
//退款编号
@property (nonatomic,copy) NSString *return_order_sn;
//商家
@property (nonatomic,copy) NSString *consignee;
//电话
@property (nonatomic,copy) NSString *mobile;
//商家理由
@property (nonatomic,copy) NSString *adminnote;
//用户理由
@property (nonatomic,copy) NSString *usernote;
//钱款去向
@property (nonatomic,copy) NSString *fund;
//状态
@property (nonatomic,copy) NSString *status;
//退款金额
@property (nonatomic,copy) NSString *total_fee;
//时间
@property (nonatomic,copy) NSString *add_time;
//。。时间
@property (nonatomic,copy) NSString *updated_at;

@property (nonatomic,copy) NSString *referer;
@property (nonatomic,copy) NSString *order_amount;
@property (nonatomic,copy) NSString *shop_name;

@property (nonatomic,strong) NSArray *consult;

@end

@interface GSConsultModel : NSObject

@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *defaultSetting;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *referer;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *return_order_sn;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *operatorL;
@property (nonatomic,copy) NSString *reason;



@end
