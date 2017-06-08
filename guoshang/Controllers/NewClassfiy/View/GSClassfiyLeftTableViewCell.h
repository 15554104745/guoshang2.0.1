//
//  GSClassfiyLeftTableViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSClassfiyMenuModel.h"

@interface GSClassfiyLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *rightLine;

@property (weak, nonatomic) IBOutlet UIView *botLine;

@property (strong, nonatomic) UIView *tapView;

@property (strong, nonatomic) GSClassfiyMenuModel *menuModel;
@end
