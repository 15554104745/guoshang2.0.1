//
//  GSMessageModel.h
//  guoshang
//
//  Created by 金联科技 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface GSMessageModel : JSONModel
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *is_del;
@property (copy, nonatomic) NSString *is_read;
@property (assign, nonatomic) float  time;  //时间
@property (assign, nonatomic) NSInteger user_id;
@property (assign, nonatomic) NSInteger user_type;
@property (assign, nonatomic) NSInteger message_id;
@end
