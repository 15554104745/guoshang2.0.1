//
//  GSNearbyStoreListTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSStoreListModel.h"


@interface GSNearbyStoreListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *minDistributionLabel;

@property (weak, nonatomic) IBOutlet UILabel *distributionMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;

@property (strong, nonatomic) GSStoreListModel *storeListModel;

@property (copy, nonatomic) void(^selectStoreBlock)(GSStoreListModel *storeModel);


@end
