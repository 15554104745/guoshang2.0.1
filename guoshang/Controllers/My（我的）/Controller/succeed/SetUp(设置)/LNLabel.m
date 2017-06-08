
//  LNLabel.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LNLabel.h"

@implementation LNLabel



-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

+(LNLabel *)addLabelWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat)font  BackGroundColor:(UIColor *)backGroundColor{
   LNLabel * label = [[LNLabel alloc] init];
    label.backgroundColor = backGroundColor;
    label.text = title;
    label.textColor = titleColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
   
}

+(instancetype)limitWithEndTime:(NSString *)endTime{
    
    return [[self alloc] initWithEndTime:endTime];
}
-(instancetype)initWithEndTime:(NSString *)endTime{
    self = [super init];
    if (self) {
       
       NSInteger endtime = [ endTime integerValue];
        
        [self countDownTimeWith:endtime];
    }
    return self;
}
+(CGSize)calculateLableSizeWithString:(NSString *)string AndFont:(CGFloat )font{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size;
}

+(CGFloat)calculateMoreLabelSizeWithString:(NSString *) string AndWith:(CGFloat)with AndFont:(CGFloat)font{

    return [string boundingRectWithSize:CGSizeMake(with, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;
}

+(CGSize)calculateWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

-(void)countDownTimeWith:(NSInteger )endTime{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;
    NSTimeInterval  Newtime = endTime - currentTime;
    __block int timeout = Newtime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置显示界面
                NSArray * array = [self TimeformatFromSeconds:timeout];
                [self.delegate LimitEnd:array];
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置显示界面
                NSArray * array = [self TimeformatFromSeconds:timeout];
                [self.delegate LimitOngoing:array];
                
            });
            timeout --;
        }
        
    });
    
    dispatch_resume(self.timer);
}

-(NSArray *)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of day
    //    NSString *str_day = [NSString stringWithFormat:@"%02ld",seconds/(3600*24)];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/(3600)];//小时
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds/60)%60];//分
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];//秒
    //format of time
    //    NSArray *format_time = [NSArray arrayWithObjects:str_day,str_hour,str_minute,str_second, nil];
    NSArray * format_time = [NSArray arrayWithObjects:str_hour,str_minute,str_second ,nil];
    return format_time;
    
}

@end
