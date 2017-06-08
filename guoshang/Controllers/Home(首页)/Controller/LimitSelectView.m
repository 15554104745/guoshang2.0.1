//
//  LimitSelectView.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LimitSelectView.h"
typedef void(^Block)(NSInteger index);
@implementation LimitSelectView
{
    Block _block;
    
    UIImageView * _barView;
    NSString *_number;//用来接收信息,作为中转变量用的
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createSelectView];
        
    }
    return self;
}
-(void)createSelectView{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    NSArray * titleArray = @[@"正在抢购",@"即将开始"];
    for (NSInteger i = 0; i < 2; i++) {
        LNButton * button = [LNButton buttonWithFrame:CGRectMake(i * (self.frame.size.width/2 + 10), 0, self.frame.size.width/2, self.frame.size.height) Type:UIButtonTypeCustom Title:titleArray[i] Font:18 Target:self AndAction:@selector(toClick:)];
        button.tag = i+ 80;
        if (i == self.selectPlage) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [button setTitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:112/255.0 green:110/255.0 blue:110/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self addSubview:button];
        for (NSInteger i = 0; i < 1; i++) {
            UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * (self.frame.size.width/2 - 1), 5, 1, self.frame.size.height - 10)];
            icon.image = [UIImage imageNamed:@"fengexian"];
            [self addSubview:icon];
            
        }
    }
    
    
    UIImageView * subBar = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 40, self.frame.size.width, 2)];
    subBar.image = [UIImage imageNamed:@"2px"];
    [self addSubview:subBar];
    
    CGFloat barWith =  (self.frame.size.width-30) / 2;
    _barView = [[UIImageView alloc] initWithFrame:CGRectMake(barWith * self.selectPlage , 40, barWith, 8)];
    _barView.image = [UIImage imageNamed:@"barImage"];
    [self addSubview:_barView];
    
}
-(void)toClick:(UIButton *)button{

    for (int i = 0; i < 2; i++) {
        UIButton * btn = [self viewWithTag:i+ 80];
        if (i == button.tag - 80) {
            btn.selected = YES;
            self.selectPlage = i;
        }else{
            btn.selected = NO;
        }
    }
    
    CGPoint center = _barView.center;
    center.x = button.center.x;
    [UIImageView animateWithDuration:0.5 animations:^{
       
        _barView.center = center;
    }];
    
    NSInteger index = button.tag - 80;
    if (_block) {
        _block(index);
    }
 
}

-(void)setCallbackBlock:(void (^)(NSInteger))block{
    _block = [block copy];
}


//回调方法
-(void)selectBtn:(NSInteger)index{
    
    for (int i = 0; i < 2; i++) {
        UIButton * button =[self viewWithTag:i + 80];
        if (i == index) {
            self.selectPlage = i;
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    CGPoint center = _barView.center;
    UIButton * btn = [self viewWithTag:index + 80];
    center.x = btn.center.x;
    [UIImageView animateWithDuration:0.5 animations:^{
        _barView.center = center;
    }];
}

@end
