//
//  ThreeCollectionViewCell.m
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ThreeCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ThreeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ThreeViewModel *)model {
    _model = model;
    
    NSString *imageNameStr = model.goods_img;
    
    if ([imageNameStr rangeOfString:@"http"].location == NSNotFound) {
        imageNameStr = [NSString stringWithFormat:@"%@%@",ImageBaseURL,imageNameStr];
    }
    [self.image sd_setImageWithURL:[NSURL URLWithString:imageNameStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.lab_name.text = model.name;
    self.lab_price.text = model.shop_price;
//
//    NSLog(@"-----%@",model.Id);
}


@end
