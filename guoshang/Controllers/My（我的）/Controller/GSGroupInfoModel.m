//
//  GSGroupInfoModel.m
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupInfoModel.h"
#import "MJExtension.h"
#import "GSGroupUserModel.h"
@implementation GSGroupInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"descrip" : @"description",
             @"price" : @"init_price",
             };
    
}
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"group_user_list":[GSGroupUserModel class]};
}
@end
