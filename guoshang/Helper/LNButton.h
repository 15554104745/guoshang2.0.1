//
//  LNButton.h

//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LNButton;
typedef void(^buttonBlock)(LNButton * button);
@interface LNButton : UIButton
@property(nonatomic,copy)buttonBlock tempBlock;

+(LNButton *)buttonWithFrame:(CGRect)frame Type:(UIButtonType)type Title:(NSString *)title  Font:(CGFloat)font Target:(id)target AndAction:(SEL)sel;

+(LNButton *)buttonWithFrame:(CGRect)frame Type:(UIButtonType )type Title:(NSString *)title TitleColor:(UIColor*)titleColor Font:(CGFloat)font BackgroundImage:(NSString*)image andBlock:(buttonBlock)block;
+(LNButton *)buttonWithType:(UIButtonType)type Title:(NSString *)title TitleColor:(UIColor *) titleColor Font:(CGFloat)font Target:(id)target AndAction:(SEL)sel;

+(LNButton *)buttonWithType:(UIButtonType )type Title:(NSString *)title TitleColor:(UIColor*)titleColor Font:(CGFloat)font image:(NSString * )image andBlock:(buttonBlock)block;
@end
