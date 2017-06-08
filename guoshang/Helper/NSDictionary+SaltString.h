//
//  NSDictionary+SaltString.h
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SaltString)
- (NSDictionary *)addSaltParamsDictionary;
- (NSString *)paramsDictionaryAddSaltString;
- (void)logDictionary;
@end
