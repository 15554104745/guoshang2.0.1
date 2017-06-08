//
//  GSChackOutOrderSectionFooterCell.m
//  guoshang
//
//  Created by Rechied on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderSectionFooterCell.h"
#import "GSChackOutOrderShippingModel.h"
#import "UIColor+HaxString.h"

#define Default_Red_Color [UIColor colorWithHexString:@"E73736"]

@interface GSChackOutOrderSectionFooterCell()
@property (weak, nonatomic) IBOutlet GSChackOutOrderShippingButton *deliveryButton;
@property (weak, nonatomic) IBOutlet GSChackOutOrderShippingButton *shippingButton;

@property (weak, nonatomic) IBOutlet UIView *guoBiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guoBiViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *guoBiNumberLabel;

@end

@implementation GSChackOutOrderSectionFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self settingBorderWithView:self.shippingButton];
    [self settingBorderWithView:self.deliveryButton];
    
    [self.shippingButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.deliveryButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)settingBorderWithView:(UIView *)view {
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [Default_Red_Color CGColor];
}

- (void)setShopGoodsInfoModel:(GSChackOutOrderShopGoodsInfoModel *)shopGoodsInfoModel {
    _shopGoodsInfoModel = shopGoodsInfoModel;
    
    self.deliveryButton.hidden = YES;
    self.shippingButton.hidden = YES;
    
    if (!shopGoodsInfoModel.selectShippingID || [shopGoodsInfoModel.selectShippingID isEqualToString:@""]) {
        if (shopGoodsInfoModel.shipping.count > 0) {
            shopGoodsInfoModel.selectShippingID = [shopGoodsInfoModel.shipping[0] shipping_id];
        }
    }
    
    if ([shopGoodsInfoModel.is_integral isEqualToString:@"Y"]) {
        if (self.guoBiViewHeight.constant != 30) {
            self.guoBiViewHeight.constant = 30;
        }
        self.guoBiNumberLabel.text = [NSString stringWithFormat:@"%.2f个",[shopGoodsInfoModel.total_integral floatValue]];
        self.guoBiView.hidden = NO;
    } else {
        if (self.guoBiViewHeight.constant != 0) {
            self.guoBiViewHeight.constant = 0;
        }
        self.guoBiNumberLabel.text = @"";
        self.guoBiView.hidden = YES;
    }
    
    
    
    [shopGoodsInfoModel.shipping enumerateObjectsUsingBlock:^(GSChackOutOrderShippingModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [self.deliveryButton setShippingModel:obj];
            self.deliveryButton.hidden = NO;
            if ([obj.shipping_id isEqualToString:shopGoodsInfoModel.selectShippingID]) {
                self.deliveryButton.selected = YES;
                self.shippingButton.selected = NO;
            }
        }
        if (idx == 1) {
            [self.shippingButton setShippingModel:obj];
            self.shippingButton.hidden = NO;
            if ([obj.shipping_id isEqualToString:shopGoodsInfoModel.selectShippingID]) {
                self.deliveryButton.selected = NO;
                self.shippingButton.selected = YES;
            }
        }
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"selected"]) {
        if ([[change objectForKey:@"new"] boolValue]) {
            
            if (object == self.deliveryButton) {
                self.deliveryButton.backgroundColor = Default_Red_Color;
                self.shippingButton.backgroundColor = [UIColor whiteColor];
                _shopGoodsInfoModel.selectShippingID = self.deliveryButton.shippingModel.shipping_id;
            } else {
                self.deliveryButton.backgroundColor = [UIColor whiteColor];
                self.shippingButton.backgroundColor = Default_Red_Color;
                _shopGoodsInfoModel.selectShippingID = self.shippingButton.shippingModel.shipping_id;
            }
            
            if ([_delegate respondsToSelector:@selector(chackOutOrderSectionFooterDidChangeShipping)]) {
                [_delegate chackOutOrderSectionFooterDidChangeShipping];
            }
        }
    }
}
- (IBAction)deliveryButtonClick:(GSChackOutOrderShippingButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.shippingButton.selected = NO;
        
    }
}

- (IBAction)shippingButtonClick:(GSChackOutOrderShippingButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.deliveryButton.selected = NO;
    }
}

- (void)dealloc {
    [self.shippingButton removeObserver:self forKeyPath:@"selected"];
    [self.deliveryButton removeObserver:self forKeyPath:@"selected"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation GSChackOutOrderShippingButton

- (void)setShippingModel:(GSChackOutOrderShippingModel *)shippingModel {
    _shippingModel = shippingModel;
    [self setTitle:shippingModel.shipping_name forState:UIControlStateNormal];
    [self setTitle:shippingModel.shipping_name forState:UIControlStateSelected];
    
}

@end
