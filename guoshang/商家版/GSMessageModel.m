//
//  GSMessageModel.m
//  guoshang
//
//  Created by 金联科技 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMessageModel.h"

@implementation GSMessageModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}

@end
