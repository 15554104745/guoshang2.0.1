//
//  LimitSelectView.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LimitSelectView.h"
#import "GSNewLimitModel.h"
typedef void(^Block)(NSInteger index);
@implementation LimitSelectView
{
    Block _block;
    
    UIImageView * _barView;
    NSString *_number;//用来接收信息,作为中转变量用的
    UIView *Limitview;
    UIView *Limitview2;
    LNButton * title1;
    
    UIButton * Titlebutton;
    UIButton * Titlebutton2;
    
    BOOL secondIsNil;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createSelectView];
        
    }
    return self;
}

-(void)setHeaderArr:(NSMutableArray *)headerArr
{
    _headerArr = headerArr;
}

-(void)createSelectView{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SecondIsNil:) name:@"SecondIsNil" object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    Limitview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height - 24)];
    Limitview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qianggouRed"]];
    
    Limitview2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height - 24)];
    Limitview2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qiangouBlack"]];
    
    //限时文字Title
    
    Titlebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Titlebutton.frame = CGRectMake(0, 25, self.frame.size.width/2, 15);
    Titlebutton.titleLabel.font = [UIFont systemFontOfSize:10];
    [Titlebutton addTarget:self action:@selector(toClick:) forControlEvents:UIControlEventTouchUpInside];
    Titlebutton.tag = 100;
    [Limitview addSubview:Titlebutton];
    
    Titlebutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    Titlebutton2.frame = CGRectMake(0, 25, self.frame.size.width/2, 15);
    Titlebutton2.titleLabel.font = [UIFont systemFontOfSize:10];
    [Titlebutton2 addTarget:self action:@selector(toClick:) forControlEvents:UIControlEventTouchUpInside];
    Titlebutton2.tag = 120;
    [Limitview2 addSubview:Titlebutton2];
    
    [self addSubview:Limitview];
    [self addSubview:Limitview2];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(Limitview) weakLimitview = Limitview;
    __weak typeof(Limitview2) weakLimitview2 = Limitview2;
    __weak typeof(Titlebutton) weakTitleButton = Titlebutton;
    __weak typeof(Titlebutton2) weakTitleButton2 = Titlebutton2;
    //开始时间
        self.ReturnTitle = ^(NSString *str1,NSString *str2,NSInteger type)
        {
            LNButton *button = [LNButton buttonWithFrame:CGRectMake(0, 5, self.frame.size.width/2, 20) Type:UIButtonTypeCustom Title:str1 Font:20 Target:weakSelf AndAction:@selector(toClick:)];
            button.tag =  80;
            [weakLimitview addSubview:button];
            
            LNButton *button2 = [LNButton buttonWithFrame:CGRectMake(0, 5, self.frame.size.width/2, 20) Type:UIButtonTypeCustom Title:str2 Font:20 Target:weakSelf AndAction:@selector(toClick:)];
            button2.tag =  82;
            
            if (type == 9) {
                button2.titleLabel.font = [UIFont systemFontOfSize:16];
            }
            
            
            [weakLimitview2 addSubview:button2];
            switch (type) {
                case 0:
                {
                    [weakTitleButton setTitle:@"即将开始" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"即将开始" forState:UIControlStateNormal];

                }
                    break;
                case 1:
                {
                    [weakTitleButton setTitle:@"抢购中" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"即将开始" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [weakTitleButton setTitle:@"抢购中" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"即将开始" forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"即将开始" forState:UIControlStateNormal];
                }
                    break;
                case 4:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"即将开始" forState:UIControlStateNormal];
                }
                    break;
                case 5:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"抢购中" forState:UIControlStateNormal];
                }
                    break;
                case 6:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"抢购中" forState:UIControlStateNormal];
                }
                    break;
                case 7:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"已结束" forState:UIControlStateNormal];
                }
                    break;
                case 8:
                {
                    [weakTitleButton setTitle:@"已结束" forState:UIControlStateNormal];
                    [weakTitleButton2 setTitle:@"已结束" forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            

        };

    UIView *TimeShow = [[UIView alloc] initWithFrame:CGRectMake(0, 40, Width, 30)];
    UIImageView *timeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianggoushizhong"]];
    
    [TimeShow addSubview:timeImg];
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.height.equalTo(@15);
        make.width.equalTo(@13);
    }];
    
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.frame = CGRectMake(40, 8, 150, 20);
    timeLable.text = @"剩余时间:00:00:00";
    timeLable.font = [UIFont systemFontOfSize:14];
    timeLable.textColor = WordColor;
    
    //设定显示时间的样式
    self.ReturnTime = ^(NSString *time,NSString *num,NSInteger beginType){
        
        switch (beginType) {
            case 0:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }
            }
                break;
            case 1:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"剩余时间:%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }
            }
                break;
            case 2:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"剩余时间:%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }
            }
                break;
            case 3:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }
            }
                break;
            case 4:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"距开场时间:%@",time];
                }

            }
                break;
            case 5:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"剩余时间:%@",time];
                }
            }
                break;
            case 6:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"剩余时间:%@",time];
                }
            }
                break;
            case 7:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }
            }
                break;
            case 8:
            {
                if ([num isEqualToString:@"0"]) {
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }else{
                    timeLable.text = [NSString stringWithFormat:@"%@",time];
                }
            }
                break;
                
            default:
                break;
        }
        
    };
    
   [TimeShow addSubview:timeLable];
    [self addSubview:TimeShow];
}

-(void)toClick:(UIButton *)button{
if (button.tag == 80 || button.tag == 100) {
    
    Limitview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qianggouRed"]];
    [Limitview2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qiangouBlack"]]];
    
    //更改tableView
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@0,@"textOne",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"reciveNoticeTochangeVc" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}else
{
    if (secondIsNil == YES) {
         [AlertTool alertMesasge:@"敬请期待" confirmHandler:nil viewController:self.popVC];
        return;
    }
    
    Limitview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qiangouBlack"]];
    [Limitview2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qianggouRed"]]];
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@1,@"textOne",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"reciveNoticeTochangeVc" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

}

-(void)SecondIsNil:(NSNotification *)notification
{
    secondIsNil = YES;
    [Titlebutton2 removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
