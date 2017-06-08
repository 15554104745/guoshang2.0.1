//
//  GSMyGSCustomButtonView.m
//  guoshang
//
//  Created by Rechied on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyGSCustomButtonView.h"

@interface GSMyGSCustomButtonView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *label;

@end

@implementation GSMyGSCustomButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTarget:(id)target action:(SEL)action imageName:(NSString *)imageName title:(NSString *)title tag:(NSInteger)tag{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor colorWithHexString:@"242424"];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        self.label = label;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.offset(-10);
        }];
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.bottom.equalTo(label.mas_top).offset(0);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        self.imageView = imageView;
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"re_icon_bg_property"] forState:UIControlStateHighlighted];
        button.tag = tag;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0);
        }];
        
    }
    return self;
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}
-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    self.label.text = titleName;
}
@end
