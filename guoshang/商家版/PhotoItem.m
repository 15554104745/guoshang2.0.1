//
//  PhotoItem.m
//  PhotoView
//
//  Created by 赵彦飞 on 16/3/8.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem


- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        self.userInteractionEnabled = YES;
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(kItemW -20, 0, 20, 20)];
        [_deleteButton setImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
        
    }

    return self;
}

- (void)setIndex:(NSInteger)index {

    _deleteButton.tag = 800 +index;
}


- (void)buttonAction {

    

}




@end
