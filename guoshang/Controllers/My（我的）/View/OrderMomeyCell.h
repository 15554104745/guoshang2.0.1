//
//  OrderMomeyCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/4/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMomeyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic,strong)NSMutableDictionary * dic;
@end
