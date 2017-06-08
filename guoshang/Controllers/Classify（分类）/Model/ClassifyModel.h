//
//  ClassifyModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject

@property (copy, nonatomic) NSString * ID; //id 
@property (copy, nonatomic) NSString * name; //分类名称
@property (strong, nonatomic) NSMutableArray * cat_id; //三级分类商品
//@property (copy, nonatomic) NSString * goods_id;
//@property (copy, nonatomic) NSString * goods_thumb;

@end
