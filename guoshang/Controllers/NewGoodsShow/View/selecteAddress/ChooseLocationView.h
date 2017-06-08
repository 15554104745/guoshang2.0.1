//
//  ChooseLocationView.h
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseLocationViewDelegate <NSObject>

- (void)chooseLocationViewDidFinishSelected:(NSDictionary *)addressInfo;
- (void)chooseLocationViewDidClose;
@end

@interface ChooseLocationView : UIView {
    
        UIView * topView;
        UIView * separateLine;
        UIView *backeView;
        UIButton *selectAddressBtn;

}

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * provience_id;
@property (nonatomic, copy) NSString * city_id;
@property (nonatomic, copy) NSString * district_id;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * provience;
@property (nonatomic, copy) NSString * city;



@property (weak, nonatomic) id <ChooseLocationViewDelegate> delegate;



@property (nonatomic, assign)BOOL notShowUserAddress; //是否不展示选择收货地址
@property (nonatomic, copy) void(^chooseFinish)();
@property (nonatomic, copy) void(^closeSelfBlock)();

- (instancetype)initWithFrame:(CGRect)frame notShowUserAddress:(BOOL)notShowUserAddress;
@end
