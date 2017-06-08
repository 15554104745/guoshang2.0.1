//
//  BaseModel.h
//  MTime
//
//  Created by mac on 16/1/4.
//  Copyright (c) 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


// 初始化方法   传入解析的json数据
- (id)initWithContentDic:(NSDictionary *)jsonDic;

- (void)setAttributesWithDic:(NSDictionary *)jsonDic;

// 属性名的映射字典 @{jsonDic.key  :  model.attringbute}
@property (nonatomic, copy)NSDictionary *mapDic;

@end
