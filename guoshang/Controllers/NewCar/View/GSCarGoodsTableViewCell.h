//
//  GSCarGoodsTableViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSCarGoodsModel.h"
#import "GSSpecificationsManager.h"

@protocol GSCarGoodsTableViewCellDelegate <NSObject>

- (void)carGoodsCellDidChangeSelectWithGoodsModel:(GSCarGoodsModel *)goodsModel inSection:(NSInteger)section;

- (void)carGoodsDidChangeCount;

- (void)carGoodsDidChangeAttribute;
@end

@interface GSCarGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chackMarkButton;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *decimalLabel;
@property (weak, nonatomic) IBOutlet UILabel *attributeLabel;
@property (weak, nonatomic) IBOutlet UIView *attributeView;
@property (weak, nonatomic) IBOutlet UIImageView *dropIcon;
@property (weak, nonatomic) IBOutlet UIButton *attributeButton;

@property (weak, nonatomic) IBOutlet UIButton *subtrackButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *goodsCountButton;

@property (assign, nonatomic) NSInteger section;

@property (weak, nonatomic) id<GSCarGoodsTableViewCellDelegate> delegate;
@property (strong, nonatomic) GSCarGoodsModel *carGoodsModel;

@property (strong, nonatomic) GSSpecificationsManager *specificationsManager;
@end
