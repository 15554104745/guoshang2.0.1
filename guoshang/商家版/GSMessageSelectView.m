//
//  MessageSelectVIew.m
//  UISetting
//
//  Created by 金联科技 on 16/7/19.
//  Copyright © 2016年 jlkj. All rights reserved.
//

#import "GSMessageSelectView.h"
#define view_width self.frame.size.width
#define view_Height self.frame.size.height

typedef void(^Block)(NSInteger index);
@interface GSMessageSelectView ()
@property (nonatomic,strong) UIButton *leftBtton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,strong) UIButton *selectButton;

@end

@implementation GSMessageSelectView{
    Block _block;
}


-(UIView *)selectLine{
    if (!_selectLine) {
        _selectLine = [[UIView alloc] init];
        _selectLine.frame = CGRectMake(10,view_Height ,view_width/2-20, 1);
        _selectLine.backgroundColor = [UIColor redColor];
    }
    return _selectLine;
}
-(UIButton *)leftBtton {
    if (!_leftBtton) {
        _leftBtton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _leftBtton.frame = CGRectMake(0, 0, view_width, view_Height-2);
        _leftBtton.tag = 102;
        [_leftBtton setTitle:@"订单消息" forState:UIControlStateNormal];
        [_leftBtton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_leftBtton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.selectButton = _leftBtton;
        _leftBtton.selected = YES;
    }
    return _leftBtton;
}

-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(view_width/2, 0, view_width/2, view_Height-2);
        _rightButton.tag = 101;
        [_rightButton setTitle:@"账户消息" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
}
-(instancetype)initWithFrame:(CGRect)frame{
   
    if (self = [super initWithFrame:frame]) {
        /*
        UIView *middleLine =[[UIView alloc] init];
        middleLine.frame =CGRectMake(view_width/2, 5, 1, view_Height-10);
        middleLine.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:middleLine];
         */
        
        UIView *buttomLine =[[UIView alloc] init];
        buttomLine.frame = CGRectMake(0, view_Height, view_width, 1);
        buttomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:buttomLine];
        [self addSubview:self.leftBtton];
        
//        [self addSubview:self.selectLine];
//        [self addSubview:self.rightButton];
        
    }
    return self;
}


- (void)setCallbackBlock:(void(^)(NSInteger index))block {
    _block = [block copy];
}
- (void)buttonAction:(UIButton*)sender{
//    按钮的操作。。
    self.selectButton.selected = NO;
    
    sender.selected = YES;
    
    self.selectButton = sender;
    //    selectLine的操作
  
    if (sender.tag == 101) {
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.selectLine.frame =CGRectMake(view_width/2+10, view_Height, view_width/2-20, 1);

        }];
    } else {
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.selectLine.frame =CGRectMake(10,view_Height ,view_width/2-20, 1);
        }];

    }
    // 调用block运行
    if (_block) {
        _block(sender.tag-100);
    }

}
@end
