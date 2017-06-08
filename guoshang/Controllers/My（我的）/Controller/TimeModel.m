//
//  TimeModel.m
//  guoshang
//
//  Created by JinLian on 16/8/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

+ (instancetype)timeModelWithTitle:(NSString*)title time:(int)time withTimeStyle:(TomeModeltimeStyle)timestyle {
    
    TimeModel *model = [self new];
    
    model.m_titleStr = title;
    model.m_countNum = time;
    model.timestyle = timestyle;
    return model;
}

- (void)countDown {
    
    _m_countNum -= 1;
}

- (NSString*)currentTimeString {
    
    if (_m_countNum < 0) {
//        向cell发送通知，判断是否可点击
        return @"时间已到";
        
    } else if (_m_countNum >= 0 ){
        int day = _m_countNum/3600/24;
        if (day > 0) {
            return [NSString stringWithFormat:@"%d天%02ld:%02ld:%02ld",day,(long)_m_countNum/3600%24,(long)_m_countNum%3600/60,(long)_m_countNum%60];
        }else {
            return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)_m_countNum/3600,(long)_m_countNum%3600/60,(long)_m_countNum%60];
        }
    }else {
        
    }
    
    
    return nil;
}

- (int)getTimeInterval {
    return _m_countNum;
}
@end
