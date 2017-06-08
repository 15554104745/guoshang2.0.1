//
//  carModel.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/29.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "carModel.h"

@implementation carModel
+(instancetype)ModelWithDict:(NSDictionary *)dict{
    return [[carModel alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        self.rec_id = dict[@"rec_id"];
        self.user_id = dict[@"user_id"];
        self.session_id = dict[@"session_id"];
        self.goods_id =dict[@"goods_id"];
        self.goods_sn =dict[@"goods_sn"];
        self.product_id =dict[@"product_id"];
        self.goods_name =dict[@"goods_name"];
        self.market_price =dict[@"market_price"];
        self.goods_price =dict[@"goods_price"];
        self.goods_number =dict[@"goods_number"];
        self.purchase_price =dict[@"purchase_price"];
        self.pid =dict[@"pid"];
        self.d_price =dict[@"d_price"];
        self.subtotal =dict[@"subtotal"];
        self.subtotal_z =dict[@"subtotal_z"];
        self.goods_thumb =dict[@"goods_thumb"];
        self.shipping_price =dict[@"shipping_price"];
        self.isSelect = [dict[@"isSelect"] boolValue];
        self.attr_names = dict[@"attr_names"];
        self.shop_title = dict[@"shop_title"];
        
    }
    return self;
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
