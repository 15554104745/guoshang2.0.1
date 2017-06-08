//
//  GSPropertyView.h
//  guoshang
//
//  Created by Rechied on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPropertyView : UIView

@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *midView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) LNLabel *jinBiLab;
@property (strong, nonatomic) LNLabel *guoBiLab;
@property (strong, nonatomic) LNLabel *chuZhiKaLab;

@property (strong, nonatomic) UIImageView *bgImageView;


@property (copy, nonatomic) void(^propertyButtonClickBlock)(NSInteger index);
/*
 @param goldNum      (金币数量 NSString类型)
 @param guobiNum     (国币数量 NSString类型)
 @param topupCardNum (储值卡数量 NSString类型)
 */
- (void)setGoldNum:(NSString *)goldNum guobiNum:(NSString *)guobiNum topupCardNum:(NSString *)topupCardNum;

@end
