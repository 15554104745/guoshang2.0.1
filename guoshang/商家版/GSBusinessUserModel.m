//
//  GSBusinessUserModel.m
//  guoshang
//
//  Created by Rechied on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessUserModel.h"

@implementation GSBusinessUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"new_num":@"now_num"};
}
@end
