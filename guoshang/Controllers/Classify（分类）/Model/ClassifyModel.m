//
//  ClassifyModel.m
//  guoshang
//
//  Created by 张涛 on 16/3/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel


//转换ID


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
