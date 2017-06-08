//
//  MJRefreshAutoNormalFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshAutoNormalFooter.h"

@interface MJRefreshAutoNormalFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UIView *nomoreDataView;
@end

@implementation MJRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    self.mj_h = 60.0f;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (UIView *)nomoreDataView {
    if (!_nomoreDataView) {
        _nomoreDataView = [[UIView alloc] init];
        _nomoreDataView.backgroundColor = self.nomoDataViewBGColor ? self.nomoDataViewBGColor : [UIColor whiteColor];
//        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meiyougengduole"]];
//        [_nomoreDataView addSubview:bgImageView];
//        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_nomoreDataView.mas_centerX);
//            make.centerY.equalTo(_nomoreDataView.mas_centerY);
//            make.size.sizeOffset(bgImageView.image.size);
//        }];
        
        LNLabel *label = [LNLabel addLabelWithTitle:@"亲,已经没有更多了哦~" TitleColor:[UIColor grayColor] Font:12 BackGroundColor:[UIColor clearColor]];
        //[bgImageView addSubview:label];
        [_nomoreDataView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(bgImageView.mas_centerY).offset(-5);
//            make.centerX.equalTo(bgImageView.mas_centerX);
            make.centerX.offset(0);
            make.centerY.offset(0);
        }];
    }
    return _nomoreDataView;
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.mj_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(MJRefreshState)state
{
    
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
    
    if (state == MJRefreshStateNoMoreData) {
        
        [self addSubview:self.nomoreDataView];
        [_nomoreDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0);
        }];
    } else {
        //self.mj_h = MJRefreshFooterHeight;
        [self.nomoreDataView removeFromSuperview];
    }
    
}

@end
