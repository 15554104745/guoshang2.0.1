//
//  HomeCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeCell.h"
#import "GoodsShowViewController.h"
#import "UIView+UIViewController.h"
#import "UIColor+HaxString.h"
#import "UIColor+Hex.h"
@implementation HomeCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
     [self createUI];
    }
    return self;
}

-(void)createUI{
    _titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 180)];
    _titleView.userInteractionEnabled = YES;
//    _titleView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_titleView];
    UIButton *headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageButton addTarget:self action:@selector(headerImageTouch) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:headerImageButton];
    
    [headerImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
    }];
    
    __weak typeof(self.contentView)weakSelf = self.contentView;
    _recommedView = [[UIView alloc] init];
    [self.contentView addSubview:_recommedView];
    [_recommedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.mas_equalTo(_titleView.mas_bottom).equalTo(@5);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).equalTo(@-10);
    }];
    [self addsubView];
  
}

- (void)headerImageTouch {
//    NSLog(@"headImageTouch");
    if (_headerImageTouchBlock) {
        _headerImageTouchBlock(_myAdDic[@"cat_id"]);
    }
}


-(void)addsubView{
    CGFloat xSpace = 10;
   int count = 3;
    CGFloat btnWith = (self.bounds.size.width- 40) /3;
    
    for (NSInteger i = 0; i<3; i++){
        //HomeModel * model = _myArray[i];
        //button图片
        LNButton * btn = [LNButton buttonWithFrame:CGRectMake(xSpace+(i%count)*(xSpace+btnWith), (i/count)*(xSpace+btnWith + 20), btnWith, btnWith)Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:14.0f BackgroundImage:@"11" andBlock:^(LNButton *button) {
//            NSLog(@"跳转到详情页");
            
            
#warning ---跳转到产品详情界面  需要传入商品ID
           
            
            
            
//            UIViewController * contr = [[NSClassFromString(array[2])alloc]init];
//            [self.popView.navigationController pushViewController:contr animated:YES];
        }];
        btn.tag = 4040 + i;
        //新品图片
        LNLabel * newLabel = [LNLabel addLabelWithTitle:@"新品" TitleColor:[UIColor whiteColor] Font:10.0f BackGroundColor:NewRedColor];
        newLabel.tag = 1234+i;
        newLabel.frame = CGRectMake(xSpace+(i%count)*(xSpace+btnWith), btnWith+ 3+(i/count)*(xSpace+btnWith + 20), 30, 15);
        newLabel.textAlignment = NSTextAlignmentCenter;
        newLabel.layer.cornerRadius = 5;
        newLabel.clipsToBounds = YES;//title
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(xSpace+(i%count)*(xSpace+btnWith), btnWith + 21+(i/count)*(xSpace+btnWith + 20), btnWith, 40)];
        lable.text = @"这是一件美哒哒的衣服,特别的漂亮特别美丽";
        lable.numberOfLines = 2;
        lable.tag = 4050 + i;
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.textColor= [UIColor colorWithRed:32/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
        //价格
        LNLabel * priceLabel = [LNLabel addLabelWithTitle:@"￥397.00" TitleColor:NewRedColor Font:10.0f BackGroundColor:[UIColor clearColor]];
        [_recommedView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(btnWith + 63 +(i/count));
            make.left.offset(xSpace+(i%count)*(xSpace+btnWith));
        }];
        //priceLabel.frame = CGRectMake(xSpace+(i%count)*(xSpace+btnWith), btnWith + 63 +(i/count)*(xSpace+btnWith + 20), btnWith / 2, 15);
        priceLabel.tag = 4060 + i;
        //原价
        LNLabel * otherLabel = [LNLabel addLabelWithTitle:@"￥397.00" TitleColor:[UIColor grayColor] Font:9.0f BackGroundColor:[UIColor clearColor]];
        //otherLabel.frame = CGRectMake(xSpace+(i%count)*(xSpace+btnWith) + btnWith/2, btnWith + 80 +(i/count)*(xSpace+btnWith + 20), btnWith / 2, 15);
        [_recommedView addSubview:otherLabel];
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLabel.mas_bottom).offset(1);
            make.left.equalTo(priceLabel.mas_left);
        }];
        //线
        
        otherLabel.tag = 4070 + i;
        LNLabel * wire = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:11.0f BackGroundColor:[UIColor grayColor]];
       
        [otherLabel addSubview:wire];
        [wire mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(otherLabel.mas_centerY);
            make.height.offset(1);
            make.width.equalTo(otherLabel.mas_width);
        }];
        
        
        [_recommedView addSubview:lable];
        [_recommedView addSubview:newLabel];
        [_recommedView addSubview:btn];
        
        
    }
    
}


-(void)setMyAdDic:(NSDictionary *)myAdDic{
    
    _myAdDic = myAdDic;
    
    [self settingTitleData];
}

-(void)settingTitleData{
    
    [_titleView setImageWithURL:[NSURL URLWithString:_myAdDic[@"ad_image"]] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}
-(void)setMyArray:(NSArray *)myArray{
    
    _myArray = myArray;
    
    
    [self setttingData];
    
}
-(void)setttingData{
    for (NSInteger i  = 0; i < 3; i++) {
        HomeModel * model = _myArray[i];
        LNButton * btn = (LNButton *)[self viewWithTag:4040 + i];
//        NSLog(@"cell的下边%@",model.thumb);
        [btn setTempBlock:^(LNButton *button) {
            GoodsShowViewController *goodsShow = [[GoodsShowViewController alloc]init];
            
            goodsShow.goodId = model.goods_id;
            
            goodsShow.hidesBottomBarWhenPushed=YES;
            [self.viewController.navigationController pushViewController:goodsShow animated:YES];
        }];
        //[btn setBackgroundColor:[UIColor whiteColor]];
        //[btn setContentMode:UIViewContentModeRedraw];
        [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
//        [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
        
        UILabel * titleLable = (UILabel *)[self viewWithTag:4050 + i];
        titleLable.text = model.name;
        
        UILabel * priceTitle = (UILabel *)[self viewWithTag:4060 + i];
        priceTitle.text = (model.promote_price && ![model.promote_price isEqualToString:@""]) ? model.promote_price : model.shop_price;
        
        UILabel * otherTitle = (UILabel *)[self viewWithTag:4070 + i];
        otherTitle.text = model.market_price;
        
        UILabel *label = [self viewWithTag:1234+i];
        label.backgroundColor = [UIColor colorWithHexString:self.color];
    }
}

@end
