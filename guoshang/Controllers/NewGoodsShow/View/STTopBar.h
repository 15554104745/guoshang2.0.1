//
//  STTopBar.h
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabButton;
@class STTopBar;

@protocol STTabBarDelegate <NSObject>
@optional
-(void)tabBar:(STTopBar *)tabBar didSelectIndex:(NSInteger)index;

@end

@interface STTopBar : UIView

@property(nonatomic,weak) id<STTabBarDelegate> delegate;
/**
 静态方法初始化
 */
+(instancetype)tabbar;
/**
 使用数组初始化
 */
-(instancetype)initWithArray:(NSArray*)array;
-(void)AddTarBarBtn:(NSString *)name;//添加顶部标题项的名字
-(void)TabBtnClick:(TabButton *)sender;//监听tabbar的点击

@end
