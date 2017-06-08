//
//  DailyCell.m
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "DailyCell.h"
#import "Masonry.h"
#import "GoodsViewController.h"
#import "SearchResultViewController.h"
#import "GoodsShowViewController.h"
#define Podding ([UIScreen mainScreen].bounds.size.width -30)/4.0
@implementation DailyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        [self createUI];
    }
    return self;
}

-(void)setArray:(NSMutableArray *)array{
    _array = array;
    [self settingData];
}
-(void)settingData{
    if (_array.count > 0) {
        HomeModel * model1 = _array[_RYLeftBigBtn.tag - 500];

 [_RYLeftBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model1.url]];
        
        HomeModel * model2 = _array[_RYLeftSmallBtn.tag - 500];

        [_RYLeftSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model2.url]];
        
        HomeModel * model3 = _array[_RYLeftSTBtn.tag - 500];

        [_RYLeftSTBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model3.url]];
        HomeModel * model4 = _array[_RYRightBigBtn.tag - 500];

         [_RYRightBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model4.url]];
        
        HomeModel * model5 = _array[_RYRightSTBtn.tag - 500];
         [_RYRightSTBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model5.url]];
        HomeModel * model6 = _array[_RYRigntSBtn.tag - 500];

         [_RYRigntSBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model6.url]];
        
    }
    
}


-(void)createUI{
   
    UIButton *RYLeftBigBtn = [[UIButton alloc] init];
    _RYLeftBigBtn = RYLeftBigBtn;
    _RYLeftBigBtn.tag = 500;
    _RYLeftBigBtn.backgroundColor = [UIColor whiteColor];
    [_RYLeftBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYLeftBigBtn];
    [_RYLeftBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self. mas_top);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding * 2);
        
    }];
    //2左边的第一个小图
    UIButton * RYLeftSmallBtn = [[UIButton alloc] init];
    _RYLeftSmallBtn = RYLeftSmallBtn;
    _RYLeftSmallBtn.tag = 501;
    _RYLeftSmallBtn.backgroundColor = [UIColor whiteColor];
    [_RYLeftSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYLeftSmallBtn];
    [_RYLeftSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(RYLeftBigBtn.mas_bottom);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
    }];
    
    //3左边的第二个小图
    UIButton *  RYLeftSTBtn = [[UIButton alloc] init];
    _RYLeftSTBtn = RYLeftSTBtn;
    _RYLeftSTBtn.tag = 502;
    _RYLeftSTBtn.backgroundColor = [UIColor whiteColor];
    [_RYLeftSTBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYLeftSTBtn];
    [_RYLeftSTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RYLeftSmallBtn.mas_right);
        make.top.mas_equalTo(RYLeftBigBtn.mas_bottom);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
        
    }];
    //4右边的第一个小图
    UIButton * RYRigntSBtn = [[UIButton alloc] init];
    _RYRigntSBtn = RYRigntSBtn;
    _RYRigntSBtn.tag = 503;
    _RYRigntSBtn.backgroundColor = [UIColor whiteColor];
    [_RYRigntSBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYRigntSBtn];
    [_RYRigntSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RYLeftBigBtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
        
    }];
    //5右边的第二个小图
    UIButton *  RYRightSTBtn = [[UIButton alloc] init];
    _RYRightSTBtn = RYRightSTBtn;
    _RYRightSTBtn.tag = 504;
    _RYRightSTBtn.backgroundColor = [UIColor whiteColor];
    [_RYRightSTBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYRightSTBtn];
    [_RYRightSTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RYRigntSBtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(Podding);
        make.width.mas_equalTo(Podding);
        
    }];
    //6右边的大图
    UIButton * RYRightBigBtn = [[UIButton alloc] init];
    _RYRightBigBtn = RYRightBigBtn ;
    _RYRightBigBtn.tag = 505;
    _RYRightBigBtn.backgroundColor = [UIColor whiteColor];
    [_RYRightBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_RYRightBigBtn];
    [_RYRightBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RYLeftBigBtn.mas_right);
        make.top.mas_equalTo(RYRigntSBtn.mas_bottom);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding * 2);
        
    }];
    

    
}

-(void)toPush:(UIButton *)button{
    HomeModel * model = _array[button.tag- 500];
    if ([model.type isEqualToString:@"cat_id"]) {
        GoodsViewController * goods = [[GoodsViewController alloc] init];
        goods.ID = model.params;
        goods.hidesBottomBarWhenPushed = YES;
        [self.popView.navigationController pushViewController:goods animated:YES];
    }else if ([model.type isEqualToString:@"keywords"]){
        SearchResultViewController * result = [[SearchResultViewController alloc] init];
        result.words = model.params;
        result.hidesBottomBarWhenPushed = YES;
        [self.popView.navigationController pushViewController:result animated:YES];
    }else if ([model.type isEqualToString:@"goods_id"]){
        GoodsShowViewController * show = [[GoodsShowViewController alloc] init];
        show.goodId = model.params;
        show.hidesBottomBarWhenPushed = YES;
        [self.popView.navigationController pushViewController:show animated:YES];
    }

}
@end
