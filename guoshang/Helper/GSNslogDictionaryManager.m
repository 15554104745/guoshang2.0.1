//
//  GSNslogDictionaryManager.m
//  guoshang
//
//  Created by Rechied on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNslogDictionaryManager.h"

@implementation GSNslogDictionaryManager
+ (void)logDictionary:(NSDictionary *)dic {
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
    
    for (NSString *obj in [dic allKeys]) {
        
        [string appendString:[NSString stringWithFormat:@"\n@property (copy, nonatomic) NSString *%@;",obj]];
        
    }
//    NSLog(@"%@",string);
}
@end
