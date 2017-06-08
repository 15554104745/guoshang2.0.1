//
//  CategoryModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface CategoryModel : JSONModel

@property (copy, nonatomic) NSString * cat_id;
@property (copy, nonatomic) NSString * cat_name;
@property (copy, nonatomic) NSNumber * selected;

@end
