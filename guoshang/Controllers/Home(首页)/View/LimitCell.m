//
//  LimitCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LimitCell.h"
#import "GoodsShowViewController.h"
#import "GSGoodsDetailInfoViewController.h"

@implementation LimitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}


-(void)setModel:(LimitModel *)model{
    self.backgroundColor = [UIColor whiteColor];
    _model = model;
    [self settingFrame];
    [self settingData];
    
}

-(void)settingFrame{
    
    CGFloat  width = (self.contentView.frame.size.width - 40)/3;
    _goodsIcon.backgroundColor = [UIColor whiteColor];
    _wire1Icon.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    CGFloat  size = [LNLabel calculateMoreLabelSizeWithString:_model.name AndWith:width * 2-10 AndFont:15];
   
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView .mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(size);
        make.width.mas_equalTo(width * 2-10);
    }];
    

        [_PriceLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel .mas_left);
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
            make.width.equalTo(@(width));
    //        make.height.mas_equalTo([LNLabel calculateLableSizeWithString:_model.promote_price AndFont:16]);
            make.height.equalTo(@20);
        }];
    
    [_oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel .mas_left);
        make.top.equalTo(_PriceLabe.mas_bottom).offset(2);
      make.width.mas_equalTo(@(width));
         make.height.equalTo(@20);
    }];
    
    
    
    [_deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_PriceLabe .mas_left);
        make.top.equalTo(_oldPrice.mas_top).offset(10);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(1);
    }];
    
    
    _wire1Icon.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 1);
    
    [_wire2Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView .mas_right);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_equalTo(2);
    }];
    
    
    //即将开始
    if ([_model.promote_status isEqualToString:@"2"]) {
        
//        _willBtn.backgroundColor = [UIColor redColor];
        [_willBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView .mas_right).offset(-15);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(22.5);
            make.width.mas_equalTo(71);
            
        }];
        
         NSString * willStr = [NSString stringWithFormat:@"将于%@月%@日%@:%@开售",_model.formated_promote_start_date_month,_model.formated_promote_start_date_day,_model.formated_promote_start_date_hour,_model.formated_promote_start_date_minute];
//        _willLabel.textAlignment = NSTextAlignmentRight;
        [_willLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView .mas_right).offset(-15);
            make.top.equalTo(_willBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo([LNLabel calculateLableSizeWithString:willStr AndFont:15].width);
            
        }];
        
        [_willIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_willLabel.mas_left);
            make.top.equalTo(_willBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(22);
            
        }];
        
        [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(width + 10));
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.width.mas_equalTo(@(width + 10));
        }];
        
    }else if([_model.promote_status isEqualToString:@"1"]){
        
        [_mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView .mas_right).offset(-15);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
       
        
        
        [_sem1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_mLabel.mas_left).offset(-2);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(10);
        }];
        
        
        [_miLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_sem1 .mas_left).offset(1);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        
        [_sem2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_miLabel.mas_left).offset(-2);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(10);
        }];
        
        [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_sem2 .mas_left).offset(1);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30);
        }];
        
        _timelabel.textAlignment = NSTextAlignmentRight;
        [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_hourLabel .mas_left).offset(-5);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        
        [_BuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView .mas_right).offset(-15);
            make.top.equalTo(_mLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(22.5);
            make.width.mas_equalTo(65);
        }];
        
        _progressIcon.hidden = YES;
        [_progressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_BuyBtn .mas_left).offset(-10);
            make.top.equalTo(_mLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(_timelabel.mas_left);
            make.height.mas_equalTo(10);
        }];
        
        
        [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.width.mas_equalTo(@(width + 10));
            make.height.mas_equalTo(@(width + 10));
            make.top.equalTo(self.contentView.mas_top).offset(10);
        }];
        
        
        [_limitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_goodsIcon .mas_right);
            make.left.equalTo(_goodsIcon.mas_left);
            make.top.equalTo(_goodsIcon.mas_top);
            make.height.mas_equalTo(65);
            
        }];
        

    }else{
        
        [_BuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView .mas_right).offset(-15);
            make.top.equalTo(_oldPrice.mas_bottom).offset(2);
            make.height.mas_equalTo(22.5);
            make.width.mas_equalTo(65);

        }];
        
        [_goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.width.mas_equalTo(@(width + 10));
            make.height.mas_equalTo(@(width + 10));
        }];
        
        
        [_limitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_goodsIcon .mas_right);
            make.left.equalTo(_goodsIcon.mas_left);
            make.top.equalTo(_goodsIcon.mas_top);
            make.height.mas_equalTo(65);
            
        }];

        
    }
    
    _cellHeight +=size;
    _cellHeight += [LNLabel calculateLableSizeWithString:_model.promote_price AndFont:16].height + 5;
    _cellHeight += [LNLabel calculateLableSizeWithString:_model.shop_price AndFont:14].height +2;
    _cellHeight += 80;
}

