//
//  HomeOtherTitleViewcell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeOtherTitleViewcell.h"

@implementation HomeOtherTitleViewcell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
  
        _adverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, Width, 65)];
        _adverImage.userInteractionEnabled = YES;
        _adverImage.contentMode = UIViewContentModeScaleToFill;
        _adverImage.backgroundColor = [UIColor grayColor];
        [self addSubview:_adverImage];
        
        UIImageView * view = [[UIImageView alloc] init];
        _imageIcon = view;
        [self addSubview:_imageIcon];
        _imageIcon.userInteractionEnabled = YES;
        [_imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((self.frame.size.width -215)/2));
            make.width.equalTo(@(215));
            make.height.equalTo(@15);
            make.top.equalTo(_adverImage.mas_bottom).equalTo(@5);
        }];
    


    }
    return self;
}
-(void)setString:(NSString *)string{
    
    _string = string;
    _imageIcon.image = [UIImage imageNamed:string];
 
}

-(void)setAdVerString:(NSString *)adVerString{
    _adVerString = adVerString;
//    NSLog(@"首页图片%@",_adVerString);
    [_adverImage setImageWithURL:[NSURL URLWithString:_adVerString]placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}

@end
