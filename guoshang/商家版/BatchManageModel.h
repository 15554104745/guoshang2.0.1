//
//  BatchManageModel.h
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BaseModel.h"
@interface BatchManageModel : BaseModel

@property(assign,nonatomic)BOOL selectState;//是否选中状态

@property (nonatomic, copy)NSString *add_time,*goods_img,*goods_name,*goods_number,*goods_save,*market_price,*shop_price,*sale_number,*goods_id,*sale_num, *collect_num;

@end
