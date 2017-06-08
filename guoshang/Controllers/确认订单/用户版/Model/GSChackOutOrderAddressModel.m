//
//  GSChackOutOrderAddressModel.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderAddressModel.h"

@implementation GSChackOutOrderAddressModel

- (NSString *)getAppendAddress {
    NSMutableString *tempString = [[NSMutableString alloc] initWithString:[self getAppendAddressNoDetailAddress]];
    [tempString appendString:@" "];
    [tempString appendString:self.address];
    return [[NSString alloc] initWithString:tempString];
}

- (NSString *)getAppendAddressNoDetailAddress {
    NSMutableString *tempString = [[NSMutableString alloc] initWithCapacity:0];
    [tempString appendString:self.province];
    [tempString appendString:@" "];
    [tempString appendString:self.city];
    [tempString appendString:@" "];
    [tempString appendString:self.district];
    return [[NSString alloc] initWithString:tempString];
}

- (NSString *)getGoodsDetailAddress {
    NSMutableString *tempString = [[NSMutableString alloc] initWithCapacity:0];
    [tempString appendString:self.province];
    [tempString appendString:@">"];
    [tempString appendString:self.city];
    [tempString appendString:@">"];
    [tempString appendString:self.district];
    return [[NSString alloc] initWithString:tempString];
}

@end
