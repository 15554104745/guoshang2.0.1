//
//  GSChackOutTotalInfoView.h
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderTotalModel.h"

@interface GSChackOutTotalInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *guoBiIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalShippingPriceLabel;

@property (strong, nonatomic) GSChackOutOrderTotalModel *totalModel;
@end
