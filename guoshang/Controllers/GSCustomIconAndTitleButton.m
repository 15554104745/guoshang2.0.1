//
//  GSCustomIconAndTitleButton.m
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomIconAndTitleButton.h"

@implementation GSCustomIconAndTitleButton

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont {
    self = [super init];
    if (self) {
        
        UILabel *botLabel = [[UILabel alloc] init];
        botLabel.textColor = color;
        botLabel.font = titleFont;
        botLabel.text = title;
        botLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:botLabel];
        [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
        }];
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.bottom.equalTo(botLabel.mas_top).offset(0);
        }];
        
        UIImageView *imageView =[[UIImageView alloc] initWithImage:icon];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
        }];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
    }];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
