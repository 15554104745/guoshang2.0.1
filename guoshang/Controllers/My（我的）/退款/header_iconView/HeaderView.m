//
//  HeaderView.m
//  QQHeader
//
//  Created by 金联科技 on 16/10/19.
//  Copyright © 2016年 ljj. All rights reserved.
//

#import "HeaderView.h"
#import "JJHeaders.h"
#import "UIImageView+WebCache.h"
#define view_Width  self.frame.size.width
#define view_Height self.frame.size.height
@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    

    
}
-(void)setImgUrlArr:(NSArray *)imgUrlArr{
    _imgUrlArr = imgUrlArr;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    
    for (NSString *imgStr in imgUrlArr) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
       [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
        
        [imgArr addObject:imageView.image];
    }
    
    UIView *view1 = [JJHeaders createHeaderView:view_Height
                                                 images:imgArr];
        CGPoint center = self.center;
        view1.center = CGPointMake(center.x, 90);
    view1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self addSubview:view1];
    
}


@end
