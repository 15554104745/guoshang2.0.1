//
//  MerchandiseShopInfoTableViewCell.m
//  Demo
//
//  Created by suntao on 16/8/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import "MerchandiseShopBasicInfoTableViewCell.h"
#import "UIImageView+WebCache.h"

NSString *const kMerchandiseShopBasicInfoTableViewCellIdentifier = @"MerchandiseShopBasicInfoTableViewCell";

@interface MerchandiseShopBasicInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *shopDetailButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinshang01;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinshang02;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guanzhu01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guanzhu02;

@property (weak, nonatomic) IBOutlet UIView *backView;


@end
 
@implementation MerchandiseShopBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)merchandiseShopBasicInfoAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.block) {
        self.block(index);
    }
}


- (void)setModel:(GoodsDetailShopInfoModel *)model {
    
    _model = model;
    
    self.shop_name.text = model.shop_title;
    self.shop_collect.text = model.collect_num.length > 0 ? model.collect_num : @"0";
    self.shop_allgoods.text = model.goods_num.length > 0 ?  model.goods_num : @"0";
    NSString *logo = model.shoplogo;
    if ([logo rangeOfString:@"http"].location == NSNotFound) {
        logo = [NSString stringWithFormat:@"%@%@",ImageBaseURL,logo];
    }
    [self.shop_image sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.shop_newGoods.text = [NSString stringWithFormat:@"%ld",model.new_num];
    
    if ([model.shop_id isEqualToString:@"0"]) {
        self.shopDetailButton.hidden = YES;
        self.concernBtn.hidden = YES;
        
        self.backView.hidden = YES;
//        _xinshang01.priority = 250;
//        _xinshang02.priority = 750;
//        _guanzhu01.priority = 250;
//        _guanzhu02.priority = 750;
    }
    
    //判断是否已经收藏
    if ([model.is_collect isEqualToString:@"Y"]) {
        self.concernBtn.selected = YES;
    }else {
        self.concernBtn.selected = NO;
    }
    
    
}












@end
