//
//  GSSpecificationsManager.h
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSelectSpecificationsView.h"

@interface GSSpecificationsManager : NSObject

@property (strong, nonatomic) GSSelectSpecificationsView *selectView;

- (void)showChooseSpecificationsWithCurrentView:(UIView *)currentView goodsModel:(id)goodsModel showFcousAnimaiton:(BOOL)showFcousAnimation;

- (void)showAddToCarViewWithCurrentView:(UIView *)currentView goodsModel:(id)goodsModel;

- (void)showChooseSpecificationsNotChangeCountWithGoodsModel:(id)goodsModel;
- (void)open;
- (void)close;
@end
