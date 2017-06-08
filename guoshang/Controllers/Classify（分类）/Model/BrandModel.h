//
//  BrandModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface BrandModel : JSONModel

@property (copy, nonatomic) NSString * brand_id;
@property (copy, nonatomic) NSString * brand_name;
@property (copy, nonatomic) NSString * goods_num;
@property (copy, nonatomic) NSNumber * selected;

@end
