//
//  HomeFooterOther.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeFooterOther.h"

@implementation HomeFooterOther
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //1.子控件View
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        
        _imageIcon = view;
        [self addSubview:_imageIcon];
        
        
    }
    return self;
}

@end
