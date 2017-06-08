//
//  GSRefundInfoModel.m
//  guoshang
//
//  Created by 金联科技 on 16/10/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSRefundInfoModel.h"
#import "MJExtension.h"
@implementation GSRefundInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"consult" : @"GSConsultModel"};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"};
}
@end

@implementation GSConsultModel : NSObject
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",@"operatorL":@"operator"};
}
@end