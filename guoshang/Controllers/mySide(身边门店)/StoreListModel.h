//
//  StoreListModel.h
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface StoreListModel : JSONModel
@property(nonatomic,copy)NSString *shop_id;

@property(nonatomic,copy)NSString *shop_title;

@property(nonatomic,copy)NSString *shoplogo;


@end
