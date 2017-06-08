//
//  GSShopGoodsInfoViewController.h
//  guoshang
//
//  Created by JinLian on 16/9/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define HEADER_VIEW_HEIGHT      400.0f      // 顶部商品图片高度
#define END_DRAG_SHOW_HEIGHT    80.0f       // 结束拖拽最大值时的显示
#define BOTTOM_VIEW_HEIGHT      44.0f       // 底部视图高度（加入购物车＼立即购买）
#define TopTabBarH [global pxTopt:100]
#define NaviBarH 64

#define STWeak(type) __weak typeof(type) weak##type = type

@interface GSShopGoodsInfoViewController : UIViewController

@property (nonatomic, copy)NSString *goodsId;
@property(nonatomic,copy)NSString * from;

#pragma mark - 初始化方法
+ (id)createGoodsDetailView;




@end
