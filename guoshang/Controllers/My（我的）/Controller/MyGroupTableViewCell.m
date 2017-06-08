//
//  MyGroupTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/8/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyGroupTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TimeModel.h"

#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"

@interface MyGroupTableViewCell () {
    
    NSTimer *timer;
    NSTimeInterval time;
    
}
@property (nonatomic, weak)   id           m_data;
@property (nonatomic, assign)   NSInteger section;

@end

@implementation MyGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.goods_goBuy.layer.cornerRadius = 8;
    self.goods_goBuy.clipsToBounds = YES;
//    [self registerNSNotificationCenter];
}

- (void)setModel:(MyGroupModel *)model {
    
    _model = model;
    
    //    self.goods_price.text = model.shop_price;
    self.goods_oldPrice.text = [NSString stringWithFormat:@"原价:%@",model.market_price];
    //    self.goods_butCount.text = [NSString stringWithFormat:@"%@人抢购",model.sale_total];
    
    NSString *imageNameStr = model.goods_img;
    if ([imageNameStr rangeOfString:@"http"].location == NSNotFound) {
        imageNameStr = [NSString stringWithFormat:@"%@%@",ImageBaseURL,imageNameStr];
    }
    [self.goods_image sd_setImageWithURL:[NSURL URLWithString:imageNameStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}

- (void)setHeadModel:(HeadModel *)headModel {
    _headModel = headModel;
    
    self.goods_butCount.text = [NSString stringWithFormat:@"%@人抢购",headModel.user_num];
    self.goods_name.text = headModel.title;
    self.goods_price.text = headModel.group_price;
    
    NSTimeInterval timeDate = [self getTimeIntervalWithStartTime:headModel.end_time];
    
    //非自己绑定的业务员 || 团购时间已过
    //    NSLog(@"----%@, ++++%@",headModel.is_clerk,headModel.end_time);
    if ([headModel.is_clerk isEqualToString:@"N"] || timeDate < 0) {
        self.goods_goBuy.userInteractionEnabled = NO;
        self.goods_goBuy.backgroundColor = [UIColor lightGrayColor];
    }else {
        self.goods_goBuy.userInteractionEnabled = YES;
        self.goods_goBuy.backgroundColor = NewRedColor;
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    if (self.block) {
        self.block(weakSelf.tuan_id);
    }
    
}

//团购结束时间与当前时间的比较
- (NSTimeInterval)getTimeIntervalWithStartTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *start_date = [dateFormatter dateFromString:endTime]; //结束时间
    NSDate *end_date = [[NSDate alloc]init];  //当前时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [start_date timeIntervalSinceDate:end_date];
    return timeInterval;
}


//- (void)dealloc {
//    
//    [self removeNSNotificationCenter];
//}
//
//#pragma mark - 通知中心
//- (void)registerNSNotificationCenter {
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationCenterEvent:)
//                                                 name:@"alreadTimeNotificationName"
//                                               object:nil];
//}
//
//- (void)removeNSNotificationCenter {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alreadTimeNotificationName" object:nil];
//}
//
//- (void)notificationCenterEvent:(id)sender {
////    self.goods_goBuy.userInteractionEnabled = NO;
////    self.goods_goBuy.backgroundColor = [UIColor lightGrayColor];
//    
//}
//
















- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
