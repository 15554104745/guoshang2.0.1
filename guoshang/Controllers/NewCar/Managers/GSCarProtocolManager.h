//
//  GSCarProtocolManager.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GSCarProtocolManagerDelegate <NSObject>

- (void)carProtocolManagerDidChangeTotalPrice:(NSString *)totalPrice isSelectAllGoods:(BOOL)isSelectAllGoods selectGoodsCount:(NSInteger)goodsCount;
- (void)carProtocolManagerWillPushViewController:(UIViewController *)viewController;
- (void)carProtocolManagerReloadAllDatas;
- (void)carProtocolManagerWillAddGoodsToCarWithGoods_id:(NSString *)goods_id;
@end

@interface GSCarProtocolManager : NSObject <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *carGoodsArray;
@property (strong, nonatomic) NSMutableArray *recommendGoodsArray;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<GSCarProtocolManagerDelegate> delegate;

- (void)resetAllData;
- (void)changeSelectAllGoods:(BOOL)isSelectAll;
- (NSString *)getSettleTokenStr;
@end
