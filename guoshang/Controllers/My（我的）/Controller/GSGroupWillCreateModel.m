//
//  GSGroupWillCreateModel.m
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupWillCreateModel.h"

@implementation GSGroupWillCreateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",@"group_description":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"rule":@"GSGroupModelRuleModel"};
}


@end
