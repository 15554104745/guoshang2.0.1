//
//  BaseCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "BaseCell.h"
#import "UIImageView+WebCache.h"
#define ALlWord  [UIColor colorWithRed:89/255.0 green:89/255.0  blue:89/255.0  alpha:1.0]
@implementation BaseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
       
    }
    return self;
}
-(void)addUI{
    //价格
    LNLabel * pricelabel = [LNLabel addLabelWithTitle:_model.goods_name TitleColor:ALlWord Font:12 BackGroundColor:nil];
    [self.contentView addSubview:pricelabel];
    _priceLable = pricelabel;
    
    //数量
    LNLabel * countLabel = [LNLabel addLabelWithTitle:_model.goods_number TitleColor:ALlWord Font:12 BackGroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:countLabel];
    _countLabel = countLabel;
    //标题
    LNLabel * titleLabel = [LNLabel addLabelWithTitle:_model.goods_number TitleColor:ALlWord Font:14
    BackGroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    //运费
    LNLabel * fieLable = [LNLabel addLabelWithTitle:_model.shipping_price TitleColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]Font:12 BackGroundColor:nil];
    [self.contentView addSubview:fieLable];
    _fieghtPriceLabel = fieLable;
    //图片
    UIImageView * iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    _IconVIew = iconView;
    
    
    UIImageView * wireIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:wireIcon];
    _wireIcon = wireIcon;
    
    
}

-(void)setttingFrame{
    //价格
    _priceLable.textAlignment = NSTextAlignmentRight;
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    //数量
    _countLabel.textAlignment = NSTextAlignmentRight;
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLable.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(60);
        make.height.equalTo(@20);
    }];
    
   //标题
    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    _titleLabel.numberOfLines = 0;
//    CGFloat  height = [LNLabel calculateMoreLabelSizeWithString:_model.goods_name AndWith:self.frame.size.width - 170 AndFont:15];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).equalTo(@10);
        make.right.equalTo(_priceLable.mas_left).offset(-2);
//        make.height.equalTo(@(height));
        make.width.mas_equalTo(self.frame.size.width - 180);
    }];
    
    //运费
   

    [_IconVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).equalTo(@10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        //make.height.mas_equalTo(100);
        make.right.equalTo(_titleLabel.mas_left).offset
        (-10);
         make.height.mas_equalTo(_IconVIew.mas_width);
    }];
    
    [_fieghtPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_IconVIew.mas_bottom);
        make.left.equalTo(_IconVIew.mas_right).offset(10);
        make.height.mas_equalTo([LNLabel calculateMoreLabelSizeWithString:_model.goods_price AndWith:self.frame.size.width - 160 AndFont:15]);
        make.width.mas_equalTo(self.frame.size.width - 170);
    }];
    
    
    [_wireIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(self.frame.size.width - 20);
    }];
}
  
-(void)setModel:(GoodsModel *)model{
    _model = model;
    [self settingData];
     [self setttingFrame];
 
}

-(void)settingData{
    _priceLable.text = [NSString stringWithFormat:@"￥%@",_model.goods_price];
    _countLabel.text = [NSString stringWithFormat:@"x %@",_model.goods_number];
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    _titleLabel.numberOfLines = 0;
    _fieghtPriceLabel.text = [NSString stringWithFormat:@"运费：%@",_model.shipping_price];

    [_IconVIew sd_setImageWithURL:[NSURL URLWithString:_model.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    [_wireIcon setImage:[UIImage imageNamed:@"xuxian"]];
    
    //    NSString * str = [NSString stringWithFormat:@"http://www.ibg100.com%@",_model.goods_thumb ];
    //    [_IconVIew sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
