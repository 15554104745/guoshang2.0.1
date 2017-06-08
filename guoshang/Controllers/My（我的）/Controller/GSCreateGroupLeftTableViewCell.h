//
//  GSCreateGroupLeftTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGroupWillCreateModel.h"

@interface GSCreateGroupLeftTableViewCell : UITableViewCell
@property (strong, nonatomic) GSGroupWillCreateModel *groupModel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPeopleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupEffectivenessLabel;

@property (weak, nonatomic) IBOutlet UIView *rulesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulesViewHeight;

@property (copy, nonatomic) void (^createBlock) (NSString *group_id);


@end
