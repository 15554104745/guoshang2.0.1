//
//  GSCustomIconAndTitleButton.h
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSCustomIconAndTitleButton : UIView

@property (copy, nonatomic) void(^clickBlock)(void);

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont;

- (void)addTarget:(id)target action:(SEL)action;

@end
