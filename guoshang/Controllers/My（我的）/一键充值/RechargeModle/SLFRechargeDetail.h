//
//  SLFRechargeDetail.h
//  guoshang
//
//  Created by 时礼法 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFRechargeDetail : JSONModel

@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * change_time;
@property(nonatomic,copy)NSString * change_type;
@property(nonatomic,copy)NSString * short_change_desc;
//@property(nonatomic,copy)NSString * amount_org;
//@property(nonatomic,copy)NSString * is_paid;

@end
