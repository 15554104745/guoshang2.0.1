//
//  GSHomeLimitCell.h
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeLimitModel.h"
@interface GSHomeLimitCell : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) LNLabel *marketPriceLabel;
@property (strong, nonatomic) LNLabel *limitPriceLabel;

@property (strong, nonatomic) LNButton *button;

@property (strong, nonatomic) GSHomeLimitModel *limitModel;

@property (copy, nonatomic) void(^clickBlock)(GSHomeLimitModel *limitModel);

@end
