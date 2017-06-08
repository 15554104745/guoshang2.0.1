//
//  GSClassfiyModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSClassfiyModel.h"

@implementation GSClassfiyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cat_id":@"GSClassfiyMenuModel"};
}
@end
