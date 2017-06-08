//
//  GSShopTitleModel.h
//  guoshang
//
//  Created by 金联科技 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface GSShopTitleModel : JSONModel
@property(nonatomic,copy)NSString * shop_id;//id
@property(nonatomic,copy)NSString * shop_title;//标题
@property(nonatomic,copy)NSString * qq;//qq号
@property(nonatomic,copy)NSString * shoplogo;// 图片
@property(nonatomic,copy)NSString * shop_phone;//电话
@end
