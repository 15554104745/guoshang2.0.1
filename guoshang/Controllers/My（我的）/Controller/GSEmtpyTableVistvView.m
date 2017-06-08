//
//  GSEmtpyTableVistvView.m
//  guoshang
//
//  Created by JinLian on 16/9/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSEmtpyTableVistvView.h"

@interface GSEmtpyTableVistvView () {
    UIImageView *imageView;
    UILabel *titleLab;
}

@end

@implementation GSEmtpyTableVistvView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = MyColor;
        [self createSubView];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLab.text = title.length>0 ? title : @"暂无相关信息";

}

- (void)createSubView {
    
    NSString *imageStr = @"dingdanooo";
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2+10, (self.frame.size.height-100*432/336)/2-50, 100, 100*432/336)];
    imageView.image = [UIImage imageNamed:imageStr];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height, self.frame.size.width, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLab];
    
}


@end
