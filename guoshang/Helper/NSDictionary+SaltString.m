//
//  NSDictionary+SaltString.m
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "NSDictionary+SaltString.h"

@implementation NSDictionary (SaltString)

- (NSDictionary *)addSaltParamsDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:[self paramsDictionaryAddSaltString],@"token", nil];
}

- (NSString *)paramsDictionaryAddSaltString {
    
    __block NSMutableString *tempStr = [[NSMutableString alloc] initWithCapacity:0];
    __weak typeof(self) weakSelf = self;
    [[self allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [tempStr appendString:@","];
        }
        [tempStr appendString:[NSString stringWithFormat:@"%@=%@",obj,weakSelf[obj]]];
    }];
    
    return [tempStr encryptStringWithKey:KEY];
}

- (void)logDictionary {
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
    
    for (NSString *obj in [self allKeys]) {
        if ([self[obj] isKindOfClass:[NSArray class]]) {
            [string appendString:[NSString stringWithFormat:@"\n@property (copy, nonatomic) NSArray *%@;",obj]];
        } else if ([self[obj] isKindOfClass:[NSDictionary class]]) {
            [string appendString:[NSString stringWithFormat:@"\n@property (strong, nonatomic) NSDictionary *%@;",obj]];
        } else {
            [string appendString:[NSString stringWithFormat:@"\n@property (copy, nonatomic) NSString *%@;",obj]];
        }
    }
    NSLog(@"%@",string);
}

@end
