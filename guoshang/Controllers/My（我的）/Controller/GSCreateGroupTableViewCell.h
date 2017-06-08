//
//  GSCreateGroupTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/8/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMyGroupListModel.h"

@interface GSCreateGroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *groupStatusLabel;


@property (strong, nonatomic) GSMyGroupListModel *groupListModel;
@end
