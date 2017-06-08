//
//  BabyCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface BabyCell : UICollectionViewCell
@property(nonatomic,weak)UIButton *MYLeftBigBtn;
@property(nonatomic,weak)UIButton * MYLeftSmallBtn;
@property(nonatomic,weak)UIButton *  MYRightSmallBtn;
@property(nonatomic,weak)UIButton * MYRightSBtn;
@property(nonatomic,weak)UIButton *  MYRightSTBtn;
@property(nonatomic,weak)UIButton * MYRightSBTtn;
@property(nonatomic,weak)UIButton * MYRightBigBtn;
@property(nonatomic,strong)NSMutableArray * array;
@property(nonatomic,strong)UIViewController * popView;
@end
