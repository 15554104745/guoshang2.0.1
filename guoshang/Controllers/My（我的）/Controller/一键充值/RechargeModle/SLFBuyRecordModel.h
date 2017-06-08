//
//  SLFBuyRecordModel.h
//  guoshang
//
//  Created by 时礼法 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFBuyRecordModel : JSONModel

@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * user_note;
@property(nonatomic,copy)NSString * admin_note;
@property(nonatomic,copy)NSString * is_paid;
@property(nonatomic,copy)NSString * amount_org;
@property(nonatomic,copy)NSString * ID;


@end
