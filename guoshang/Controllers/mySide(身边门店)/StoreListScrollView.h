//
//  StoreListScrollView.h
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListScrollModel.h"
@interface StoreListScrollView : UIView

@property (nonatomic,strong)UIScrollView * mainScrollView;

@property (nonatomic,strong)UIPageControl * pageControl;


- (instancetype)initWithFrame:(CGRect)frame AndPicArray:(NSArray*)picArr;
@end
