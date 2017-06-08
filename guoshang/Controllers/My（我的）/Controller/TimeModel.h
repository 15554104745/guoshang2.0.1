//
//  TimeModel.h
//  guoshang
//
//  Created by JinLian on 16/8/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    timeStyleEndTime,    //从结束时间开始倒计时
    timeStyleStatTime,   //从开始时间倒计时
    timeStyleAlreadyEnd, //倒计时已经结束
    
}TomeModeltimeStyle;

@interface TimeModel : NSObject


@property (nonatomic, strong) NSString *m_titleStr;
@property (nonatomic)         int       m_countNum;
@property (nonatomic,assign)TomeModeltimeStyle timestyle;
/**
 *  便利构造器
 *
 *  @param title         标题
 *  @param countdownTime 倒计时
 *
 *  @return 实例对象
 */
+ (instancetype)timeModelWithTitle:(NSString*)title time:(int)time withTimeStyle:(TomeModeltimeStyle)timestyle;

/**
 *  计数减1(countdownTime - 1)
 */
- (void)countDown;

/**
 *  将当前的countdownTime信息转换成字符串
 */
- (NSString *)currentTimeString;
//获取剩余时间戳
- (int)getTimeInterval;


@end
