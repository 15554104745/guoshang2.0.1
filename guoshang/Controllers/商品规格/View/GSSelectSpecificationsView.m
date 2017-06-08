//
//  GSSelectSpecificationsView.m
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSelectSpecificationsView.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "GSSingleSpecificationsView.h"

@interface GSSelectSpecificationsView ()<GSSingleSpecificationsViewDelegate>

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UILabel *goodsNumberLabel;
@property (nonatomic, strong) UILabel *sep;

@property (nonatomic, strong) UIScrollView *mainscrollview;



@property (nonatomic, strong) NSMutableDictionary <__kindof NSString *, GSSingleSpecificationsView *> *specificationsViewDic;
@end

@implementation GSSelectSpecificationsView

/**
 商品缩略图
 */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 100, 100)];
        _goodsImageView.image = [UIImage imageNamed:@"1.jpg"];
        _goodsImageView.layer.cornerRadius = 4;
        _goodsImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _goodsImageView.layer.borderWidth = 5;
        [_goodsImageView.layer setMasksToBounds:YES];
    }
    return _goodsImageView;
}


/**
 价格标签
 */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImageView.frame.origin.x+_goodsImageView.frame.size.width+20, 10, self.frame.size.width-(_goodsImageView.frame.origin.x+_goodsImageView.frame.size.width+40+40), 20)];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:15];
    }
    return _priceLabel;
}


/**
 关闭按钮
 */
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.frame.size.width-40, 10,30, 30);
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    return _closeButton;
    
}

/**
 库存标签
 */
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageView.frame.origin.x + self.goodsImageView.frame.size.width + 20, self.priceLabel.frame.origin.y + self.priceLabel.frame.size.height, self.frame.size.width - (self.goodsImageView.frame.origin.x + self.goodsImageView.frame.size.width + 40 + 40), 20)];
        _stockLabel.textColor = [UIColor blackColor];
        _stockLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _stockLabel;
}

/**
 分割线
 */
- (UILabel *)sep {
    if (!_sep) {
        _sep = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsImageView.frame.origin.y + self.goodsImageView.frame.size.height + 20, self.frame.size.width, 0.5)];
        _sep.backgroundColor = [UIColor lightGrayColor];
    }
    return _sep;
}

/**
 确定按钮
 */
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton= [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(0, self.frame.size.height - 44,self.frame.size.width, 44);
        [_commitButton setBackgroundColor:[UIColor colorWithHexString:@"f23030"]];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _commitButton;
}

/**
 规格内容滑动视图
 */
- (UIScrollView *)mainscrollview {
    if (!_mainscrollview) {
        _mainscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sep.frame.origin.y + self.sep.frame.size.height, self.frame.size.width, self.commitButton.frame.origin.y - (self.sep.frame.origin.y + self.sep.frame.size.height))];
        _mainscrollview.showsHorizontalScrollIndicator = NO;
        _mainscrollview.showsVerticalScrollIndicator = NO;
    }
    return _mainscrollview;
}

- (UILabel *)goodsNumberLabel {
    if (!_goodsNumberLabel) {
        _goodsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageView.frame.origin.x+self.goodsImageView.frame.size.width+20, self.stockLabel.frame.origin.y+self.stockLabel.frame.size.height, Width - (self.goodsImageView.frame.origin.x+self.goodsImageView.frame.size.width+40+40), 40)];
        _goodsNumberLabel.textColor = [UIColor colorWithHexString:@"a8a9b0"];
        _goodsNumberLabel.font = [UIFont systemFontOfSize:13];
    }
    return _goodsNumberLabel;
}

- (NSMutableDictionary *)specificationsViewDic {
    if (!_specificationsViewDic) {
        _specificationsViewDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _specificationsViewDic;
}

- (instancetype)initWithGoodsModel:(id)goodsModel hasSpecifications:(BOOL)hasSpecifications {
    self = [super initWithFrame:CGRectMake(0, Height + 20, Width, Height - 200)];
    if (self) {
        [self setupUI];
        if (hasSpecifications) {
            [self getGoodsSpecificationsWithGoodsModel:goodsModel];
        } else {
            self.countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50.0f)];
            [self.mainscrollview addSubview:self.countView];
        }
        [self contentGoodsAttributeWithGoodsModel:goodsModel];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.goodsImageView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.stockLabel];
    [self addSubview:self.goodsNumberLabel];
    [self addSubview:self.sep];
    [self addSubview:self.commitButton];
    [self addSubview:self.mainscrollview];
}

