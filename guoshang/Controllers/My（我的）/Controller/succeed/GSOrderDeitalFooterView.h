//
//  GSOrderDeitalFooterView.h
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSOrderDetailModel.h"
//typedef NS_ENUM(NSInteger,GSOrderDeailBtnType){
//   
//    GSOrderDeailBtnTypePay,
//    GSOrderDeailBtnTypeRefound
//} ;

@interface GSOrderDeitalFooterView : UIView

@property (copy, nonatomic) void(^payButtonClickBlock)(void);

- (instancetype)initWithHeight:(CGFloat)height orderDetailModel:(GSOrderDetailModel *)detailModel;
@end
