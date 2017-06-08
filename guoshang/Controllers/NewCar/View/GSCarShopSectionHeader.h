//
//  GSCarShopSectionHeader.h
//  guoshang
//
//  Created by Rechied on 2016/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSCarShopModel;

@protocol GSCarShopSectionHeaderDelegate <NSObject>

- (void)carShopSectionCellDidChangeSelectWithGoodsModel:(GSCarShopModel *)shopModel inSection:(NSInteger)section;

@end

@interface GSCarShopSectionHeader : UITableViewHeaderFooterView

@property (weak, nonatomic)  UILabel *shopTitleLabel;
@property (weak, nonatomic)  UIButton *chackMarkButton;

@property (weak, nonatomic) id<GSCarShopSectionHeaderDelegate> delegate;

@property (assign, nonatomic) NSInteger section;
@property (strong, nonatomic) GSCarShopModel *shopModel;


@end
