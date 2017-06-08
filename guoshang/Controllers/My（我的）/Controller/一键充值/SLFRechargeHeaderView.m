//
//  SLFRechargeHeaderView.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFRechargeHeaderView.h"
#import "SLFRechargeModle.h"

@implementation SLFRechargeHeaderView
{
    UILabel *CRBalanceL;
    UILabel *CountryBalanceL;
    UILabel *KingBalanceL;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)setHeaderArr:(NSMutableArray *)headerArr
{
    _headerArr = headerArr;
     SLFRechargeModle *model1 = _headerArr[0];
    
    if (self.tap == 2) {
        CRBalanceL.text = [NSString stringWithFormat:@"国币余额 : %@",model1.pay_points];
        KingBalanceL.text = [NSString stringWithFormat:@" 金币余额 : %@元",model1.user_money];
        CountryBalanceL.text = [NSString stringWithFormat:@" 充值卡余额 : %@元",model1.rechargeable_card_money];
    }else
    {
    CRBalanceL.text = [NSString stringWithFormat:@"可用充值卡余额 : %@元",model1.rechargeable_card_money];
    KingBalanceL.text = [NSString stringWithFormat:@" 金币余额 : %@元",model1.user_money];
    CountryBalanceL.text = [NSString stringWithFormat:@" 国币余额 : %@",model1.pay_points];
    }
}

-(void)creatUI
{
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [ImageView setImage:[UIImage imageNamed:@"图层2@2x"]];
    [self addSubview:ImageView];
    
    CRBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(0,30, Width, 40)];
    
    CRBalanceL.textColor = [UIColor whiteColor];
    CRBalanceL.font = [UIFont systemFontOfSize:22];
    CRBalanceL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:CRBalanceL];
    
    UILabel *lineHL = [[UILabel alloc] initWithFrame:CGRectMake(0, CRBalanceL.endPointY + 45, Width, 0.5)];
    lineHL.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineHL];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    if (Width <= 320) {
        imageV.frame = CGRectMake(15, lineHL.endPointY + 5, 20, 25);
    }else
    {

        imageV.frame = CGRectMake(40, lineHL.endPointY + 5, 20, 25);
    }
    
    imageV.image = [UIImage imageNamed:@"guobislf"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    
    CountryBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(imageV.endPointX, lineHL.endPointY, Width/2, 30)];
    CountryBalanceL.textColor = [UIColor whiteColor];
    CountryBalanceL.font = [UIFont systemFontOfSize:12];
    [self addSubview:CountryBalanceL];
    
    UILabel *lineLL = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 0.3, lineHL.endPointY + 5,1, 20)];
    lineLL.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineLL];
    
    UIImageView *imageV2 = [[UIImageView alloc] init];
    if (Width <= 320) {
        imageV2.frame = CGRectMake(lineLL.endPointX + 15, lineHL.endPointY + 5, 20, 20);
    }else
    {
        
        imageV2.frame = CGRectMake(lineLL.endPointX + 40, lineHL.endPointY + 5, 20, 20);
    }
    imageV2.image = [UIImage imageNamed:@"jinbi"];
    imageV2.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV2];
    
    KingBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(imageV2.endPointX, lineHL.endPointY, Width/2, 30)];
    KingBalanceL.textColor = [UIColor whiteColor];
    KingBalanceL.font = [UIFont systemFontOfSize:12];
    [self addSubview:KingBalanceL];
    
}

@end
