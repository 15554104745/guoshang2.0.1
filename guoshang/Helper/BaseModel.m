//
//  BaseModel.m
//  MTime
//
//  Created by mac on 16/1/4.
//  Copyright (c) 2016年 mac. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


- (id)initWithContentDic:(NSDictionary *)jsonDic {

    
    if (self  = [super init]) {

        
        [self setAttributesWithDic:jsonDic];
        
    }
    
    return self;
}


- (void)setAttributesWithDic:(NSDictionary *)jsonDic {
    
#define 普通字符的赋值
    //1. 将jsonDic中的所有的key值  转换成set方法
    for (NSString *key in [jsonDic allKeys]) {
        
        // 对key之进行操作  --> setKey:
        NSString *bigan = [[key substringToIndex:1] uppercaseString];// 获取key值的首字母并大写
        NSString *end = [key substringFromIndex:1]; // 获取key值除首字母外的其他字符
        
        // 获取最后的set方法名
        NSString *mothodString = [NSString stringWithFormat:@"set%@%@:",bigan,end];
        
        // 将方法名转换成set方法
       SEL mothod = NSSelectorFromString(mothodString);
       
        
        // 2. 判断model类是否相应set方法，如果是的话 调用set方法并赋值
        if ([self respondsToSelector:mothod]) {
            
            // 获取需要保存的数据
            id value = [jsonDic objectForKey:key];
            
            //  确定value不为空
            if (![value isKindOfClass:[NSNull class]]) {
                
                // 调用set方法并赋值
                [self performSelector:mothod withObject:value];
            }
        }
        
    }
    
    
#define 特殊字符的赋值
    for (NSString *key in self.mapDic) {
        
        // 获取model对象中的特殊字符的属性名
        NSString *attribute = [self.mapDic objectForKey:key];
        
        // 对key之进行操作  --> setKey:
        NSString *bigan = [[attribute substringToIndex:1] uppercaseString];// 获取key值的首字母并大写
        NSString *end = [attribute substringFromIndex:1]; // 获取key值除首字母外的其他字符
        
        // 获取最后的set方法名
        NSString *mothodString = [NSString stringWithFormat:@"set%@%@:",bigan,end];
        
        // 将方法名转换成set方法
        SEL mothod = NSSelectorFromString(mothodString);
        
        
        // 2. 判断model类是否相应set方法，如果是的话 调用set方法并赋值
        if ([self respondsToSelector:mothod]) {
            
            // 获取需要保存的数据
            id value = [jsonDic objectForKey:key];
            
            //  确定value不为空
            if (![value isKindOfClass:[NSNull class]]) {
                
                // 调用set方法并赋值
                [self performSelector:mothod withObject:value];
            }
        }
        
    }
    
}




@end
