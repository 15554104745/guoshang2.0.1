//
//  MultilevelMenu.h
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>


// 制定的规则
@protocol MultiViewDelegate <NSObject>
// 想做的事
- (void)sendValue:(NSInteger)index;


@end


#define kLeftWidth 100

@interface MultilevelMenu : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

// 设置代理   assign 或者 weak  防止循环引用
@property (nonatomic, weak)  id<MultiViewDelegate> delegate;

@property(strong,nonatomic,readonly) NSArray * allData;


@property(copy,nonatomic,readonly) id myblock;


@property(assign,nonatomic) BOOL isRecordLastScroll; //是否记录最后滑动

@property(assign,nonatomic) NSInteger selectIndex; //选择id

/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * leftBgColor;
/**
 *  左边选中文字颜色
 */
@property(strong,nonatomic) UIColor * leftSelectColor;
/**
 *  左边选中背景颜色
 */
@property(strong,nonatomic) UIColor * leftSelectBgColor;

/**
 *  左边未选中文字颜色
 */

@property(strong,nonatomic) UIColor * leftUnSelectColor;
/**
 *  左边未选中背景颜色
 */
@property(strong,nonatomic) UIColor * leftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * leftSeparatorColor;


@property(strong,nonatomic ) UIButton * adButton; //广告位图片

// 定义一个block
@property (nonatomic, copy) void(^myBlock)(NSString *);



-(id)initWithFrame:(CGRect)frame WithData:(NSArray*)data withSelectIndex:(void(^)(NSInteger left,NSInteger right,id info))selectIndex;



@end


@interface rightMenu : NSObject

/**
 *  菜单图片名
 */
@property(copy,nonatomic) NSString * urlName;
/**
 *  菜单名
 */
@property(copy,nonatomic) NSString * menuName;
/**
 *  菜单ID
 */
@property(copy,nonatomic) NSString * ID;

/**
 *  下一级菜单
 */
@property(strong,nonatomic) NSArray * nextArray;

/**
 *  菜单层数
 */
@property(assign,nonatomic) NSInteger meunNumber;


/**
 *  滑动的位移
 */
@property(assign,nonatomic) float offsetScorller;


@end
