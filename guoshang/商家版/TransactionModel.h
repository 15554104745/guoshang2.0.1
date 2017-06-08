//
//  TransactionModel.h
//  guoshang
//
//  Created by JinLian on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BaseModel.h"

@interface TransactionModel : BaseModel

@property (nonatomic, copy)NSString *add_time, *amount_desc, *o_status,*order_sn,*total_fee,*trade_desc;


@end
