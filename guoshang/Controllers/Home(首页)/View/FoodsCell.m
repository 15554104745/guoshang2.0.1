//
//  FoodsCell.m
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "FoodsCell.h"
#import "GoodsViewController.h"
#import "SearchResultViewController.h"
#import "GoodsShowViewController.h"
@implementation FoodsCell

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
        HomeModel * model1 = _array[_SYLeftBigBtn.tag - 400];
        [_SYLeftBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model1.url]];
        HomeModel * model2 = _array[_SYLeftSmallBtn.tag - 400];
        [_SYLeftSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model2.url]];
        HomeModel * model3 = _array[_SYLeftSTBtn.tag - 400];
        [_SYLeftSTBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model3.url]];
        HomeModel * model4 = _array[_SYRightBigBtn.tag - 400];
        [_SYRightBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model4.url]];
        HomeModel * model5 = _array[_SYRightSTBtn.tag - 400];
        [_SYRightSTBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model5.url]];
        HomeModel * model6 = _array[_SYRigntSBtn.tag -400];
        
        [_SYRigntSBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model6.url]];
        
    }
    
}


-(void)createUI{
//1左边的大图
UIButton *SYLeftBigBtn = [[UIButton alloc] init];
    _SYLeftBigBtn = SYLeftBigBtn;
    _SYLeftBigBtn.tag = 400;
    _SYLeftBigBtn.backgroundColor = [UIColor whiteColor];
    [_SYLeftBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_SYLeftBigBtn];
[_SYLeftBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.mas_equalTo(self.mas_left);
    make.top.mas_equalTo(self.mas_top);
    make.width.mas_equalTo(Podding * 2);
    make.height.mas_equalTo(Podding * 2);
    
}];
//2左边的第一个小图
UIButton * SYLeftSmallBtn = [[UIButton alloc] init];
    _SYLeftSmallBtn = SYLeftSmallBtn;
    _SYLeftSmallBtn.backgroundColor = [UIColor whiteColor];
    _SYLeftSmallBtn.tag = 401;
    [_SYLeftSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_SYLeftSmallBtn];
[_SYLeftSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left);
    make.top.mas_equalTo(_SYLeftBigBtn.mas_bottom);
    make.width.mas_equalTo(Podding);
    make.height.mas_equalTo(Podding);
}];

//3左边的第二个小图
UIButton *  SYLeftSTBtn = [[UIButton alloc] init];
    _SYLeftSTBtn = SYLeftSTBtn;
    _SYLeftSTBtn.tag = 402;
    _SYLeftSTBtn.backgroundColor =[UIColor whiteColor];
    [_SYLeftSTBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_SYLeftSTBtn];
[_SYLeftSTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_SYLeftSmallBtn.mas_right);
    make.top.mas_equalTo(_SYLeftBigBtn.mas_bottom);
    make.width.mas_equalTo(Podding);
    make.height.mas_equalTo(Podding);
    
}];
//4右边的第一个小图
UIButton * SYRigntSBtn = [[UIButton alloc] init];
    SYRigntSBtn.backgroundColor =[UIColor whiteColor];
    _SYRigntSBtn = SYRigntSBtn;
    _SYRigntSBtn.tag = 403;
    [_SYRigntSBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_SYRigntSBtn];
[_SYRigntSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_SYLeftBigBtn.mas_right);
    make.top.mas_equalTo(self.mas_top);
    make.width.mas_equalTo(Podding);
    make.height.mas_equalTo(Podding);
    
}];
//5右边的第二个小图
UIButton *  SYRightSTBtn = [[UIButton alloc] init];
    _SYRightSTBtn = SYRightSTBtn;
    _SYRightSTBtn.tag = 404;
    _SYRightSTBtn.backgroundColor = [UIColor whiteColor];
    [_SYRightSTBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_SYRightSTBtn];
[_SYRightSTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(SYRigntSBtn.mas_right);
    make.top.mas_equalTo(self.mas_top);
    make.height.mas_equalTo(Podding);
    make.width.mas_equalTo(Podding);
    
}];
//6右边的大图
UIButton * SYRightBigBtn = [[UIButton alloc] init];
    _SYRightBigBtn = SYRightBigBtn;
    _SYRightBigBtn.backgroundColor = [UIColor whiteColor];
    _SYRightBigBtn.tag = 405;
    [_SYRightBigBtn  addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_SYRightBigBtn];
[_SYRightBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_SYLeftBigBtn.mas_right);
    make.top.mas_equalTo(_SYRigntSBtn.mas_bottom);
    make.width.mas_equalTo(Podding * 2);
    make.height.mas_equalTo(Podding * 2);
    
}];
    
}
-(void)toPush:(UIButton *)button{
    HomeModel * model = _array[button.tag- 400];
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
