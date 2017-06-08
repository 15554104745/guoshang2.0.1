//
//  ElectricalCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface ElectricalCell : UICollectionViewCell

@property(nonatomic,weak)UIImageView * JYDQIconView;
@property(nonatomic,weak)UIButton *DQLeftBigBtn;
@property(nonatomic,weak)UIButton * DQleftSmallBtn;
@property(nonatomic,weak)UIButton *  DQleftSmallTwoIconBtn;
@property(nonatomic,weak)UIButton * DQrightBigBtn;
@property(nonatomic,weak)UIButton *  DQrightSmallBtn;
@property(nonatomic,weak)UIButton * DQrightSmallTwoBtn;
@property(nonatomic,strong)NSMutableArray * array;
@property(nonatomic,strong)UIViewController * popView;
@end
