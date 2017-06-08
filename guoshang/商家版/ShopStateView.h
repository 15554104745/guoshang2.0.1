//
//  ShopStateView.h
//  WYP
//
//  Created by RY on 16/7/19.
//  Copyright © 2016年 RY. All rights reserved.
//上方选择

#import <UIKit/UIKit.h>
//代理
@protocol ShopStateViewDelegate <NSObject>
- (void)didSelectedItem:(int)index;
@end


@interface ShopStateView : UIView
@property (nonatomic, weak) id<ShopStateViewDelegate> delegate;
//字体大小
@property (nonatomic,assign) CGFloat titleSize;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) BOOL lineHidden;
@end

