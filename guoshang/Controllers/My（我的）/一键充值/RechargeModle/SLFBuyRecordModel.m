//
//  SLFBuyRecordModel.m
//  guoshang
//
//  Created by 时礼法 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFBuyRecordModel.h"

@implementation SLFBuyRecordModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
