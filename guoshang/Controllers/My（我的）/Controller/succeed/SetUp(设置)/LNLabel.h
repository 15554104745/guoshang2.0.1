//
//  LNLabel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LNLabel;


@protocol LimitDown <NSObject>

-(void)LimitOngoing:(NSArray *)djsArr;

-(void)LimitEnd:(NSArray *)djsArr;

@end
@interface LNLabel : UILabel
@property (strong , nonatomic) dispatch_source_t timer;
@property(weak,nonatomic)id<LimitDown> delegate;
+(LNLabel *)addLabelWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat )font BackGroundColor :(UIColor *) backGroundColor;

+(CGSize)calculateLableSizeWithString:(NSString *)string AndFont:(CGFloat )font;

+(CGFloat)calculateMoreLabelSizeWithString:(NSString *)string AndWith:(CGFloat)with AndFont:(CGFloat)font;

+(CGSize)calculateWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

-(instancetype)initWithEndTime:(NSString *)endTime;

+(instancetype)limitWithEndTime:(NSString *)endTime;


@end
