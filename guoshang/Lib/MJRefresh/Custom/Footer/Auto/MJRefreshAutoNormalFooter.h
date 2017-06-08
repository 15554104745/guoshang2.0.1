//
//  MJRefreshAutoNormalFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshAutoStateFooter.h"

@interface MJRefreshAutoNormalFooter : MJRefreshAutoStateFooter
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (strong, nonatomic) UIColor *nomoDataViewBGColor;
@end
