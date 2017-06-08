//
//  GSSpecificationsModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSSpecificationsDetailModel;
@interface GSSpecificationsModel : NSObject
@property (copy, nonatomic) NSString *f_id;
@property (copy, nonatomic) NSString *f_name;
@property (copy, nonatomic) NSArray <__kindof GSSpecificationsDetailModel *>*attr_next;
@end
