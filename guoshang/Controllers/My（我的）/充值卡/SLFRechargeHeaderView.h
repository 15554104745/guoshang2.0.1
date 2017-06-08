//
//  SLFRechargeHeaderView.h
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFRechargeHeaderView : UIView

@property (nonatomic,copy) NSString *CRBalance;
@property (nonatomic,copy) NSString *CountryBalance;
@property (nonatomic,copy) NSString *KingBalance;

-(instancetype)initWithFrame:(CGRect)frame;

@end
