//
//  addressModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface addressModel : JSONModel

@property(nonatomic,copy)NSString<Optional> * address_id;
@property(nonatomic,copy)NSString<Optional> * address_name;//
@property(nonatomic,copy)NSString  * user_id;
@property(nonatomic,copy)NSString<Optional> * consignee;//姓名
@property(nonatomic,copy)NSString<Optional> * country;//国家
@property(nonatomic,copy)NSString<Optional> * province;//省
@property(nonatomic,copy)NSString<Optional> * city;//城市
@property(nonatomic,copy)NSString<Optional> * district;//区
@property(nonatomic,copy)NSString<Optional> * address;//详细地址
@property(nonatomic,copy)NSString<Optional> * mobile;//手机号
@property(nonatomic,copy)NSString<Optional> * email;

@property(nonatomic,copy)NSString <Optional> *tel;
@end
