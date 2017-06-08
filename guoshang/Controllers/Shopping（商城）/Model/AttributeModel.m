//
//  AttributeModel.m
//  guoshang
//
//  Created by 张涛 on 16/3/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "AttributeModel.h"

@implementation AttributeModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }

}

@end