- (void)contentGoodsAttributeWithGoodsModel:(id)goodsModel {
    NSDictionary *goods_attrbuite = [goodsModel mj_keyValues];
    NSString *goods_thumb = goods_attrbuite[@"thumb"] ? goods_attrbuite[@"thumb"] : goods_attrbuite[@"goods_thumb"] ? goods_attrbuite[@"goods_thumb"] : goods_attrbuite[@"goods_img"];
    NSString *goods_stoke = goods_attrbuite[@"store_number"] ? goods_attrbuite[@"store_number"] : goods_attrbuite[@"goods_number"];
    NSString *goods_id = goods_attrbuite[@"ID"] ? goods_attrbuite[@"ID"] : goods_attrbuite[@"goods_id"] ? goods_attrbuite[@"goods_id"] : goods_attrbuite[@"id"];
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"商品编号：%@",goods_id];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods_thumb] placeholderImage:Goods_Pleaceholder_Image];
    self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",goods_stoke];
    NSString *goodsPrice = goods_attrbuite[@"shop_price"] ? goods_attrbuite[@"shop_price"] : goods_attrbuite[@"goods_price"];
    
    //如果是国币商品更改价格显示状态
    if ([goods_attrbuite[@"is_exchange"] isEqualToString:@"1"]) {
        UIImageView *guobiImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guobi"]];
        guobiImage.frame = CGRectMake(_goodsImageView.endPointX + 20, 10, 20, 20);
        [self addSubview:guobiImage];
       self.priceLabel.frame = CGRectMake(_goodsImageView.endPointX+20 + 25, 10, self.frame.size.width-(_goodsImageView.frame.origin.x+_goodsImageView.frame.size.width+40+40), 20);
        self.priceLabel.text = [NSString stringWithFormat:@"%@个",goodsPrice];
        
    }else{
        self.priceLabel.text = [goodsPrice containsString:@"￥"] ? goodsPrice : [NSString stringWithFormat:@"￥%@",goodsPrice];
    }

}

- (void)contentGoodsAttrbuteWithSpecificationsGoodsModel:(GSSpecificationsGoodsModel *)specificationsGoodsModel {
    self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",specificationsGoodsModel.goods_number];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",specificationsGoodsModel.shop_price];
    
}

- (void)getGoodsSpecificationsWithGoodsModel:(id)goodsModel {
    NSDictionary *goods_attrbuite = [goodsModel mj_keyValues];
    NSString *goods_id = goods_attrbuite[@"ID"] ? goods_attrbuite[@"ID"] : goods_attrbuite[@"goods_id"] ? goods_attrbuite[@"goods_id"] : goods_attrbuite[@"id"];
    [self getGoodsSpecificationsWithGoods_id:goods_id];
}

- (void)getGoodsSpecificationsWithGoods_id:(NSString *)goods_id {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Goods/attribute") parameters:[@{@"goods_id":goods_id} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        weakSelf.specificationsTotalModel = [GSGoodsSpecificationsTotalModel mj_objectWithKeyValues:responseObject[@"result"]];
    }];
}

- (void)setSpecificationsTotalModel:(GSGoodsSpecificationsTotalModel *)specificationsTotalModel {
    _specificationsTotalModel = specificationsTotalModel;
    __weak typeof(self) weakSelf = self;
    __block GSSingleSpecificationsView *lastSingleView = nil;
    [specificationsTotalModel.attr_list enumerateObjectsUsingBlock:^(__kindof GSSpecificationsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GSSingleSpecificationsView *singleView = [[GSSingleSpecificationsView alloc] initWithSpecificationsModel:obj];
        singleView.delegate = self;
        singleView.frame = CGRectMake(0, lastSingleView ? CGRectGetMaxY(lastSingleView.frame) : 0, weakSelf.frame.size.width, singleView.contentHeight);
        [weakSelf.mainscrollview addSubview:singleView];
        lastSingleView = singleView;
        [weakSelf.specificationsViewDic setObject:singleView forKey:obj.f_id];
    }];
    if (self.notShowChangCount) {
        [self.mainscrollview setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(lastSingleView.frame))];
    } else {
        self.countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastSingleView.frame), self.frame.size.width, 50.0f)];
        [self.mainscrollview addSubview:self.countView];
        [self.mainscrollview setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.countView.frame))];
    }
    
}

- (void)singleSpecificationsViewDidSelectSpecificationsWithFid:(NSString *)fid attrbute_id:(NSString *)attrbute_id {
    
    [self.specificationsTotalModel addSelectSpecificationsWithF_id:fid attrbute_id:attrbute_id];
    [self.specificationsTotalModel.attr_list enumerateObjectsUsingBlock:^(__kindof GSSpecificationsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.f_id isEqualToString:fid]) {
            GSSingleSpecificationsView * specificationsView = [self.specificationsViewDic objectForKey:obj.f_id];
            
            [specificationsView setCanUseSpecifications:[self.specificationsTotalModel canUseSpecificationsWithFid:obj.f_id]];
        }
    }];
    if (self.specificationsTotalModel.selectSpecificationsDictionary.count == self.specificationsTotalModel.attr_list.count) {
        [self contentGoodsAttrbuteWithSpecificationsGoodsModel:[self.specificationsTotalModel.contantGoodsArray firstObject]];
    }
}

- (void)singleSpecificationsViewDidDeSelectSpecificationsWithFid:(NSString *)fid {
    [self.specificationsTotalModel deleteSpecificationsWithF_id:fid];
    [self.specificationsTotalModel.attr_list enumerateObjectsUsingBlock:^(__kindof GSSpecificationsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //if ([obj.f_id isEqualToString:fid]) {
            GSSingleSpecificationsView * specificationsView = [self.specificationsViewDic objectForKey:obj.f_id];
            
            [specificationsView setCanUseSpecifications:[self.specificationsTotalModel canUseSpecificationsWithFid:obj.f_id]];
        //}
    }];
}

@end
