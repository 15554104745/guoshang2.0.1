//
//  GSOrderListModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSOrderListModel : NSObject
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
@property(nonatomic,strong)NSArray * order_goods_list;//商品详情
@property(nonatomic,copy)NSString * client_info_order_date;//下单日期
@property(nonatomic,copy)NSString * client_info_order_time;//下单时间
@property(nonatomic,copy)NSString <Optional> * extension_code;//是否是国币商城
@property(nonatomic,copy)NSString <Optional> * integral;//国币个数
@property(nonatomic,copy)NSString * goods_amount;//商品的总金额
@property(nonatomic,copy)NSString * shipping_fee;//运费
@property(nonatomic,copy)NSString * goods_count;//商品总数量

@end

@interface GSOrderGoodsList :NSObject
@property (nonatomic,strong) NSArray *goods_list;
@property (nonatomic,strong) NSDictionary *shop_title;
@end


/*{
    "add_time" = 1471830777;
    address = "\U51e4\U51f0\U8def";
    "agency_id" = 0;
    "best_time" = "";
    bonus = "0.00";
    "bonus_id" = 0;
    "card_fee" = "0.00";
    "card_id" = 0;
    "card_message" = "";
    "card_name" = "";
    city = 100;
    "client_info_order_date" = "2016-08-22";
    "client_info_order_time" = "09:52:57";
    "confirm_time" = 0;
    consignee = "\U8001\U738b";
    country = 1;
    "difference_price" = "0.00";
    discount = "0.00";
    district = 895;
    email = "";
    "extension_code" = "";
    "extension_id" = 0;
    "final_price" = "0.00";
    "finished_time" = 0;
    "from_ad" = 0;
    "goods_amount" = "33.01";
    "goods_count" = 4;
    "grouppurchase_info_id" = "";
    handler = "<a href=\"user.php?act=cancel_order&order_id=6889\" onclick=\"if (!confirm('\U60a8\U786e\U8ba4\U8981\U53d6\U6d88\U8be5\U8ba2\U5355\U5417\Uff1f\U53d6\U6d88\U540e\U6b64\U8ba2\U5355\U5c06\U89c6\U4e3a\U65e0\U6548\U8ba2\U5355')) return false;\">\U53d6\U6d88\U8ba2\U5355</a>";
    "how_oos" = "";
    "how_surplus" = "";
    "insure_fee" = "0.00";
    integral = 0;
    "integral_money" = "0.00";
    "inv_content" = "";
    "inv_payee" = "";
    "inv_type" = "";
    "invoice_no" = "";
    "is_checked" = 0;
    "is_refund" = 0;
    "is_separate" = 0;
    "logistics_no" = "";
    mobile = "";
    "mobile_order" = 2;
    "mobile_pay" = 2;
    "money_paid" = "0.00";
    "o_status" = 1;
    "order_amount" = "33.01";
    "order_goods_list" =             (
                                      {
                                          "goods_list" =                     (
                                                                              {
                                                                                  "exchange_integral" = "0.00";
                                                                                  "extension_code" = "";
                                                                                  "goods_attr" = "";
                                                                                  "goods_attr_id" = 0;
                                                                                  "goods_id" = 18929;
                                                                                  "goods_name" = "\U4e16\U754c\U554a";
                                                                                  "goods_number" = 3;
                                                                                  "goods_price" = "11.00";
                                                                                  "goods_sn" = AP201608200431373967866;
                                                                                  "goods_thumb" = "http://192.168.1.168/731/Apis/Uploads/20160820/57b8156995d35.jpeg";
                                                                                  "grouppurchase_id" = "";
                                                                                  integral = 0;
                                                                                  "is_gift" = 0;
                                                                                  "is_real" = 0;
                                                                                  "market_price" = "12.00";
                                                                                  "order_id" = 6889;
                                                                                  "parent_id" = 0;
                                                                                  "product_id" = 0;
                                                                                  "rec_id" = 8270;
                                                                                  "send_number" = 0;
                                                                                  "shipping_price" = "0.00";
                                                                                  "shop_id" = 5418;
                                                                              },
                                                                              {
                                                                                  "exchange_integral" = "10.00";
                                                                                  "extension_code" = "";
                                                                                  "goods_attr" = "";
                                                                                  "goods_attr_id" = 0;
                                                                                  "goods_id" = 18923;
                                                                                  "goods_name" = "\U8089\U677e\U997c";
                                                                                  "goods_number" = 1;
                                                                                  "goods_price" = "0.01";
                                                                                  "goods_sn" = 20160819113027545791;
                                                                                  "goods_thumb" = "http://192.168.1.168:8122/userfiles/de4cd132377a44089ea3b528cf740362/images/photo/2016/08/u%3D310171899%2C2523996938%26fm%3D21%26gp%3D0.jpg";
                                                                                  "grouppurchase_id" = "";
                                                                                  integral = 1;
                                                                                  "is_gift" = 0;
                                                                                  "is_real" = 0;
                                                                                  "market_price" = "10.00";
                                                                                  "order_id" = 6889;
                                                                                  "parent_id" = 0;
                                                                                  "product_id" = 0;
                                                                                  "rec_id" = 8271;
                                                                                  "send_number" = 0;
                                                                                  "shipping_price" = "0.00";
                                                                                  "shop_id" = 5421;
                                                                              }
                                                                              );
                                          "shop_title" =                     {
                                              qq = 373849112;
                                              "shop_id" = 5421;
                                              "shop_phone" = 15552520876;
                                              "shop_title" = "\U7f8e\U5c11\U5973\U7684\U805a\U96c6\U5730";
                                              shoplogo = "http://192.168.1.168:8122/userfiles/de4cd132377a44089ea3b528cf740362/images/photo/2016/08/logo.jpg";
                                          };
                                      }
                                      );

    "order_queue_status" = 2;
    "order_status" = "\U5f85\U4ed8\U6b3e";
    "pack_fee" = "0.00";
    "pack_id" = 0;
    "pack_name" = "";
    "parent_id" = 0;
    "pay_fee" = "0.00";
    "pay_id" = 0;
    "pay_name" = "";
    "pay_note" = "";
    "pay_status" = 0;
    "pay_time" = 0;
    postscript = "";
    province = 7;
    "purchase_price" = "8.00";
    "rechargeable_card_code" = "";
    "rechargeable_card_money" = "0.00";
    referer = "";
    "shipping_date" = "1970-01-01";
    "shipping_fee" = "0.00";
    "shipping_id" = 0;
    "shipping_name" = "";
    "shipping_status" = 0;
    "shipping_time" = "08:00:00";
    "sign_building" = "";
    surplus = "0.00";
    tax = "0.00";
    tel = 18863498565;
    "to_buyer" = "";

    zipcode = "";
},
*/