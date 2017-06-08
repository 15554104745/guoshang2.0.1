//
//  RecomendModel.m
//  guoshang
//
//  Created by 张涛 on 16/3/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "RecomendModel.h"

@implementation RecomendModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.goods_id = value;
    }
    if ([key isEqualToString:@"thumb"]) {
        self.goods_thumb = value;
    }
}

@end
