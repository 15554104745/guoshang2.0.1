//
//  GSGroupDetailModel.m
//  guoshang
//
//  Created by Rechied on 16/8/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupDetailModel.h"
#import "GSGroupGoodsInfoModel.h"
#import "GSGroupRuleModel.h"
#import "MJExtension.h"
@implementation GSGroupDetailModel


+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"tuan_rule":[GSGroupRuleModel class]};
}
@end
