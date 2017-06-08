//
//  SLFRechargeHeaderView.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFRechargeHeaderView.h"


@implementation SLFRechargeHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [ImageView setImage:[UIImage imageNamed:@"个人中心-bg"]];
    [self addSubview:ImageView];
    
    UILabel *CRBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(0,30, Width, 40)];
    CRBalanceL.text = [NSString stringWithFormat:@"可用充值卡余额 : 28元"];
    CRBalanceL.textColor = [UIColor whiteColor];
    CRBalanceL.font = [UIFont systemFontOfSize:22];
    CRBalanceL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:CRBalanceL];
    
    UILabel *lineHL = [[UILabel alloc] initWithFrame:CGRectMake(0, CRBalanceL.endPointY + 45, Width, 0.5)];
    lineHL.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineHL];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineHL.endPointY + 5, 20, 20)];
    imageV.image = [UIImage imageNamed:@"jinbi"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    
    UILabel *CountryBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(imageV.endPointX, lineHL.endPointY, Width/2, 30)];
    CountryBalanceL.text = [NSString stringWithFormat:@" 国币余额 : 28元"];
    CountryBalanceL.textColor = [UIColor whiteColor];
    CountryBalanceL.font = [UIFont systemFontOfSize:14];
//    CountryBalanceL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:CountryBalanceL];
    
    UILabel *lineLL = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 0.3, lineHL.endPointY + 5,1, 20)];
    lineLL.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineLL];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineLL.endPointX + 40, lineHL.endPointY + 5, 20, 20)];
    imageV2.image = [UIImage imageNamed:@"jinbi"];
    imageV2.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV2];
    
    UILabel *KingBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(imageV2.endPointX, lineHL.endPointY, Width/2, 30)];
    KingBalanceL.text = [NSString stringWithFormat:@" 金币余额 : 28元"];
    KingBalanceL.textColor = [UIColor whiteColor];
    KingBalanceL.font = [UIFont systemFontOfSize:14];
//    KingBalanceL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:KingBalanceL];
    
}

@end
