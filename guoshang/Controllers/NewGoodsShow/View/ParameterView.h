//
//  ParameterView.h
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "GSGoodsDetailModel.h"

@interface ParameterView : UIView

@property (nonatomic, strong)ChooseView *chooseView;

//存放商品数据 属性

@property (nonatomic, retain)NSDictionary *dataList;
@property (nonatomic, strong) GSGoodsDetailModel *goodsDetailModel;

@property (nonatomic, copy)NSString *attr_id;

@end
