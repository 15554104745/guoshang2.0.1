//
//  GSGoodsDetailSingleClass.m
//  guoshang
//
//  Created by JinLian on 16/9/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailSingleClass.h"

static GSGoodsDetailSingleClass *singleClass = nil;

@implementation GSGoodsDetailSingleClass

+ (instancetype)sharInstance {
    
    if (!singleClass) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleClass = [[super allocWithZone:NULL]init];
        });
    }
    return singleClass;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharInstance];
}
+ (instancetype)new {
    return [self sharInstance];
}
- (id)copyWithZone:(struct _NSZone *)zone {
    return [GSGoodsDetailSingleClass sharInstance];
}

@end
