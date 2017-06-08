//
//  GSCarShopSectionTableViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSCarShopModel;

@protocol GSCarShopSectionTableViewCellDelegate <NSObject>

- (void)carShopSectionCellDidChangeSelectWithGoodsModel:(GSCarShopModel *)shopModel inSection:(NSInteger)section;

@end

@interface GSCarShopSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chackMarkButton;

@property (weak, nonatomic) id<GSCarShopSectionTableViewCellDelegate> delegate;

@property (assign, nonatomic) NSInteger section;
@property (strong, nonatomic) GSCarShopModel *shopModel;
@end
