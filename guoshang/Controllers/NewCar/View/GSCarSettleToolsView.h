//
//  GSCarSettleToolsView.h
//  guoshang
//
//  Created by Rechied on 2016/11/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GSCarSettleToolsViewDelegate <NSObject>

- (void)carSettleToolsSettleAction;
- (void)carDeleteToolsDeleteAction;
@end

@interface GSCarSettleToolsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *amountPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settleButton;

@property (assign, nonatomic) NSInteger selectGoodsCount;

@property (weak, nonatomic) IBOutlet UIButton *editSelectAllButton;

@property (weak, nonatomic) id <GSCarSettleToolsViewDelegate> delegate;


- (void)changeShowTypeWithIsEdit:(BOOL)isEdit;
@end
