//
//  GroupHeaderView.m
//  guoshang
//
//  Created by JinLian on 16/8/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupHeaderView.h"
#import "TimeModel.h"
#import "UIImageView+WebCache.h"

@interface GroupHeaderView () {
    //    NSTimer *_timer;
    NSTimeInterval time;
    
}
@property (nonatomic, weak)   id           m_data;
@property (nonatomic, assign)   NSInteger section;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greatWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lowWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLab;


@end

@implementation GroupHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNSNotificationCenter];
    
    self.group_image.layer.cornerRadius = 40;
    self.group_image.clipsToBounds = YES;
}

- (void)setModel:(HeadModel *)model {
    
    _model = model;
    
    NSString *imageNameStr = model.avatar;
    if ([imageNameStr rangeOfString:@"http"].location == NSNotFound) {
        imageNameStr = [NSString stringWithFormat:@"%@%@",ImageBaseURL,imageNameStr];
    }
    [self.group_image sd_setImageWithURL:[NSURL URLWithString:imageNameStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.group_name.text = model.user_name;
    self.group_count.text = [NSString stringWithFormat:@"%@人",model.user_num];
    self.group_shopName.text = [NSString stringWithFormat:@"%@",model.store_name];
}

- (void)loadData:(id)data index:(NSInteger)section {
    
    if ([data isMemberOfClass:[TimeModel class]]) {
        
        [self storeWeakValueWithData:data index:section];
        
        TimeModel *model = (TimeModel*)data;
        
        NSString *grouptime =  [NSString stringWithFormat:@"%@",[model currentTimeString]];
        _group_time.text = grouptime;
        
        if (model.timestyle == timeStyleEndTime) {
            _titleTimeLab.text = @"剩余时间：";
        }else if (model.timestyle == timeStyleStatTime) {
            _titleTimeLab.text = @"开始时间：";
        }else if (model.timestyle == timeStyleAlreadyEnd) {
        }
        
        if (grouptime.length >=10) {
            _greatWidth.priority = UILayoutPriorityDefaultHigh;
            _lowWidth.priority = UILayoutPriorityDefaultLow;
        }else {
            _greatWidth.priority = UILayoutPriorityDefaultLow;
            _lowWidth.priority = UILayoutPriorityDefaultHigh;
        }
        
        int currenttime = [model getTimeInterval];
        if (currenttime <= 0) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"alreadTimeNotificationName" object:nil userInfo:@{@"section":[NSString stringWithFormat:@"%ld",section]}];
        }
        
    }
}

- (void)storeWeakValueWithData:(id)data index:(NSInteger )section {
    
    self.m_data         = data;
    self.section = section;
}

- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
    
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data index:self.section];
    }
}

















//- (void)createTimer {
//
//    self.start_time  = @"2016-08-04 10:18:54";
//    self.end_time = @"2016-08-05 10:18:54";
//    time = [self getSurplusTimeWithTime:self.end_time withLastTime:self.start_time];
//
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];//使用timer定时，每秒触发一次
//    [[NSRunLoop currentRunLoop] run];
//}
//
//
//- (NSTimeInterval )getSurplusTimeWithTime:(NSString *)surplusTime withLastTime:(NSString *)lastTime{
//
//    //首先创建格式化对象
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    //然后创建日期对象
//
//    NSDate *date1 = [dateFormatter dateFromString:surplusTime];
//
//    NSDate *date = [dateFormatter dateFromString:lastTime];
//
//    //计算时间间隔（单位是秒）
//
//    NSTimeInterval timeInterval = [date1 timeIntervalSinceDate:date];
//
//    return timeInterval;
//}

//- (void)timerFireMethod:(NSTimer *)theTimer
//{
//    time--;
//
//    NSLog(@"%f",time);
//
//    if (time == 0) {
//        [self stopTimer];
//
//    }else{
//        //计算时、分、秒
//        int hours = ((int)time)%(3600*24)/3600;
//        int minutes = ((int)time)%(3600*24)%3600/60;
//        int seconds = ((int)time)%(3600*24)%3600%60;
//        NSString *dateContent = [[NSString alloc] initWithFormat:@"%i:%i:%i",hours,minutes,seconds];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSLog(@"%@",dateContent);
//            self.group_time.text = dateContent;
//        });
//
//    }
//}
//
//- (void)stopTimer {
//
//    [_timer invalidate];
//    _timer = nil;
//
//}
//


@end
