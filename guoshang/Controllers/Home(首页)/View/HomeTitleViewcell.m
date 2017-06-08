//
//  HomeTitleViewcell.m
//  home
//
//  Created by 宗丽娜 on 16/2/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeTitleViewcell.h"

@implementation HomeTitleViewcell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       
        
            
            //1.子控件View
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width -215)/2, 5,   215  , 15)];
        
       
        
        _imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _imageIcon = view;
        _imageIcon.userInteractionEnabled = YES;
        [self addSubview:_imageIcon];
        
    
      
        
    }
    return self;
}
-(void)setString:(NSString *)string{
    _string = string;
    _imageIcon.image = [UIImage imageNamed:string];
    
    
}

@end
