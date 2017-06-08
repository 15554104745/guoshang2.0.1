//
//  HomeOtherHeaderCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"
@interface HomeOtherHeaderCell : UICollectionReusableView<ImagesScrollViewDelegate>

@property(nonatomic,weak)UIView * View;
@property(nonatomic,strong)NSMutableArray * bannerArray;
@property(nonatomic,strong)UIViewController * popView;
@end
