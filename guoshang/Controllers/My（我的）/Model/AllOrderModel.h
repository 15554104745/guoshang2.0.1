//
//  AllOrderModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"
#import "goodsModel.h"
@interface AllOrderModel : JSONModel
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * order_sn;//订单号
@property(nonatomic,copy)NSString * user_id;//用户Id
@property(nonatomic,copy)NSString * o_status;//订单状态
@property(nonatomic,copy)NSString * order_status;//订单状态  0未确认1已确认 2已取消 3无效 4退货 5已分单
@property(nonatomic,copy)NSString * shipping_status;//发货状态 0未发货1已发货 2已取消 3配货中 5发货中
@property(nonatomic,copy)NSString * pay_status;//支付状态  0未付款  1付款中 2已付款
@property(nonatomic,copy)NSString * consignee;//收货人的姓名   用户页面填写  默认取值表user_address
@property(nonatomic,copy)NSString * country;//收货人国家
@property(nonatomic,copy)NSString * province;//收货人的省份
@property(nonatomic,copy)NSString * city;//收货人的城市
@property(nonatomic,copy)NSString * district;//收货人的地区
@property(nonatomic,copy)NSString * address;//收货人的详细地址
@property(nonatomic,copy)NSString * pay_id;//用户选择的支付方式
@property(nonatomic,strong)NSDictionary * order_goods_list;//商品详情
@property(nonatomic,copy)NSString * client_info_order_date;//下单日期
@property(nonatomic,copy)NSString * client_info_order_time;//下单时间
@property(nonatomic,copy)NSString <Optional> * extension_code;//是否是国币商城
@property(nonatomic,copy)NSString <Optional> * integral;//国币个数
@property(nonatomic,copy)NSString * goods_amount;//商品的总金额
@property(nonatomic,copy)NSString * shipping_fee;//运费
@property(nonatomic,copy)NSString * goods_count;//商品总数量
//@property(nonatomic,copy)NSArray <GoodsModel,ConvertOnDemand> * model;

@end

