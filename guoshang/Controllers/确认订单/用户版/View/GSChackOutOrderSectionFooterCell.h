//
//  GSChackOutOrderSectionFooterCell.h
//  guoshang
//
//  Created by Rechied on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderShopGoodsInfoModel.h"
#import "GSChackOutOrderShippingModel.h"

@protocol GSChackOutOrderSectionFooterCellDelegate <NSObject>

- (void)chackOutOrderSectionFooterDidChangeShipping;

@end

@interface GSChackOutOrderSectionFooterCell : UITableViewCell

@property (weak, nonatomic) id <GSChackOutOrderSectionFooterCellDelegate> delegate;
@property (strong, nonatomic) GSChackOutOrderShopGoodsInfoModel *shopGoodsInfoModel;

@end


@interface GSChackOutOrderShippingButton : UIButton

@property (strong, nonatomic) GSChackOutOrderShippingModel *shippingModel;

@end
