//
//  GSCarGoodsTableViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarGoodsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GSCarRequestManager.h"
#import "MBProgressHUD.h"
#import "GSSpecificationsManager.h"

@implementation GSCarGoodsTableViewCell

- (GSSpecificationsManager *)specificationsManager {
    if (!_specificationsManager) {
        _specificationsManager = [[GSSpecificationsManager alloc] init];
    }
    return _specificationsManager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 传入购物车商品数据模型,填充数据
 */
- (void)setCarGoodsModel:(GSCarGoodsModel *)carGoodsModel {
    _carGoodsModel = carGoodsModel;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[carGoodsModel.goods_thumb stringByReplacingOccurrencesOfString:@"new" withString:@"www"]] placeholderImage:Goods_Pleaceholder_Image];
    
    self.goodsTitleLabel.text = carGoodsModel.goods_name;
    [self.goodsCountButton setTitle:carGoodsModel.goods_number forState:UIControlStateNormal];
    self.chackMarkButton.selected = carGoodsModel.select_goods;
    NSString *goods_price = [[carGoodsModel.goods_price componentsSeparatedByString:@"."][0] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    self.goodsPriceLabel.text = goods_price;
    self.decimalLabel.text = [[carGoodsModel.goods_price componentsSeparatedByString:@"."] lastObject];
    [self changeButtonStatusWithCount:[self.carGoodsModel.goods_number integerValue]];

    if (carGoodsModel.attr_names && ![carGoodsModel.attr_names isEqualToString:@""]) {
        self.attributeLabel.text = carGoodsModel.attr_names;
        self.attributeView.hidden = NO;
    } else {
        self.attributeView.hidden = YES;
    }
    
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    self.attributeView.backgroundColor = editing ? [UIColor colorWithHexString:@"f0f2f5"] : [UIColor clearColor];
    self.attributeButton.enabled = editing;
    self.dropIcon.hidden = !editing;
}
#pragma mark - Action

/**
 选择/取消选择按钮点响应方法
 */
- (IBAction)chackMarkAction:(UIButton *)sender {
    _carGoodsModel.select_goods = !_carGoodsModel.select_goods;
    [self setCarGoodsModel:_carGoodsModel];
    if ([_delegate respondsToSelector:@selector(carGoodsCellDidChangeSelectWithGoodsModel:inSection:)]) {
        [_delegate carGoodsCellDidChangeSelectWithGoodsModel:_carGoodsModel inSection:_section];
    }
}

/**
 商品数量按钮响应方法 点击后弹框输入数量,确定后请求价格,取消数量不变
 */
- (IBAction)goodsCountAction:(UIButton *)sender {
    
}

/**
 加号按钮响应方法,点击后商品数量+1
 */
- (IBAction)addAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.contentView];
    [GSCarRequestManager changeCarGoodsCountWithGoods_id:_carGoodsModel.rec_id count:[_carGoodsModel.goods_number integerValue] + 1 completed:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
        if ([responseObject[@"status"] integerValue] == 0) {
            _carGoodsModel.goods_number = [NSString stringWithFormat:@"%zi",[_carGoodsModel.goods_number integerValue] + 1];
            [weakSelf setCarGoodsModel:_carGoodsModel];
            [weakSelf carGoodsDidChangeCount];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }];
}

/**
 减号按钮响应方法,点击后商品数量-1
 */
- (IBAction)subtrackAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if ([_carGoodsModel.goods_number integerValue] - 1 != 0) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.contentView];
        [GSCarRequestManager changeCarGoodsCountWithGoods_id:_carGoodsModel.rec_id count:[_carGoodsModel.goods_number integerValue] - 1 completed:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            if ([responseObject[@"status"] integerValue] == 0) {
                _carGoodsModel.goods_number = [NSString stringWithFormat:@"%zi",[_carGoodsModel.goods_number integerValue] - 1];
                
                [weakSelf setCarGoodsModel:_carGoodsModel];
                [weakSelf carGoodsDidChangeCount];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }];
    }
}

/**
 规格点击方法（仅限编辑状态下）
 */
- (IBAction)attributeButtonClick:(UIButton *)sender {

    [self.specificationsManager showChooseSpecificationsNotChangeCountWithGoodsModel:self.carGoodsModel];    
    
    [self.specificationsManager.selectView.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.specificationsManager.selectView.commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction {
    [self.specificationsManager close];
}

- (void)commitAction {
    if (self.specificationsManager.selectView.specificationsTotalModel.selectSpecificationsDictionary.count != self.specificationsManager.selectView.specificationsTotalModel.attr_list.count) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择完整规格!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    } else {
        NSString *attribute_id = [[self.specificationsManager.selectView.specificationsTotalModel.contantGoodsArray firstObject] ID];
        
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
        [GSCarRequestManager changeCarGoodsAttributeWithAttribute_id:attribute_id rec_id:self.carGoodsModel.rec_id goods_id:self.carGoodsModel.goods_id goods_count:nil completed:^(BOOL success, NSString *message) {
            [MBProgressHUD hideHUDForView:nil animated:YES];
            if (success) {
                if ([weakSelf.delegate respondsToSelector:@selector(carGoodsDidChangeAttribute)]) {
                    [weakSelf.specificationsManager close];
                    [_delegate carGoodsDidChangeAttribute];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
        }];
    }
}


- (void)carGoodsDidChangeCount {
    [self changeButtonStatusWithCount:[self.carGoodsModel.goods_number integerValue]];
    
    
    if ([_delegate respondsToSelector:@selector(carGoodsDidChangeCount)]) {
        [_delegate carGoodsDidChangeCount];
    }
}

- (void)changeButtonStatusWithCount:(NSInteger)count {
    
    if (count == 200) {
        self.addButton.enabled = NO;
    } else {
        self.addButton.enabled = YES;
    }
    
    if (count == 1) {
        self.subtrackButton.enabled = NO;
    } else {
        self.subtrackButton.enabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
