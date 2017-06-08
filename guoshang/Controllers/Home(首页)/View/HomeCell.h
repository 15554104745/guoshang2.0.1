//
//  HomeCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView * titleView;//头广告图
@property(nonatomic,strong) NSDictionary * myAdDic;
@property(nonatomic,strong) UIView * recommedView;
@property(nonatomic,copy) void(^headerImageTouchBlock)(NSString *cat_id);
@property(nonatomic,strong)  NSArray * myArray;
@property (nonatomic,copy)NSString *color;

@end
