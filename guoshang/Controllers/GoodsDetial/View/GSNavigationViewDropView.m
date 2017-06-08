//
//  GSNavigationViewDropView.m
//  guoshang
//
//  Created by Rechied on 2016/11/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNavigationViewDropView.h"


@interface GSNavigationViewDropViewItemView : UIView

@property (weak, nonatomic) UIImageView *iconView;
- (instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title showSep:(BOOL)showSep;

@end

@implementation GSNavigationViewDropViewItemView

- (instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title showSep:(BOOL)showSep {
    self = [super init];
    if (self) {
        [self setupIconViewWithIconName:iconName];
        [self setupTitleLabelWithTitle:title];
        if (showSep) {
            [self setupSepView];
        }
        
    }
    return self;
}

- (void)setupIconViewWithIconName:(NSString *)iconName {
    UIImage *iconImage = [UIImage imageNamed:iconName];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
    self.iconView = iconView;
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(iconImage.size);
    }];
}

- (void)setupTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = title;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.offset(-15);
    }];
}

- (void)setupSepView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_drowView_sep"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.right.offset(-15);
        make.height.offset(0.5f);
    }];
}
@end


@interface GSNavigationViewDropView ()
@property (assign, nonatomic) BOOL isShowContent;
@property (strong, nonatomic) UIImage *backgroundIamge;
@property (weak, nonatomic) UIView *contentView;

@property (assign, nonatomic) CGFloat y;
@end

@implementation GSNavigationViewDropView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.y = frame.origin.y;
        self.clipsToBounds = YES;
        [self creteBgImageView];
        [self createItemsView];
    }
    return self;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(Width - 20, 64.0f, 0, 0)];
    if (self) {
        self.y = self.frame.origin.y;
        self.clipsToBounds = YES;
        [self creteBgImageView];
        [self createItemsView];
    }
    return self;
}

- (UIImage *)backgroundIamge {
    if (!_backgroundIamge) {
        _backgroundIamge = [UIImage imageNamed:@"icon_navigation_drowView_bg"];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backgroundIamge.size.width, _backgroundIamge.size.height)];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return _backgroundIamge;
}

- (void)creteBgImageView {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:self.backgroundIamge];
    [self.contentView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_offset(0);
    }];
    
}

- (void)createItemsView {
    NSArray *titleArray = @[@"首页",@"分类",@"购物车",@"我的易购"];
    NSArray *iconArray = @[@"home",@"classfiy",@"car",@"mine"];
    GSNavigationViewDropViewItemView *lastItemView = nil;
    for (NSInteger i = 0; i < 4; i ++) {
        GSNavigationViewDropViewItemView *itemView = [[GSNavigationViewDropViewItemView alloc] initWithIcon:[NSString stringWithFormat:@"icon_navigation_drowView_%@",iconArray[i]] title:titleArray[i] showSep:i ==3 ? NO : YES];
        [self.contentView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                if (lastItemView) {
                    make.top.equalTo(lastItemView.mas_bottom);
                    make.height.equalTo(lastItemView.mas_height);
                } else {
                    make.top.offset(10);
                }
                if (i == 3) {
                    make.bottom.offset(0);
                }
            }];
        }];
        lastItemView = itemView;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i + 30;
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_offset(0);
        }];
    }
}

- (void)itemButtonClick:(UIButton *)button {
    [self dropViewHidden];
    if ([_delegate respondsToSelector:@selector(dropViewDidSelectIndex:)]) {
        [_delegate dropViewDidSelectIndex:(button.tag - 30)];
    }
}

- (void)dropViewShow {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(Width - 20 - _backgroundIamge.size.width, self.y, _backgroundIamge.size.width, _backgroundIamge.size.height);
        weakSelf.superview.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        weakSelf.isShowContent = YES;
        weakSelf.superview.userInteractionEnabled = YES;
    }];
    
}

- (void)dropViewHidden {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(Width - 20, self.y, 0, 0);
        weakSelf.superview.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        weakSelf.isShowContent = NO;
        weakSelf.superview.userInteractionEnabled = YES;
    }];
}

- (void)changeDropViewStatus {
    if (self.isShowContent) {
        [self dropViewHidden];
    } else {
        [self dropViewShow];
    }
}

-(void)changeDropViewStatusWithframe:(CGRect *)frame
{
    if (self.isShowContent) {
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(Width - 20, 0, 0, 0);
            weakSelf.superview.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
            weakSelf.isShowContent = NO;
            weakSelf.superview.userInteractionEnabled = YES;
        }];
        
    } else {
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(Width - 20 - _backgroundIamge.size.width, 0, _backgroundIamge.size.width, _backgroundIamge.size.height);
            weakSelf.superview.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
            weakSelf.isShowContent = YES;
            weakSelf.superview.userInteractionEnabled = YES;
        }];
        
    }
}


@end








