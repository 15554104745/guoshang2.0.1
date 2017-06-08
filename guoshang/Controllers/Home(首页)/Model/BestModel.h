//
//  BestModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface BestModel : JSONModel
@property(nonatomic,copy)NSString<Optional> *promote_price;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * brief;
@property(nonatomic,copy)NSString * brand_name;
@property(nonatomic,copy)NSString * short_name;
@property(nonatomic,copy)NSString * shop_price;
@property(nonatomic,copy)NSString * thumb;
@property(nonatomic,copy)NSString * goods_img;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * short_style_name;
@end
