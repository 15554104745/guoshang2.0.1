//
//  StepProgressView.h
//  Progress
//
//  Created by JinLian on 16/9/23.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepProgressView : UIView

@property (nonatomic,assign) NSInteger stepIndex;
+(instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray;

@end





