//
//  LNVersionShowView.h
//  guoshang
//
//  Created by 宗丽娜 on 16/4/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RemoveShowViewBlock)();
typedef void(^GoToAppStoreBlock)();

@interface LNVersionShowView : UIView
@property(nonatomic,copy)RemoveShowViewBlock removeShowViewBlock;

@property(nonatomic,copy)GoToAppStoreBlock GoToAppStoreBlock;

@property(nonatomic,copy)NSString * vesionStr;
@property(nonatomic,strong)NSArray * infocontent;
//更新的提示框
-(instancetype)initWith:(NSString *)version Describe:(NSArray *)describeArr;


@end
