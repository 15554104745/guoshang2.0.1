//
//  MyHistoryModel.h
//  guoshang
//
//  Created by 陈赞 on 16/7/31.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHistoryModel : NSObject
@property (nonatomic, copy) NSString * browse_id;
@property (nonatomic, copy) NSString * browse_num;
@property (nonatomic, copy) NSString * first_browse_time;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_img;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * isCheck;
@property (nonatomic, copy) NSString * last_browse_time;
@property (nonatomic, copy) NSString * market_price;
@property (nonatomic, copy) NSString * shop_price;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
