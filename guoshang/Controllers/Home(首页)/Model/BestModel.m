//
//  BestModel.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BestModel.h"

@implementation BestModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
