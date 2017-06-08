//
//  ShopStateView.m
//  WYP
//
//  Created by RY on 16/7/19.
//  Copyright © 2016年 RY. All rights reserved.
//

#import "ShopStateView.h"

@interface ShopStateView ()
@property (nonatomic,weak) UIView *lineView;

@end

@implementation ShopStateView{
    UIView *_redLine;
    UIButton *_LastBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
//        [self createSubViews];
        self.titleSize = 15;
    }
    return self;
}

#pragma mark - PublicFunctions 
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    [self createSubViews];
}

- (void)createSubViews {
    
//    NSArray *titles = @[@"全部", @"待付款", @"待发货", @"待收货", @"已完成"];
   NSArray *titles = self.titles;
    CGFloat itemW = self.bounds.size.width/titles.count;
    CGFloat itemH = 35.f;
    CGFloat itemY = 0.f;
    
    for (int i = 0; i < titles.count; i++) {
        CGFloat itemX = i*itemW;
        UIButton *itemsBtn = [[UIButton alloc]initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        itemsBtn.tag = i+100;
        [itemsBtn setTitle:titles[i] forState:UIControlStateNormal];
        [itemsBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [itemsBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] forState:UIControlStateNormal];
        itemsBtn.titleLabel.font = [UIFont systemFontOfSize:self.titleSize];
        [itemsBtn addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemsBtn];
        
        if (0 == i) {   //默认第一个
            [self itemClickAction:itemsBtn];
        }
    }
    
    //分割线
    UIView *garyLine = [[UIView alloc]initWithFrame:CGRectMake(0, itemH, self.bounds.size.width, 1)];
    garyLine.backgroundColor = [UIColor lightGrayColor];
    garyLine.alpha = .7f;
    self.lineView = garyLine;
    [self addSubview:garyLine];
    
    //红色分割线
    _redLine = [[UIView alloc]initWithFrame:CGRectMake(0, 35.f, itemW, 1)];
    _redLine.backgroundColor = [UIColor redColor];
    [self addSubview:_redLine];
}

-(void)setLineHidden:(BOOL)lineHidden{
    _lineHidden = lineHidden;
    self.lineView.hidden = lineHidden;
}
/**
 *  状态类型点击事件
 */
- (void)itemClickAction:(UIButton *)button {
    button.selected = YES;
    _LastBtn.selected = NO;
    _LastBtn = button;
    
    [UIView animateWithDuration:0.23 animations:^{
        _redLine.frame = CGRectMake(button.frame.origin.x,35.f, _redLine.bounds.size.width, 1);
    }];
    
    //代理方法
    if ([self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
        [self.delegate didSelectedItem:(button.tag-100.0)];
    }

}

-(void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
  UIButton *button = (UIButton*)[self viewWithTag:selectIndex+100];
    button.selected = YES;
    _LastBtn.selected = NO;
    _LastBtn = button;
    [UIView animateWithDuration:0.23 animations:^{
        _redLine.frame = CGRectMake(button.frame.origin.x, 35.f, _redLine.bounds.size.width, 1);
    }];
   

}
@end
