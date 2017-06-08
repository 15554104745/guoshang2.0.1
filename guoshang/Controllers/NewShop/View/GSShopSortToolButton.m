//
//  GSShopSortToolButton.m
//  guoshang
//
//  Created by Rechied on 2016/11/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopSortToolButton.h"
#import "UIColor+HaxString.h"

@interface GSShopSortToolButton()
@property (weak, nonatomic) UIButton *sortButton;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *iconImageView;
@end

@implementation GSShopSortToolButton

+ (instancetype)buttonWithTitle:(NSString *)title sortType:(GSShopSortButtonSortType)sortType sortParamsString:(NSString *)sortParamsString {
    GSShopSortToolButton *toolsButton = [[super alloc] init];
    if (toolsButton) {
        [toolsButton setupTitleAndIconWithTitle:title];
        [toolsButton setupButton];
        toolsButton.sortType = sortType;
        if (sortParamsString) {
            [toolsButton setSortParamsString:sortParamsString];
        }
    }
    return toolsButton;
}

- (void)setSortParamsString:(NSString *)sortParamsString {
    _sortParams = sortParamsString;
}

- (void)setupTitleAndIconWithTitle:(NSString *)title {
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [view addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(0);
        make.left.equalTo(titleLabel.mas_right).offset(5);
    }];
}

- (void)setupButton {
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (UIImage *)getIconImageWithSortType:(GSShopSortButtonSortType)sortType {
    switch (sortType) {
        case GSShopSortButtonSortTypeUp:
            return [UIImage imageNamed:@"icon_shop_triangle_up"];
            break;
            
        case GSShopSortButtonSortTypeDown:
            return [UIImage imageNamed:@"icon_shop_triangle_down"];
            break;
            
        case GSShopSortButtonSortTypeNormal:
            return [UIImage imageNamed:@"icon_shop_triangle_double"];
            break;
            
        case GSShopSortButtonSortTypeSiftNormal:
            return [UIImage imageNamed:@"icon_shop_sift"];
            break;
            
        case GSShopSortButtonSortTypeSiftSelected:
            return [UIImage imageNamed:@"icon_shop_sift_highlight"];
            break;
            
        default:
            break;
    }
}

- (UIColor *)getTitleColorWithSortType:(GSShopSortButtonSortType)sortType {
    switch (sortType) {
        case GSShopSortButtonSortTypeUp:
            return [UIColor colorWithHexString:@"f23030"];
            break;
            
        case GSShopSortButtonSortTypeDown:
            return [UIColor colorWithHexString:@"f23030"];
            break;
            
        case GSShopSortButtonSortTypeNormal:
            return [UIColor colorWithHexString:@"3d3d3d"];
            break;
            
        case GSShopSortButtonSortTypeSiftNormal:
            return [UIColor colorWithHexString:@"3d3d3d"];
            break;
            
        case GSShopSortButtonSortTypeSiftSelected:
            return [UIColor colorWithHexString:@"f23030"];
            break;
            
        default:
            break;
    }
}

- (NSString *)sortTypeStr {
    switch (self.sortType) {
        case GSShopSortButtonSortTypeUp:
            return @"ASC";
            break;
            
        case GSShopSortButtonSortTypeDown:
            return @"DESC";
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)setSortType:(GSShopSortButtonSortType)sortType {
    _sortType = sortType;
    [self changeSortType:sortType];
    
    if (sortType == GSShopSortButtonSortTypeSiftSelected || sortType == GSShopSortButtonSortTypeSiftNormal) {
        if ([_delegate respondsToSelector:@selector(shopSortSiftButtonDidClickWithSortType:)]) {
            [_delegate shopSortSiftButtonDidClickWithSortType:self.sortType];
        }
    } else if (sortType != GSShopSortButtonSortTypeNormal) {
        if ([_delegate respondsToSelector:@selector(shopSortButton:didSelectWithSortParams:sortTypeStr:)]) {
            [_delegate shopSortButton:self didSelectWithSortParams:self.sortParams sortTypeStr:self.sortTypeStr];
        }
    }
}

- (void)buttonClick {
    
    switch (self.sortType) {
        case GSShopSortButtonSortTypeUp:
            self.sortType = GSShopSortButtonSortTypeDown;
            break;
            
        case GSShopSortButtonSortTypeDown:
            self.sortType = GSShopSortButtonSortTypeUp;
            break;
            
        case GSShopSortButtonSortTypeNormal:
            self.sortType = GSShopSortButtonSortTypeDown;
            break;
            
        case GSShopSortButtonSortTypeSiftNormal:
            self.sortType = GSShopSortButtonSortTypeSiftSelected;
            break;
            
        case GSShopSortButtonSortTypeSiftSelected:
            self.sortType = GSShopSortButtonSortTypeSiftSelected;
        default:
            break;
    }
}

- (void)changeSortType:(GSShopSortButtonSortType)sortType {
    self.titleLabel.textColor = [self getTitleColorWithSortType:sortType];
    self.iconImageView.image = [self getIconImageWithSortType:sortType];
}

@end

