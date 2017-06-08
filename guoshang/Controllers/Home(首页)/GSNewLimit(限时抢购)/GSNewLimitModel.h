//
//  GSNewLimitModel.h
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSNewLimitModel : NSObject

@property(nonatomic,copy)NSString * shift;
@property(nonatomic,copy)NSString * shift_format;
@property(nonatomic,copy)NSString * shift_h;
@property(nonatomic,copy)NSString * end_time_format;

@property (copy, nonatomic) NSArray *goods_list;



@end
