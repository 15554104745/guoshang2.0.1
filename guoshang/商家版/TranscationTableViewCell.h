//
//  TranscationTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionModel.h"

@interface TranscationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_time;

@property (weak, nonatomic) IBOutlet UILabel *label_money;

@property (weak, nonatomic) IBOutlet UILabel *label_describe;

@property (nonatomic, strong)TransactionModel *model;


@end
