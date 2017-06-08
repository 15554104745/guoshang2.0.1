//
//  GSHomecell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//
#import "UIView+UIViewController.h"
#import "GoodsShowViewController.h"
#import "GSHomecell.h"
#import "GoodsInfoViewController.h"
#import "GoodsDetailViewController.h"
//#import "GSShopGoodsInfoViewController.h"
@implementation GSHomecell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}
-(void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    LNButton * btn  = [LNButton buttonWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:12.0f BackgroundImage:@"111" andBlock:^(LNButton *button) {
        //                UIViewController * contr = [[NSClassFromString(array[2])alloc]init];
        //              [self.popView.navigationController pushViewController:contr animated:YES];
    }];
    _ImgeBtn = btn;
    [self addSubview:_ImgeBtn];
    //名字
    self.titleLab =[LNLabel addLabelWithTitle:@"￥397.00" TitleColor:[UIColor grayColor] Font:10.0f BackGroundColor: [UIColor clearColor]];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.frame = CGRectMake(0, self.bounds.size.width + 3, self.bounds.size.width, 20);
    [self addSubview: self.titleLab];
    //原件
    _markLab = [LNLabel addLabelWithTitle:@"￥397.00" TitleColor:[UIColor grayColor] Font:10.0f BackGroundColor: [UIColor clearColor]];
    _markLab.textAlignment = NSTextAlignmentCenter;
    _markLab.frame = CGRectMake(0, self.bounds.size.width + 25, self.bounds.size.width, 20);
    [self addSubview:_markLab];
    //线
    LNLabel * wire = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:11.0f BackGroundColor:[UIColor grayColor]];
    wire.frame = CGRectMake(0, self.frame.size.width+ 25 +(_markLab.bounds.size.height / 2), self.bounds.size.width, 1);
    [self addSubview:wire];
    
    //现价
    _priceLab = [LNLabel addLabelWithTitle:@"" TitleColor:NewRedColor Font:11.0f BackGroundColor:[UIColor clearColor]];
    _priceLab.textAlignment = NSTextAlignmentCenter;
    _priceLab.frame = CGRectMake(0, self.bounds.size.width + 47, self.bounds.size.width, 20);
    
    [self addSubview:_priceLab];
    
    
}

-(void)setDataModel:(HomeModel *)dataModel{
    
    _dataModel = dataModel;
    [self setttingData];
}

-(void)setttingData{
    __weak typeof(self) weakSelf = self;
    [_ImgeBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_dataModel.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _ImgeBtn.tempBlock = ^(LNButton *button){
        
//        GoodsDetailViewController  *goodsShow = [GoodsDetailViewController createGoodsDetailView];
//            GSShopGoodsInfoViewController *goodsShow = [GSShopGoodsInfoViewController createGoodsDetailView];
        GoodsInfoViewController *goodsShow = [[GoodsInfoViewController alloc]init];
        goodsShow.goodId = weakSelf.dataModel.goods_id;
        goodsShow.incomStyle = 1;
        //        NSLog(@"%@", weakSelf.dataModel.goods_id);
        goodsShow.hidesBottomBarWhenPushed = YES;
        [weakSelf.viewController.navigationController pushViewController:goodsShow animated:YES];
        
    };
    _titleLab.text = _dataModel.goods_name;
    if ([self.type isEqualToString:@"1"]) {
        _priceLab.text =   [NSString stringWithFormat:@"现价:%@",_dataModel.shop_price];
    }
    else
    {
        _priceLab.text =   [NSString stringWithFormat:@"进货价:%@",_dataModel.purchase_price];
    }
    
    _markLab.text = [NSString stringWithFormat:@"市场价:%@", _dataModel.market_price];
    
    
}


@end
