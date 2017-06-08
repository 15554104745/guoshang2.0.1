//
//  HomeFooterCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeFooterCell : UICollectionReusableView
@property(nonatomic,weak)UIImageView *imageIcon;
@property(nonatomic,strong)HomeModel * model;
@property(nonatomic,strong)UIViewController * popView;
@end
