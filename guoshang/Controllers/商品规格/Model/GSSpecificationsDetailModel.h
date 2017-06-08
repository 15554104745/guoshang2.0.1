//
//  GSSpecificationsListModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSpecificationsDetailModel : NSObject
@property (copy, nonatomic) NSString *object_fid;
@property (copy, nonatomic) NSString *attrbute_id;
@property (copy, nonatomic) NSArray *relative_attr;
@property (copy, nonatomic) NSString *object_name;
@end
