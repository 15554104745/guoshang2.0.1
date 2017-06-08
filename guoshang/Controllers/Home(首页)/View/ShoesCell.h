//
//  ShoesCell.h
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface ShoesCell : UICollectionViewCell
////鞋包钟表
@property(nonatomic,weak)UIButton *XZLeftSbtn;
@property(nonatomic,weak)UIButton *XZLeftBigbtn;
@property(nonatomic,weak)UIButton *XZRightBbtn;
@property(nonatomic,weak)UIButton *XZRigntSbtn;
@property(nonatomic,strong)NSMutableArray * array;
@property(nonatomic,strong)UIViewController * popView;
@end
