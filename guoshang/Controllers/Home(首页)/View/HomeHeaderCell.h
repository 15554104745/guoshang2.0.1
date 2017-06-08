//
//  HomeHeaderCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"
#import "GoodsShowViewController.h"
@interface HomeHeaderCell : UICollectionReusableView<ImagesScrollViewDelegate>


@property(nonatomic,weak)UIView * View;
@property(nonatomic,strong)NSMutableArray * bannerArr;//轮播数据
@property(nonatomic,strong)UIViewController * popView;
@property(nonatomic,strong)NSArray * setArray;//商城的跳转
@property(nonatomic,strong)NSArray * limitArray;//限时抢购数据
@property(nonatomic,strong)NSString  * titleStr;

@property (copy, nonatomic) void (^limitBtnClickBlock) (GoodsShowViewController *viewController);
@end
