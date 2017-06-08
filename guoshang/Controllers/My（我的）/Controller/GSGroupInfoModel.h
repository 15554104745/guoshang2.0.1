//
//  GSGroupInfoModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSGroupInfoModel : NSObject
//标题
@property (nonatomic,copy) NSString *title;
//状态
@property (nonatomic,copy) NSString *status;
//产品ID
@property (nonatomic,copy) NSString *goods_id;
//最大参团人数
@property (nonatomic,copy) NSString *max_user_amount;
//数组
@property (nonatomic,strong)NSArray *group_user_list;
@property (nonatomic,strong)NSDictionary *goods_info;
//图片
@property (nonatomic,copy) NSString *goods_img;
//价格
@property (nonatomic,copy) NSString *group_price;
//描述
@property (nonatomic,copy) NSString *descrip;
//几人团
@property (nonatomic,copy) NSString *user_num;
//几人团
@property (nonatomic,copy) NSString *audit_state;

@end