-(void)createUI{
    UIImageView * goodsIcon = [[UIImageView alloc] init];
    _goodsIcon = goodsIcon;
    [self.contentView addSubview:goodsIcon];
    
    UIImageView * limitIcon = [[UIImageView alloc] init];
    _limitIcon = limitIcon;
    [_goodsIcon addSubview:limitIcon];
    
    UIImageView * wire1Icon = [[UIImageView alloc] init];
    _wire1Icon = wire1Icon;
    _wire1Icon.image = [UIImage imageNamed:@"1Px"];
    [self.contentView addSubview:wire1Icon];
    
    UIImageView * wire2Icon = [[UIImageView alloc] init];
    _wire2Icon = wire2Icon;
    _wire2Icon.image = [UIImage imageNamed:@"2px"];
    [self.contentView addSubview:wire2Icon];
    
    LNLabel * titleLabel = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0  blue:152/255.0  alpha:1.0] Font:14 BackGroundColor:nil];
    titleLabel.numberOfLines = 0;
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    LNLabel * PriceLabe = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0  blue:54/255.0  alpha:1.0] Font:14 BackGroundColor:[UIColor whiteColor]];
    _PriceLabe = PriceLabe;
    [self.contentView addSubview:PriceLabe];
    
    UILabel * oldPrice = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor colorWithRed:138/255.0 green:138/255.0  blue:138/255.0  alpha:1.0] Font:13 BackGroundColor:[UIColor whiteColor]];
    _oldPrice = oldPrice;
    [self.contentView addSubview:oldPrice];
    
    UILabel * deleLabel = [LNLabel addLabelWithTitle:nil TitleColor:nil Font:14 BackGroundColor:[UIColor colorWithRed:138/255.0 green:138/255.0  blue:138/255.0  alpha:1.0]];
    _deleLabel = deleLabel;
    [_oldPrice addSubview:deleLabel];
    
    UILabel * timelabel = [LNLabel addLabelWithTitle:@"剩余时间" TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0  alpha:1.0] Font:14 BackGroundColor:[UIColor whiteColor]];
    _timelabel = timelabel;
    [self.contentView addSubview:timelabel];
    
    
    UILabel * hourLabel = [LNLabel addLabelWithTitle:@"12" TitleColor:[UIColor whiteColor] Font:13 BackGroundColor:[UIColor blackColor]];
     hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel = hourLabel;

    [self.contentView addSubview:hourLabel];
    
    
    UILabel * sem1 = [LNLabel addLabelWithTitle:@":" TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0  alpha:1.0] Font:14 BackGroundColor:[UIColor whiteColor]];
    sem1.font = [UIFont boldSystemFontOfSize:14];

    _sem1 = sem1;
    _sem1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:sem1];
    UILabel * miLabel = [LNLabel addLabelWithTitle:@"12" TitleColor:[UIColor whiteColor] Font:14 BackGroundColor:[UIColor blackColor]];
    _miLabel = miLabel;
      _miLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:miLabel];
    UILabel * sem2 = [LNLabel addLabelWithTitle:@":" TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0  alpha:1.0] Font:14 BackGroundColor:[UIColor whiteColor]];
    sem2.font = [UIFont boldSystemFontOfSize:14];
    _sem2 = sem2;
    _sem2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:sem2];
    UILabel * mLabel = [LNLabel addLabelWithTitle:@"12" TitleColor:[UIColor whiteColor] Font:14 BackGroundColor:[UIColor blackColor]];
    _mLabel = mLabel;
      _mLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:mLabel];
    
    
    UIButton * BuyBtn = [LNButton buttonWithFrame:CGRectMake(0, 0, 20, 20) Type:UIButtonTypeCustom Title:nil Font:12 Target:self AndAction:@selector(toBuy)];
   
    _BuyBtn = BuyBtn;
    [self.contentView addSubview:BuyBtn];
    
    UIProgressView * progressIcon = [[UIProgressView alloc] init];
    [self.contentView addSubview:progressIcon];
    _progressIcon = progressIcon;
    
    //即将抢购的页面布局
    LNButton * willBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:12 Target:self AndAction:@selector(toBuy)];
    _willBtn = willBtn;
    [_willBtn setBackgroundImage:[UIImage imageNamed:@"guangguang"] forState:UIControlStateNormal];
    [self.contentView addSubview: willBtn];
    
    LNLabel * willLabel = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor whiteColor] Font:14 BackGroundColor:NewRedColor];
    _willLabel = willLabel;
    
    UIImageView * willIcon = [[UIImageView alloc] init];
    willIcon.image = [UIImage imageNamed:@"naozhong"];
    willIcon.backgroundColor = NewRedColor;
    _willIcon = willIcon;
    [self.contentView addSubview:willIcon];
    
    [self.contentView addSubview:willLabel];

}
-(void)settingData{
    
    _titleLabel.text = _model.name;
   [ _goodsIcon setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _PriceLabe.text = _model.promote_price;
    _oldPrice.text = _model.shop_price;
    
    if ([_model.promote_status isEqualToString:@"1"]) {
        [_BuyBtn setBackgroundImage:[UIImage imageNamed:@"lijiqiang"] forState:UIControlStateNormal];
        [_limitIcon setImage:[UIImage imageNamed:@"xianshiLog"]];
        
        self.LimitCount =[LNLabel limitWithEndTime:_model.promote_end_date];
        self.LimitCount.delegate = self;
        
       
        
    }else if([_model.promote_status isEqualToString:@"0"]){
        [_BuyBtn setBackgroundImage:[UIImage imageNamed:@"yiqiangwan2"] forState:UIControlStateNormal];
        _BuyBtn.userInteractionEnabled = NO;
        [_limitIcon setImage:[UIImage imageNamed:@"yiqiangwan"]];
     
        
    }else{
      
           NSString * willStr = [NSString stringWithFormat:@"将于%@月%@日%@:%@开售",_model.formated_promote_start_date_month,_model.formated_promote_start_date_day,_model.formated_promote_start_date_hour,_model.formated_promote_start_date_minute];
        _willLabel.text = willStr;
    }
    
    
    
}

-(void)LimitOngoing:(NSArray *)djsArr{

    
    _hourLabel.text = djsArr[0];
    _miLabel.text = djsArr[1];
     _mLabel.text = djsArr[2];
    
    
}


-(void)LimitEnd:(NSArray *)djsArr{
    _hourLabel.text = djsArr[0];
    _miLabel.text = djsArr[1];
    _mLabel.text = djsArr[2];
}
-(void)toBuy{
    GSGoodsDetailInfoViewController * goodsShow = [[GSGoodsDetailInfoViewController alloc] init];
    
    goodsShow.recommendModel = _model;
    goodsShow.hidesBottomBarWhenPushed = YES;
    [self.popView.navigationController pushViewController:goodsShow animated:YES];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
