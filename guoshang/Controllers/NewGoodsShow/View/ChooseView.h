//
//  ChooseView.h
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeView.h"
#import "BuyCountView.h"

@interface ChooseView : UIView <UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic, retain)UIView *alphaiView; 
@property(nonatomic, retain)UIView *whiteView;

@property(nonatomic, retain)UIImageView *img;    //图片

@property(nonatomic, retain)UILabel *lb_price;   //价格
@property(nonatomic, retain)UILabel *lb_stock;   //库存
@property(nonatomic, retain)UILabel *lb_detail;
@property(nonatomic, retain)UILabel *lb_line;

@property(nonatomic, retain)UIScrollView *mainscrollview;

@property(nonatomic, retain)TypeView *colorView;            //每一个属性选项  创建时传入属性数量  属性名称
@property(nonatomic, retain)TypeView *sizeView;
@property(nonatomic, retain)BuyCountView *countView;        //购买数量加减

@property(nonatomic, retain)UIButton *bt_sure;              //加入购物车
@property(nonatomic, retain)UIButton *bt_cancle;            //取消按钮 取消选择
@property(nonatomic, retain)UIButton *bt_buyNew;            //立即购买


@property(nonatomic) int stock;   //库存

@property(nonatomic, retain)NSDictionary *dataList;         //存放商品信息  从外面传入




@end
