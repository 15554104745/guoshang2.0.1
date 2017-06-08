//
//  UIButton+GSExtension.h
//  guoshang
//
//  Created by 金联科技 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GSExtension)

+(UIButton*)buttonWithFrame:(CGRect)frame withImageName:(NSString*)imgName  withTitle:(NSString*)title withFontSize:(CGFloat)size addTarget:(id)target WithSelector:(SEL)selector;
@end
