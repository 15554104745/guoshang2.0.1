//
//  GroupBuyNowController.h
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

//判断从哪一个页面进入 团购首页或者订单页
typedef enum {
    enterWith_Shouye,
    enterWith_Dingdan
}enterStyle;


@interface GroupBuyNowController : UIViewController

@property (nonatomic, copy)NSString *tun_id;
@property (nonatomic, assign)enterStyle enterstyle;

@end
