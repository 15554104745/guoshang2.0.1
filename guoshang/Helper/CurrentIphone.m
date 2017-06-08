//
//  CurrentIphone.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "CurrentIphone.h"

@implementation CurrentIphone
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S ";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5 ";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5 ";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c ";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c)";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s ";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus ";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6 ";
    if ([deviceString isEqualToString:@"iPhone7,3"]) return @"iPhone 6s ";
    if ([deviceString isEqualToString:@"iPhone7,4"]) return @"iPhone 6 sPlus ";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"i386"])       return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])     return @"Simulator";
        
   return deviceString;
}
@end
