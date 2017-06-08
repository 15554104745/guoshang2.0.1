//
//  GSShopSortToolsView.h
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSShopSortToolButton.h"
@protocol GSShopSortToolsViewDelegate <NSObject>
- (void)shopSortToolsViewDidChangeSortWithSortParams:(NSString *)sortParams sortTypeStr:(NSString *)sortTypeStr;
- (void)shopSiftButtonDidClick:(GSShopSortToolButton *)siftButton sortType:(GSShopSortButtonSortType)sortType;
@end

@interface GSShopSortToolsView : UIView
@property (weak, nonatomic) GSShopSortToolButton *siftButton;
@property (weak, nonatomic) id <GSShopSortToolsViewDelegate> delegate;

- (instancetype)initWithDelegate:(id <GSShopSortToolsViewDelegate>)delegate;

@end
