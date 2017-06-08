//
//  GSHomeCollectionCellModel.h
//  guoshang
//
//  Created by Rechied on 16/8/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSHomeCellTopModel.h"
#import "GSHomeCellBotModel.h"
@interface GSHomeCollectionCellModel : NSObject
@property (strong ,nonatomic) GSHomeCellTopModel *topModel;
@property (strong ,nonatomic) GSHomeCellBotModel *botModel;
@property (copy ,nonatomic) NSString *topTitleImageName;
@end
