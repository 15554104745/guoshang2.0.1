//
//  ShoesCell.m
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ShoesCell.h"
#import "GoodsViewController.h"
#import "SearchResultViewController.h"
#import "GoodsShowViewController.h"
@implementation ShoesCell
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
        HomeModel * model1 = _array[_XZLeftBigbtn.tag - 300];
        
        [_XZLeftBigbtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model1.url]];
        HomeModel * model2 = _array[_XZLeftSbtn.tag - 300];
        
        [_XZLeftSbtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model2.url]];
        HomeModel * model3 = _array[_XZRightBbtn.tag - 300];
        
        [_XZRightBbtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model3.url]];
        
        HomeModel * model4 = _array[_XZRigntSbtn.tag- 300];
        [_XZRigntSbtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model4.url]];
        
       
        
    }
    
}



-(void)createUI{
    
    UIButton * XZLeftSbtn = [[UIButton alloc] init];
    _XZLeftSbtn = XZLeftSbtn;
    _XZLeftSbtn.tag = 300;
    _XZLeftSbtn.backgroundColor = [UIColor whiteColor];
    [_XZLeftSbtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_XZLeftSbtn];
    [_XZLeftSbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding);
        
    }];
    
    //3左边的下方的大图
    UIButton * XZLeftBigbtn = [[UIButton alloc] init];
    _XZLeftBigbtn = XZLeftBigbtn;
    _XZLeftBigbtn.tag = 301;
    _XZLeftBigbtn.backgroundColor = [UIColor whiteColor];
    [_XZLeftBigbtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_XZLeftBigbtn];
    [_XZLeftBigbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(_XZLeftSbtn.mas_bottom);
        make.width.mas_equalTo(Podding * 2);
        make.height.mas_equalTo(Podding * 2);
    }];
    
    //4.右边的大图
    UIButton * ZRightBbtn = [[UIButton alloc] init];
   _XZRightBbtn = ZRightBbtn;
    _XZRightBbtn.tag = 302;
    _XZRightBbtn.backgroundColor = [UIColor whiteColor];
    [_XZRightBbtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_XZRightBbtn];
    [_XZRightBbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_XZLeftSbtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(Podding *2);
        make.height.mas_equalTo(Podding * 2);
    }];
    
    //5右边下方的第一小图
    UIButton * XZRigntSbtn = [[UIButton alloc] init];
  _XZRigntSbtn = XZRigntSbtn;
    _XZRigntSbtn.tag = 303;
    _XZRigntSbtn.backgroundColor = [UIColor whiteColor];
    [_XZRigntSbtn addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_XZRigntSbtn];
    [_XZRigntSbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_XZLeftBigbtn.mas_right);
        make.top.mas_equalTo(_XZRightBbtn.mas_bottom);
        make.width.mas_equalTo(Podding * 2 );
        make.height.mas_equalTo(Podding );
    }];
}

-(void)toPush:(UIButton *)button{
  
    HomeModel * model = _array[button.tag- 300];
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
