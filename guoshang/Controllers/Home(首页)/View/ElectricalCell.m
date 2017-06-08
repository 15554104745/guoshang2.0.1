//
//  ElectricalCell.m
//  home
//
//  Created by宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ElectricalCell.h"
#define Podding ([UIScreen mainScreen].bounds.size.width -30)/4.0
#import "Masonry.h"
#import "GoodsViewController.h"
#import "SearchResultViewController.h"
#import "GoodsShowViewController.h"
@implementation ElectricalCell
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
        HomeModel * model1 = _array[_DQLeftBigBtn.tag - 100];
        [_DQLeftBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model1.url]];
        HomeModel * model2 = _array[_DQleftSmallBtn.tag - 100];
        [_DQleftSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model2.url]];
        HomeModel * model3 = _array[_DQleftSmallTwoIconBtn.tag - 100];
        [_DQleftSmallTwoIconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model3.url]];
        HomeModel * model4 = _array[_DQrightBigBtn.tag - 100];
        [_DQrightBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model4.url]];
        HomeModel * model5 = _array[_DQrightSmallBtn.tag - 100];
        [_DQrightSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model5.url]];
        HomeModel * model6 = _array[_DQrightSmallTwoBtn.tag - 100];
        [_DQrightSmallTwoBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model6.url]];
        
    }
    
}

-(void)createUI{
    
    //1.左边的大图
    UIButton *DQLeftBigBtn = [[UIButton alloc] init];
    _DQLeftBigBtn = DQLeftBigBtn;
    //    self.leftBigIconView.image = [UIImage imageNamed:@"设置"];
    _DQLeftBigBtn.tag = 100;
    _DQLeftBigBtn.backgroundColor = [UIColor whiteColor];
    [_DQLeftBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DQLeftBigBtn];
    [_DQLeftBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding * 2);
        
    }];
    //2左边的第一个小图
    UIButton * DQleftSmallBtn = [[UIButton alloc] init];
    _DQleftSmallBtn = DQleftSmallBtn;
    _DQleftSmallBtn.tag = 101;
    _DQleftSmallBtn.backgroundColor = [UIColor whiteColor];
    [_DQleftSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    //    self.leftSmallIconView.image = [UIImage imageNamed:@"设置"];
    [self addSubview:_DQleftSmallBtn];
    [_DQleftSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(DQLeftBigBtn.mas_bottom);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
    }];
    //3左边的第二个小图
    UIButton *  DQleftSmallTwoIconBtn= [[UIButton alloc] init];
    _DQleftSmallTwoIconBtn = DQleftSmallTwoIconBtn;
    _DQleftSmallTwoIconBtn.backgroundColor = [UIColor whiteColor];
    //     self.leftSmallIconView.image = [UIImage imageNamed:@"设置"];
    _DQleftSmallTwoIconBtn.tag = 102;
    [_DQleftSmallTwoIconBtn addTarget:self  action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DQleftSmallTwoIconBtn];
    [_DQleftSmallTwoIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DQleftSmallBtn.mas_right);
        make.top.mas_equalTo(DQLeftBigBtn.mas_bottom);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
        
    }];
    //    //4右边的第一个大图
    UIButton * DQrightBigBtn = [[UIButton alloc] init];
    //    self.rightSmallIconView.image = [UIImage imageNamed:@"设置"];
    _DQrightBigBtn = DQrightBigBtn;
    _DQrightBigBtn.backgroundColor = [UIColor whiteColor];
    _DQrightBigBtn.tag = 103;
    [_DQrightBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DQrightBigBtn];
    [_DQrightBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DQLeftBigBtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding * 2);
        
    }];
    //    //5右边的第一个大图
    UIButton *  DQrightSmallBtn = [[UIButton alloc] init];
    DQrightSmallBtn.backgroundColor = [UIColor whiteColor];
    _DQrightSmallBtn = DQrightSmallBtn;
    _DQrightSmallBtn.tag = 104;
    [_DQrightSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DQrightSmallBtn];
    [_DQrightSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DQleftSmallTwoIconBtn.mas_right);
        make.top.mas_equalTo(DQrightBigBtn.mas_bottom);
        make.height.mas_equalTo(Podding);
        make.width.mas_equalTo(Podding);
        
    }];
    //6右边的第二个大图
    UIButton * DQrightSmallTwoBtn = [[UIButton alloc] init];
   DQrightSmallTwoBtn.backgroundColor = [UIColor whiteColor];
    _DQrightSmallTwoBtn = DQrightSmallTwoBtn;
    _DQrightSmallTwoBtn.tag = 105;
    [_DQrightSmallTwoBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_DQrightSmallTwoBtn];
    
    [DQrightSmallTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DQrightSmallBtn .mas_right);
        make.top.mas_equalTo(DQrightBigBtn.mas_bottom);
        make.width.mas_equalTo(Podding );
        make.height.mas_equalTo(Podding);
        
    }];

}

-(void)toPush:(UIButton *)button{
    
    HomeModel * model = _array[button.tag- 100];
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
