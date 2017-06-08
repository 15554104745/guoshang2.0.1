//
//  MyCollcetModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollcetModel : NSObject

@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * shop_price;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * is_exchange;
@property (nonatomic, copy) NSString * rec_id;
@property (nonatomic, copy) NSString * shoplogo;
@property (nonatomic, copy) NSString * shop_title;
@property (nonatomic, copy) NSString * expect_time;
@property (nonatomic, copy) NSString * shop_id;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
