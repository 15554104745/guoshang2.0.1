//
//  LNButton.m
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LNButton.h"

@implementation LNButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(LNButton *)buttonWithFrame:(CGRect)frame Type:(UIButtonType)type Title:(NSString *)title Font:(CGFloat)font Target:(id)target AndAction:(SEL)sel{
    LNButton *button = [LNButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(LNButton *)buttonWithType:(UIButtonType)type Title:(NSString *)title TitleColor:(UIColor *) titleColor Font:(CGFloat)font Target:(id)target AndAction:(SEL)sel{
    LNButton *button = [LNButton buttonWithType:type];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    [button setTintColor:titleColor];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(LNButton *)buttonWithFrame:(CGRect)frame Type:(UIButtonType )type Title:(NSString *)title TitleColor:(UIColor*)titleColor Font:(CGFloat)font BackgroundImage:(NSString * )image andBlock:(buttonBlock)block{
    LNButton *button = [LNButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(blockButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //将参数接收过来,保存到成员变量中
    button.tempBlock = block;
    return button;

}

+(LNButton *)buttonWithType:(UIButtonType )type Title:(NSString *)title TitleColor:(UIColor*)titleColor Font:(CGFloat)font image:(NSString * )image andBlock:(buttonBlock)block{
    LNButton *button = [LNButton buttonWithType:type];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(blockButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //将参数接收过来,保存到成员变量中
    button.tempBlock = block;
    return button;
    
}


-(void)blockButtonclicked:(LNButton *)button{
    //执行block变量
    button.tempBlock(button);
    
}
@end
