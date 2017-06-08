//
//  GSGroupDetailModel.h
//  guoshang
//
//  Created by Rechied on 16/8/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSGroupGoodsInfoModel;
@interface GSGroupDetailModel : NSObject
@property (nonatomic,strong) GSGroupGoodsInfoModel *goods_info;
@property (nonatomic,strong) NSArray *tuan_rule;
@property (nonatomic,copy) NSString *sale_total;

@end
