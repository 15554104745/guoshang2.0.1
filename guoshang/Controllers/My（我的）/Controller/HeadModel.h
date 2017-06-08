//
//  HeadModel.h
//  guoshang
//
//  Created by JinLian on 16/8/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface HeadModel : BaseModel

@property (nonatomic, copy)NSString *avatar, *end_tamp, *end_time, *group_id, *group_purchase_number, *real_name, *start_tamp, *start_timem, *store_name, *user_name, *remain_time,*title,*is_clerk,*group_price,*user_num;

@end


/**
 *   avatar = "http://192.168.1.168/Public/Api/avatar/default_avatar.jpg";
 "end_tamp" = 1471489563;
 "end_time" = "2016-08-18 11:06:03";
 "group_id" = 542338A05FCA7620A1A95CD1F6F94640;
 "group_purchase_number" = 1;
 "real_name" = "<null>";
 "start_tamp" = 1471489363;
 "start_time" = "2016-08-18 11:02:43";
 "store_name" = "";
 "user_name" = 15666777870;
 
 */