//
//  GSHomeCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSHomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "GSHomeGoodsView.h"
#import "GSHomeCellGoodsModel.h"
#import "GoodsViewController.h"
#import "MyGroupViewController.h"
#import "UIView+UIViewController.h"
#import "GSNewShopBaseViewController.h"

@interface GSHomeCollectionViewCell();

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIImageView *topTitleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation GSHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setCellModel:(GSHomeCollectionCellModel *)cellModel {
    _cellModel = cellModel;
    
    self.homeGoodsViewHeight.constant = (Width - 30)/3 + 55;
    [self.cellTitleView addSubview:self.topTitleImageView];
    [_topTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cellTitleView.mas_centerX);
        make.centerY.equalTo(self.cellTitleView.mas_centerY);
    }];
    _topTitleImageView.image = [UIImage imageNamed:cellModel.topTitleImageName];
    if (cellModel.topModel.top && [cellModel.topModel.top containsString:@"http://"]) {
        [self.topADView sd_setImageWithURL:[NSURL URLWithString:cellModel.topModel.top]];
        NSLayoutConstraint *heightConstraint = self.topADViewHeight;
        heightConstraint.constant = Width * 135 / 720;
        self.topADViewHeight = heightConstraint;
    } else {
        NSLayoutConstraint *heightConstraint = self.topADViewHeight;
        heightConstraint.constant = 0;
        self.topADViewHeight = heightConstraint;
    }
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.botModel.ad_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if ([_delegate respondsToSelector:@selector(homeCellDidFinishLoadImageWithIndexPath:imageSize:)]) {
            [_delegate homeCellDidFinishLoadImageWithIndexPath:_indexPath imageSize:image.size];
        }
    }];
    [[self.homeGoodsView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    
    __block UIView *lastHomeGoodsView = nil;
    for (int i = 0; i < 3; i ++) {
        if (i < cellModel.botModel.goods_list.count) {
            
            GSHomeCellGoodsModel *goodsModel = cellModel.botModel.goods_list[i];
            GSHomeGoodsView *homeGoodsView = [[GSHomeGoodsView alloc] initWithGoodsModel:goodsModel labStr:cellModel.topModel.label labColor:cellModel.topModel.color];
            homeGoodsView.pushClick = ^(UIViewController *viewController) {
                if ([_delegate respondsToSelector:@selector(homeCellWillPushViewController:)]) {
                    [_delegate homeCellWillPushViewController:viewController];
                }
                
            };
            [self.homeGoodsView addSubview:homeGoodsView];
            [homeGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_offset(0);
                if (!lastHomeGoodsView) {
                    make.left.offset(10);
                } else {
                    make.left.equalTo(lastHomeGoodsView.mas_right).offset(5);
                    make.width.equalTo(lastHomeGoodsView.mas_width);
                }
                
                if (i == 2) {
                    make.right.offset(-10);
                }
                lastHomeGoodsView = homeGoodsView;
                
            }];
        } else {
            
            UIView *clearView = [[UIView alloc] init];
            [self.homeGoodsView addSubview:clearView];
            [clearView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_offset(0);
                if (!lastHomeGoodsView) {
                    make.left.offset(10);
                } else {
                    make.left.equalTo(lastHomeGoodsView.mas_right).offset(5);
                    make.width.equalTo(lastHomeGoodsView.mas_width);
                }
                
                if (i == 2) {
                    make.right.offset(-10);
                }
                lastHomeGoodsView = clearView;
            }];
        }
    }
    
}

- (IBAction)bigImageButtonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(homeCellWillPushViewController:)]) {
        GSNewShopBaseViewController *shopBase = [[GSNewShopBaseViewController alloc] init];
        shopBase.hidesBottomBarWhenPushed = YES;
        shopBase.cat_id = _cellModel.botModel.cat_id;
        [_delegate homeCellWillPushViewController:shopBase];
    }
}

- (void)setTopADViewHeight:(NSLayoutConstraint *)topADViewHeight {
    _topADViewHeight = topADViewHeight;
    if (topADViewHeight.constant > 0) {
        self.lineHeight.constant = 10;
        [self.topADView addGestureRecognizer:self.tapGesture];
        self.topADView.userInteractionEnabled = YES;
    } else {
        self.lineHeight.constant = 0;
        [self.topADView removeGestureRecognizer:self.tapGesture];
        self.topADView.userInteractionEnabled = NO;
    }
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topADClick)];
    }
    return _tapGesture;
}

//团购
- (void)topADClick {
    if ([_cellModel.topTitleImageName isEqualToString:@"jiatingriyong"]) {
        if ([_delegate respondsToSelector:@selector(homeCellWillPushViewController:)]) {
//            MyGroupViewController *mygrouop = [[MyGroupViewController alloc]init];
//            mygrouop.hidesBottomBarWhenPushed = YES;
//            [_delegate homeCellWillPushViewController:mygrouop];
        }
    }
}


- (UIImageView *)topTitleImageView {
    if (!_topTitleImageView) {
        _topTitleImageView = [[UIImageView alloc] init];
    }
    return _topTitleImageView;
}


@end
