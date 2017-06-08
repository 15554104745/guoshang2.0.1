//
//  MerchandiseBasicInfoTableViewCell.m
//  Demo
//
//  Created by suntao on 16/8/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import "MerchandiseBasicInfoTableViewCell.h"

NSString *const kMerchandiseBasicInfoTableViewCellIdentifier = @"MerchandiseBasicInfoTableViewCell";

@interface MerchandiseBasicInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *millisecondLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading2;


@end

@implementation MerchandiseBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(GoodsDetailGoodsInfoModel *)model {
    
    _model = model;
    
    self.goods_name.text = model.goods_name;
    self.goods_desc.text = model.goods_brief;
    self.goods_originalprice.text = model.market_price;
//    self.goods_hadsell.text = [NSString stringWithFormat:@"已售:%@",model.sale_number];
  
    //是否支持兑换  0:不支持  1：支持
    if (model.is_exchange == 1) {
        
        _leading1.priority = 900;
        _leading2.priority = 800;
        
         self.guobiImageView.hidden = NO;
        self.guobiImageView.image = [UIImage imageNamed:@"guobi"];
        self.goods_price.text = [NSString stringWithFormat:@"%@个",model.shop_price];

    }else {
        self.goods_price.text = [NSString stringWithFormat:@"￥%@",model.shop_price];

        _leading1.priority = 800;
        _leading2.priority = 900;
        
        self.guobiImageView.hidden = YES;
        
        if (model.is_promote) {
            self.goods_price.text = model.promote_price;
        }
        //是否赠送国币
        if (model && model.is_give_integral == 0) {

            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.goods_price.frame.origin.x+self.goods_price.frame.size.width, self.goods_price.frame.origin.y, 130, 20)];
            NSString *preLabelPrice = [NSString stringWithFormat:@" 送%@国币",model.shop_price];
            CGSize size2 = CGSizeMake(label.frame.size.width, label.frame.size.height+5);
            UIImage *image = [self imageResize:[UIImage imageNamed:@"duihuakuang"] andResizeTo:size2];
            label.text = preLabelPrice;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.backgroundColor = [UIColor colorWithPatternImage:image];
            [self.contentView addSubview:label];
            
            self.goods_price.text = [NSString stringWithFormat:@"￥%@",model.shop_price];
        }
        
        //是否支持充值卡
        if (model && model.is_recharge_card_pay == 0) {
            UILabel  *preLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.goods_price.frame.origin.x+self.goods_price.frame.size.width, self.goods_price.frame.origin.y, 160, 20)];
            CGSize size2 = CGSizeMake(preLabel.frame.size.width, preLabel.frame.size.height+5);
            UIImage *image = [self imageResize:[UIImage imageNamed:@"duihuakuang"] andResizeTo:size2];
            preLabel.backgroundColor = [UIColor colorWithPatternImage:image];
            preLabel.text = @"该商品不支持充值卡支付 ";
            preLabel.font = [UIFont systemFontOfSize:12];
            preLabel.textAlignment = NSTextAlignmentRight;
            preLabel.textColor = [UIColor whiteColor];
            [self.contentView addSubview:preLabel];
        }


    }
    
    
}


- (IBAction)merchandiseBasicInfoAction:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.block) {
        self.block(index);
    }
}
-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (void)setEndTime:(NSString *)endTime {
//    if(!endTime) return;
//    _endTime = endTime;
//    // 刷新时间
//}

//- (void)updateActivityDateWithComponent:(NSDateComponents *)component {
//    if (self.isEnd) {
//        component.hour = 0;
//        component.minute = 0;
//        component.second = 0;
//        component.nanosecond = 0;
//    }
//    self.hourLabel.text = [NSString stringWithFormat:@"%02ld", (long)component.hour];
//    self.minuteLabel.text = [NSString stringWithFormat:@"%02ld", (long)component.minute];
//    self.secondLabel.text = [NSString stringWithFormat:@"%02ld", (long)component.second];
//    self.millisecondLabel.text = [NSString stringWithFormat:@"%02ld", (long)component.nanosecond / 100000000];
////    NSLog(@"%ld", (long)component.nanosecond);
//}


@end
