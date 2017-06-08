//
//  GSMineHeaderView.h
//  guoshang
//
//  Created by Rechied on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPropertyView.h"
@class GSMineHeaderView;
@protocol GSMineHeaderViewDelegate <NSObject>

@optional
- (void)GSMineHeaderView:(GSMineHeaderView *)headerView didClickDetailButton:(UIButton *)button;
- (void)backClick;
@end

@class UserView;
@interface GSMineHeaderView : UIView
@property (weak, nonatomic) id <GSMineHeaderViewDelegate> delegate;
@property (strong, nonatomic) UIView *userInfoView; //用户信息
@property (strong, nonatomic) UIView *toolView;  //订单信息
@property (strong, nonatomic) GSPropertyView *propertyView;//金币，国币等
@property (strong, nonatomic) UserView *userView; //用户
@property (strong, nonatomic) UIImageView *bgView;
- (void)setBabyNumberWithAll:(NSString *)all new:(NSString *)new guanZhuNum:(NSString *)guanZhuNum;
- (instancetype)initWithHeight:(CGFloat)height;

@end

@interface UserView : UIView

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (copy, nonatomic) void(^clickBlock)(UIButton *clickButton);
- (void)setHeader:(NSString *)headerImageURLStr name:(NSString *)name num:(NSString *)num;


@end
