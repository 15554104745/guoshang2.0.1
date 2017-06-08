//
//  GSOrderModel.h
//  guoshang
//
//  Created by Rechied on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSOrderTotalModel.h"
@interface GSOrderModel : NSObject

@property (copy, nonatomic) NSString *pay_fee;
@property (copy, nonatomic) NSString *parent_id;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *bonus;
@property (copy, nonatomic) NSString *card_message;
@property (copy, nonatomic) NSString *pay_name;
@property (copy, nonatomic) NSString *rechargeable_card_code;
@property (copy, nonatomic) NSString *pack_fee;
@property (copy, nonatomic) NSString *surplus;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *is_separate;
@property (copy, nonatomic) NSString *purchase_price;
@property (copy, nonatomic) NSString *card_id;
@property (copy, nonatomic) NSString *how_oos;
@property (copy, nonatomic) NSString *shipping_time;
@property (copy, nonatomic) NSString *grouppurchase_info_id;
@property (copy, nonatomic) NSString *integral;
@property (copy, nonatomic) NSString *inv_payee;
@property (copy, nonatomic) NSString *agency_id;
@property (copy, nonatomic) NSString *pack_id;
@property (copy, nonatomic) NSString *o_status;
@property (copy, nonatomic) NSString *from_ad;
@property (copy, nonatomic) NSString *confirm_time;
@property (copy, nonatomic) NSString *pay_id;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *card_name;
@property (copy, nonatomic) NSString *shipping_status;
@property (copy, nonatomic) NSString *shipping_name;
@property (copy, nonatomic) NSString *insure_fee;
@property (copy, nonatomic) NSArray *shop_list;
@property (copy, nonatomic) NSString *goods_amount;
@property (copy, nonatomic) NSString *order_queue_status;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *how_surplus;
@property (copy, nonatomic) NSString *referer;
@property (copy, nonatomic) NSString *card_fee;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *to_buyer;
@property (copy, nonatomic) NSString *extension_id;
@property (copy, nonatomic) NSString *pay_note;
@property (copy, nonatomic) NSString *mobile_pay;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *logistics_no;
@property (copy, nonatomic) NSString *pay_time;
@property (copy, nonatomic) NSString *pack_name;
@property (copy, nonatomic) NSString *difference_price;
@property (copy, nonatomic) NSString *sign_building;
@property (copy, nonatomic) NSString *best_time;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *extension_code;
@property (copy, nonatomic) NSString *is_checked;
@property (copy, nonatomic) NSString *is_refund;
@property (copy, nonatomic) NSString *pay_status;
@property (copy, nonatomic) NSString *bonus_id;
@property (copy, nonatomic) NSString *money_paid;
@property (copy, nonatomic) NSString *mobile_order;
@property (copy, nonatomic) NSString *order_sn;
@property (copy, nonatomic) NSString *consignee;
@property (copy, nonatomic) NSString *final_price;
@property (copy, nonatomic) NSString *order_status;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *shipping_id;
@property (copy, nonatomic) NSString *inv_content;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *zipcode;
@property (copy, nonatomic) NSString *shipping_fee;
@property (copy, nonatomic) NSString *integral_money;
@property (copy, nonatomic) NSString *inv_type;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *order_amount;
@property (copy, nonatomic) NSString *finished_time;
@property (copy, nonatomic) NSString *rechargeable_card_money;
@property (copy, nonatomic) NSString *tax;
@property (copy, nonatomic) NSString *o_status_desc;
@property (copy, nonatomic) NSString *invoice_no;
@property (copy, nonatomic) NSString *postscript;
@property (copy, nonatomic) NSString *discount;
@property (nonatomic,strong) GSOrderTotalModel *total;

@end
