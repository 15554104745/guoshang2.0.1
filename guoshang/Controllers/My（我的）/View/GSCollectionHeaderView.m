//
//  GSCollectionHeaderView.m
//  guoshang
//
//  Created by 金联科技 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCollectionHeaderView.h"
#import "LNLabel.h"
#import "UIImageView+WebCache.h"
@interface GSCollectionHeaderView ()

@property (nonatomic,weak) UIImageView *imgView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *descripLabel;
@property (nonatomic,weak) UILabel *peopleLabel;
@property (nonatomic,weak) UILabel *priceLabel;
@property (nonatomic,weak) UIImageView *flagImg;
@property (nonatomic,weak) UIImageView *wareLine;

@end

@implementation GSCollectionHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        [self createView];
        [self testData];
    }
    return self;
}
-(void)testData{
    self.imgView.backgroundColor = [UIColor redColor];
    self.titleLabel.text = @"7.9元拼多多芒果节 小台农芒果3斤装（20-30个)成团必发";
    self.descripLabel.text = @"[预售：7月15日完成发货]";
    self.peopleLabel.text = @"20人团";
    self.priceLabel.text = @"¥7.9";
    self.flagImg.image = [UIImage imageNamed:@"group_success"];
    
    self.wareLine.image = [UIImage imageNamed:@"xuxian"];
    
}
//设置数据
-(void)setModel:(GSGroupInfoModel *)model{
    _model = model;
    self.flagImg.image = [UIImage imageNamed:@"group_success"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:@"ddd"] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.titleLabel.text = model.title;
    self.descripLabel.text = model.descrip;
    self.peopleLabel.text = [NSString stringWithFormat:@"%@人团",model.max_user_amount];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    
}

- (void)createView{
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imgView = imgView;
    [self addSubview:imgView];
    
    LNLabel *titleLabel =[LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:13 BackGroundColor:[UIColor clearColor]];
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    
    LNLabel *descripLabel = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:13 BackGroundColor:[UIColor clearColor]];
    titleLabel.numberOfLines = 0;
    self.descripLabel = descripLabel;
    [self addSubview:descripLabel];
    
    
    LNLabel *peopleLabel =  [LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:13 BackGroundColor:[UIColor clearColor]];

    self.peopleLabel = peopleLabel;
    [self addSubview:peopleLabel];
    
    LNLabel *priceLabel =  [LNLabel addLabelWithTitle:nil TitleColor:[UIColor redColor] Font:13 BackGroundColor:[UIColor clearColor]];
 
    self.priceLabel = priceLabel;
    [self addSubview:priceLabel];
    
    UIImageView *flagImg = [[UIImageView alloc] init];
    self.flagImg = flagImg;
    [self addSubview:flagImg];
    
    UIImageView *wareLine = [[UIImageView alloc] init];
    [self addSubview:wareLine];
    self.wareLine = wareLine;
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(_imgView.mas_height).offset(-20);
        
    }];
    [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(10);
        
    }];
    [self.peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(5);
        make.top.equalTo(_descripLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(_imgView.mas_bottom);
       
        
        
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_peopleLabel.mas_right).offset(5);
        make.top.equalTo(_descripLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(_imgView.mas_bottom);
    }];
    [self.flagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@80);
    }];
    [self.wareLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(Width - 20);
    }];
    
}


@end
