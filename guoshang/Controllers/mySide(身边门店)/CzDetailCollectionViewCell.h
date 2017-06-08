//
//  CzDetailCollectionViewCell.h
//  guoshang
//
//  Created by 陈赞 on 16/10/14.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface CzDetailCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)LNButton * ImgeBtn;
@property(nonatomic,strong)LNLabel * titleLab;
@property(nonatomic,strong)LNLabel * markLab;
@property(nonatomic,strong)LNLabel * priceLab;
@property(nonatomic,strong)HomeModel * dataModel;
@property(nonatomic,strong)NSString * type;
@end
