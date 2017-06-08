//
//  GSStoreCategoryModel.h
//  guoshang
//
//  Created by Rechied on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSStoreCategoryModel : NSObject
@property (copy, nonatomic) NSString *create_date;
@property (copy, nonatomic) NSString *update_date;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *category_id;
@property (copy, nonatomic) NSString *category_title;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *sort_order;
@end
