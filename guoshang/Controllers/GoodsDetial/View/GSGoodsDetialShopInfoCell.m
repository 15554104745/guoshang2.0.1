//
//  GSGoodsDetialShopInfoCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetialShopInfoCell.h"
#import "UIColor+HaxString.h"
#import "UIImageView+WebCache.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"

const CGFloat GoodsNumberViewHeight = 35.0f;
const CGFloat CollectButtonViewHeight = 38.0f;

@implementation GSGoodsDetialShopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shopIconImageView.layer.borderColor = [[UIColor colorWithHexString:@"bfbfbf"] CGColor];
    self.shopIconImageView.layer.borderWidth = 0.5f;
}

- (void)setDetailModel:(GSGoodsDetailModel *)detailModel {
    [super setDetailModel:detailModel];
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.shop_info.shoplogo] placeholderImage:[UIImage imageNamed:@"icon_goodsDetail_shopLogo"]];
    self.shopTitleLabel.text = detailModel.shop_info.shop_title;

    [self setupShowCollectAndGoodsNumberWithIsYigoShop:[detailModel.shop_info.shop_id isEqualToString:@"0"]];
    [self setupGoodsNumber];
    [self setupCollect];
}

- (void)setupGoodsNumber {
    self.allGoodsCountLabel.text = self.detailModel.shop_info.goods_num;
    self.addGoodsCountLabel.text = self.detailModel.shop_info.isNew_num;
    self.carePeopleCountLabel.text = self.detailModel.shop_info.collect_num;
}

- (void)setupShowCollectAndGoodsNumberWithIsYigoShop:(BOOL)isYigoShop {
//    self.goodsNumberViewHeight.constant = isYigoShop ? 0 : GoodsNumberViewHeight;
//    self.collectButtonViewHeight.constant = isYigoShop ? 0 : CollectButtonViewHeight;
//    self.marginConstant.constant = isYigoShop ? -5.0f : 22.0f;
    
    self.goodsNumberViewHeight.constant = 0 ;
    self.collectButtonViewHeight.constant = 0;
    self.marginConstant.constant = -5.0f;
}

- (void)setupCollect {
    self.collectShopButton.selected = [self.detailModel.shop_info.is_collect boolValue];
}

- (IBAction)collectShopButtonClick:(UIButton *)sender {
    if (UserId) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.contentView];
        __weak typeof(self) weakSelf = self;
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Collect/CollectShop") parameters:[@{@"user_id":UserId,@"shop_id":self.detailModel.shop_info.shop_id} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            if ([responseObject[@"status"] isEqualToString:@"0"]) {
                [self changeCollectType];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
- (IBAction)toShopButtonClick:(id)sender {
}

- (void)changeCollectType {
    self.collectShopButton.selected = !self.collectShopButton.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
