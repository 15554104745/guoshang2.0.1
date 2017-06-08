//
//  DailyCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface DailyCell : UICollectionViewCell


@property(nonatomic,weak)UIImageView * RYIconView;
@property(nonatomic,weak)UIButton *RYLeftBigBtn;
@property(nonatomic,weak)UIButton * RYLeftSmallBtn;
@property(nonatomic,weak)UIButton *  RYLeftSTBtn;
@property(nonatomic,weak)UIButton * RYRigntSBtn;
@property(nonatomic,weak)UIButton *  RYRightSTBtn;
@property(nonatomic,weak)UIButton * RYRightBigBtn;
@property(nonatomic,strong)NSMutableArray  * array;
@property(nonatomic,strong)UIViewController * popView;
@end
