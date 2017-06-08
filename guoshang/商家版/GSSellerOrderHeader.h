//
//  GSSellerOrderHeader.h
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,GSOrderInfoType){
    
    
    //    客户订单
    GSOrderTypeCustomer,
    
    
    //    商家版我的订单
    GSOrderTypeUser,
    
};
@interface GSSellerOrderHeader : UIView

@property (nonatomic,strong) id model;
@property (nonatomic,assign)GSOrderInfoType  sellerOrderType;
+(instancetype)sellerHeaderViewWithOrderType:(GSOrderInfoType)type;
@end
