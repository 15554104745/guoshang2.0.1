//
//  LimitCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LimitModel.h"
#import "GoodsDetailViewController.h"
@interface LimitCell : UITableViewCell<LimitDown>
@property (weak, nonatomic)  UIImageView *goodsIcon;//商品图片
@property (weak, nonatomic)  UIImageView *limitIcon;//限时特卖

@property (weak, nonatomic)  UILabel *titleLabel;//商品名称
@property (weak, nonatomic)  UILabel *PriceLabe;//价格
@property (weak, nonatomic)  UILabel *oldPrice;//市场价

@property (weak, nonatomic)  UILabel *deleLabel;//删除线
@property (weak, nonatomic)  UILabel *timelabel;//剩余时间

@property (weak, nonatomic)  UILabel *hourLabel;//时

@property (weak, nonatomic)  UILabel *sem1;//分号1

@property (weak, nonatomic)  UILabel *miLabel;//分

@property (weak, nonatomic)  UILabel *sem2;//分号2
@property (weak, nonatomic)  UILabel *mLabel;//秒
@property (weak, nonatomic)  UIProgressView *progressIcon;//进度条
@property (weak, nonatomic)  UIButton *BuyBtn;//抢购按钮
@property (weak, nonatomic)  UIImageView *wire1Icon;
@property(weak,nonatomic)   UIImageView * wire2Icon;
@property (weak, nonatomic)  UIButton *willBtn;
@property(weak,nonatomic) UILabel * willLabel;
@property(assign,nonatomic) CGFloat  cellHeight;
@property(strong,nonatomic)LNLabel * LimitCount;
@property (weak, nonatomic)  UIImageView *willIcon;
@property(nonatomic,strong)LimitModel * model;


@property(nonatomic,strong)UIViewController * popView;




@end
