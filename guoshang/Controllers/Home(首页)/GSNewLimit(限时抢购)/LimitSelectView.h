//
//  LimitSelectView.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^returnTitleBlock)(NSString *str1,NSString *str2,NSInteger beginType);
typedef void(^returnTimeBlock)(NSString *time,NSString *VCNum,NSInteger beginType);


@interface LimitSelectView : UIView

@property(nonatomic,copy)returnTitleBlock ReturnTitle;
@property(nonatomic,copy)returnTimeBlock ReturnTime;


@property(nonatomic,assign)NSInteger selectPlage;

@property(nonatomic,copy)NSString *titleTime1;
@property(nonatomic,copy)NSString *titleTime2;

@property(nonatomic,copy)NSString *shiftTime1;
@property(nonatomic,copy)NSString *shiftTime2;
@property(nonatomic,strong)NSMutableArray *headerArr;

@property(nonatomic,strong)UIViewController *popVC;

- (void)setCallbackBlock:(void(^)(NSInteger index))block;

//选中button
- (void)selectBtn:(NSInteger)index;
@end
