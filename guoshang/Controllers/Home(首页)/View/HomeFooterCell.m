//
//  HomeFooterCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeFooterCell.h"
#import "GoodsViewController.h"
@implementation HomeFooterCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //1.子控件View
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        _imageIcon = view;
        _imageIcon.backgroundColor = [UIColor redColor];
        _imageIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goClick:)];
        [_imageIcon addGestureRecognizer:tap];
        
        [self addSubview:_imageIcon];
        
        
    }
    return self;
}
-(void)setModel:(HomeModel *)model{
    
    _model = model;
   [_imageIcon setImageWithURL:[NSURL URLWithString:_model.goods_img]];
    
    
}


-(void)goClick:(UITapGestureRecognizer *)top{
//    if ([_model.type isEqualToString:@"cat_id"]) {
//        GoodsViewController * goodShow = [[GoodsViewController alloc] init];
//        goodShow.ID= _model.params;
//        goodShow.hidesBottomBarWhenPushed = YES;
//        [self.popView.navigationController pushViewController:goodShow animated:YES];
//        
//    }
    
    NSLog(@"尾视图的广告位的点选跳转");
}
@end
