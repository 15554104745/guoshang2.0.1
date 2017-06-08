//
//  OrderSelectView.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSelectView : UIView

@property(nonatomic,assign)BOOL isOrder;
@property(nonatomic,assign)NSInteger selectPlage;


- (void)setCallbackBlock:(void(^)(NSInteger index))block;

//选中button
- (void)selectBtn:(NSInteger)index;
@end
