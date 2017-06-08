//
//  GSOrderOrderInfoTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSOrderOrderInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@end
