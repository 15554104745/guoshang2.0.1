//
//  GroupInfoModel.m
//  guoshang
//
//  Created by JinLian on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupInfoModel.h"

@implementation GroupInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"rules" : @"rules",
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"desc":@"description",
             @"ID":@"id",
             };
}
@end

