//
//  GSShopSortToolButton.h
//  guoshang
//
//  Created by Rechied on 2016/11/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSShopSortToolButton;
typedef NS_ENUM(NSInteger, GSShopSortButtonSortType) {
    GSShopSortButtonSortTypeNormal = 0,         //默认
    GSShopSortButtonSortTypeUp,                 //升序
    GSShopSortButtonSortTypeDown,               //降序
    GSShopSortButtonSortTypeSiftNormal = 10,    //筛选未选中
    GSShopSortButtonSortTypeSiftSelected,       //筛选选中
};

@protocol GSShopSortToolButtonDelegate <NSObject>

- (void)shopSortButton:(GSShopSortToolButton *)shopSortButton didSelectWithSortParams:(NSString *)sortParams sortTypeStr:(NSString *)sortTypeStr;
@optional
- (void)shopSortSiftButtonDidClickWithSortType:(GSShopSortButtonSortType)sortType;
@end

@interface GSShopSortToolButton : UIView

@property (readonly, nonatomic, copy) NSString *sortParams;
@property (readonly, nonatomic, copy) NSString *sortTypeStr;

@property (assign, nonatomic) GSShopSortButtonSortType sortType;

@property (weak, nonatomic) id <GSShopSortToolButtonDelegate> delegate;

+ (instancetype)buttonWithTitle:(NSString *)title sortType:(GSShopSortButtonSortType)sortType sortParamsString:(NSString *)sortParamsString;
- (void)changeSortType:(GSShopSortButtonSortType)sortType;
@end

