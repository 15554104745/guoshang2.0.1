//
//  GSWillPayOrderTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSWillPayOrderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GSOrderGoodsModel.h"
#import "GSOrderGoodsView.h"

@interface GSWillPayOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;

@property (weak, nonatomic) IBOutlet UIView *goodsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;

@end

@implementation GSWillPayOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsListModel:(GSOrderGoodsListModel *)goodsListModel {
    _goodsListModel = goodsListModel;
   
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.shop_logo] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.shopTitleLabel.text = goodsListModel.shop_title;
    self.shopPhoneLabel.text = goodsListModel.shop_phone;
    
     self.goodsViewHeight.constant = goodsListModel.goods_list.count * 90.0f - 10;
    [self updateGoodsView];
    
}

- (void)updateGoodsView {
    [[self.goodsView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    __weak typeof(self) weakSelf = self;
    __block GSOrderGoodsView *lastView = nil;
    [_goodsListModel.goods_list enumerateObjectsUsingBlock:^(GSOrderGoodsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GSOrderGoodsView *goodsView = [[GSOrderGoodsView alloc] init];
        goodsView.orderGoodsModel = obj;
        [weakSelf.goodsView addSubview:goodsView];
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.offset(0);
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xuxian"]];
                [weakSelf.goodsView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(5);
                    make.left.offset(10);
                    make.right.offset(-10);
                }];
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            
            make.left.right.mas_offset(0);
            make.height.offset(80);
            lastView = goodsView;
        }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
