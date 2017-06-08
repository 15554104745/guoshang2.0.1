//
//  MySlideHeaderCollectionReusableView.h
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListScrollView.h"

@protocol SlideDelegate <NSObject>

-(void)tiaozhuan;

@end

@interface MySlideHeaderCollectionReusableView : UICollectionReusableView

@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UILabel *nameLabel; //荷叶便利店
@property(nonatomic,strong)UIButton *headPhotoBtn;//头像
@property(nonatomic,strong)UILabel *moneyLabel; //起送价
@property(nonatomic,strong)UILabel *peisongLabel;//配送费
@property(nonatomic,strong)UILabel *timeLabel; //时程
@property(nonatomic,strong)UIButton *xiangqingBtn;//查看详情

@property(nonatomic,strong)UILabel *fenleiLabel;//商品分类
@property(nonatomic,strong)UIButton *moreBtn; //更多
@property(nonatomic,strong)UIButton *breadBtn;//面包饮料
@property(nonatomic,strong)UIButton *snacksBtn;//休闲小吃
@property(nonatomic,strong)UIButton *dairyBtn;//奶制品
@property(nonatomic,strong)UIButton *jindeBtn;//烟酒糖茶

@property(nonatomic,weak)id<SlideDelegate>delegate;

@end
