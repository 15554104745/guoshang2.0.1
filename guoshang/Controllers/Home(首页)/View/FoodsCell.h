//
//  FoodsCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface FoodsCell : UICollectionViewCell

@property(nonatomic,weak)UIButton *SYLeftBigBtn;
@property(nonatomic,weak)UIButton * SYLeftSmallBtn;
@property(nonatomic,weak)UIButton *  SYLeftSTBtn;
@property(nonatomic,weak)UIButton * SYRigntSBtn;
@property(nonatomic,weak)UIButton *  SYRightSTBtn;
@property(nonatomic,weak)UIButton * SYRightBigBtn;
@property(nonatomic,strong)NSMutableArray * array;
@property(nonatomic,strong)UIViewController * popView;
@end
