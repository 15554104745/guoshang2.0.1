//
//  BabyCell.m
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "BabyCell.h"
#import "Masonry.h"
#import "GoodsViewController.h"
#import "SearchResultViewController.h"
#import "GoodsShowViewController.h"
@implementation BabyCell
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
         HomeModel * model1 = _array[_MYLeftBigBtn.tag - 200];
        [_MYLeftBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model1.url]];
        
        HomeModel * model2 = _array[_MYLeftSmallBtn.tag - 200];
         [_MYLeftSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model2.url]];
        
        HomeModel * model3 = _array[_MYRightSmallBtn.tag - 200];

         [_MYRightSmallBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model3.url]];
        
        HomeModel * model4 = _array[_MYRightSBtn.tag - 200];
         [_MYRightSBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model4.url]];
        HomeModel * model5 = _array[_MYRightSBTtn.tag - 200];
           [_MYRightSBTtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model5.url]];
        
        HomeModel * model6 = _array[_MYRightSTBtn.tag - 200];
        
          [_MYRightSTBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model6.url]];
        if (_array.count > 6) {
            HomeModel * model7 = _array[_MYRightBigBtn.tag - 200];
            [_MYRightBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model7.url]];
        }else{
            
             [_MYRightBigBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model6.url]];
            
        }
       
    
    }
   
    
    
}
-(void)createUI{
//1左边的第一个大图
UIButton *MYLeftBigBtn = [[UIButton alloc] init];
    _MYLeftBigBtn = MYLeftBigBtn;
    _MYLeftBigBtn.tag = 200;
    _MYLeftBigBtn.backgroundColor = [UIColor whiteColor];
    [_MYLeftBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_MYLeftBigBtn];
[_MYLeftBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.mas_equalTo(self.mas_left);
    make.top.mas_equalTo(self.mas_top);
    make.width.mas_equalTo(Podding * 2);
    make.height.mas_equalTo(Podding * 2);
    
}];
//2左边的小图
UIButton * MYLeftSmallBtn = [[UIButton alloc] init];
    _MYLeftSmallBtn = MYLeftSmallBtn;
_MYLeftSmallBtn.tag = 201;
    _MYLeftSmallBtn.backgroundColor = [UIColor whiteColor];
    [_MYLeftSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    
[self addSubview:_MYLeftSmallBtn];
[_MYLeftSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left);
    make.top.mas_equalTo(MYLeftBigBtn.mas_bottom);
    make.width.mas_equalTo(Podding * 2);
    make.height.mas_equalTo(Podding);
}];
//3右边的上层的小图1
UIButton *  MYRightSmallBtn = [[UIButton alloc] init];
//     self.leftSmallIconView.image = [UIImage imageNamed:@"设置"];
[self addSubview:MYRightSmallBtn];
    _MYRightSmallBtn = MYRightSmallBtn;
    _MYRightSmallBtn.backgroundColor = [UIColor whiteColor];
    _MYRightSmallBtn.tag = 202;
    [_MYRightSmallBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[_MYRightSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(MYLeftBigBtn.mas_right);
    make.top.mas_equalTo(self.mas_top);
    make.width.mas_equalTo(Podding );
    make.height.mas_equalTo(Podding);
    
}];
//4右边中间的第2小图
UIButton * MYRightSBtn = [[UIButton alloc] init];
//    self.rightSmallIconView.image = [UIImage imageNamed:@"设置"];
    _MYRightSBtn = MYRightSBtn;
    _MYRightSBtn.tag = 203;
    _MYRightSBtn.backgroundColor = [UIColor whiteColor];
    [_MYRightSBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    
[self addSubview:_MYRightSBtn];
[_MYRightSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(MYRightSmallBtn.mas_right);
    make.top.mas_equalTo(self.mas_top);
    make.width.mas_equalTo(Podding);
    make.height.mas_equalTo(Podding);
    
}];
//5右边的中间的第三个小图
UIButton *  MYRightSTBtn= [[UIButton alloc] init];
//    self.rightSmallTwoIconView.image = [UIImage imageNamed:@"设置"];
    _MYRightSTBtn = MYRightSTBtn;
    _MYRightSTBtn.backgroundColor = [UIColor whiteColor];
    _MYRightSTBtn.tag = 204;
    [MYRightSTBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:_MYRightSTBtn];
[_MYRightSTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(MYLeftBigBtn.mas_right);
    make.top.mas_equalTo(MYRightSmallBtn.mas_bottom);
    make.height.mas_equalTo(Podding);
    make.width.mas_equalTo(Podding);
    
}];
    //右边的第四个小图
    UIButton * MYRightSBTtn = [[UIButton alloc] init];
    _MYRightSBTtn = MYRightSBTtn;
    _MYRightSBTtn.tag = 205;
    _MYRightSBTtn.backgroundColor = [UIColor whiteColor];
    [_MYRightSBTtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_MYRightSBTtn];
    [_MYRightSBTtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MYRightSTBtn.mas_right);
        make.top.mas_equalTo(MYRightSBtn. mas_bottom);
        make.width.mas_equalTo(Podding);
        make.height.mas_equalTo(Podding);
    }];
    
 
    
//6右边的下边的大图
UIButton * MYRightBigBtn = [[UIButton alloc] init];
    _MYRightBigBtn = MYRightBigBtn;
    _MYRightBigBtn.tag = 206;
    _MYRightBigBtn.backgroundColor = [UIColor whiteColor];
    [_MYRightBigBtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_MYRightBigBtn];
[_MYRightBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(MYLeftSmallBtn.mas_right);
    make.top.mas_equalTo(MYRightSBTtn. mas_bottom);
    make.width.mas_equalTo(Podding* 2);
    make.height.mas_equalTo(Podding);
}];
    
    
}

-(void)toPush:(UIButton *)button{
    HomeModel * model = _array[button.tag- 200];
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
