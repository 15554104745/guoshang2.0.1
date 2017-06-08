//
//  CoreNetWorking.m
//  guoshang
//
//  Created by JinLian on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "CoreNetWorking.h"

@implementation CoreNetWorking


+ (NSString *)getParamsStringWithParams:(NSDictionary *)params {
    
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    
    for (NSString *key in params) {
        
        
        [paramsString appendFormat:@"%@=%@",key,[params objectForKey:key]];
        
        if (key != [[params allKeys] lastObject]) {
            
            [paramsString appendString:@"&"];
        }
        
    }
    
    return paramsString;
}

@end
