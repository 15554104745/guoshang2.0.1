//
//  GSNewLimiteTableViewCell.h
//  guoshang
//
//  Created by 时礼法 on 16/11/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewLimiteTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlaLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goBuy;
@property (weak, nonatomic) IBOutlet UILabel *sold_percent;
@property (weak, nonatomic) IBOutlet UILabel *haveSold;

@end
