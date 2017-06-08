//
//  GSCarProtocolManager.m
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarProtocolManager.h"
#import "GSCarRecommendGoodsCollectionViewCell.h"
#import "GSCarGoodsTableViewCell.h"
#import "GSCarShopModel.h"
#import "GSCarShopSectionTableViewCell.h"
#import "GSCarShopSectionHeader.h"
#import "GSCarRequestManager.h"
#import "MBProgressHUD.h"

#import "GSGoodsDetailInfoViewController.h"


@interface GSCarProtocolManager ()<GSCarGoodsTableViewCellDelegate, GSCarShopSectionHeaderDelegate, GSCarRecommendGoodsCollectionViewCellDelegate>

@end

@implementation GSCarProtocolManager
@synthesize carGoodsArray = _carGoodsArray;

- (NSMutableArray *)carGoodsArray {
    if (!_carGoodsArray) {
        _carGoodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _carGoodsArray;
}

- (NSMutableArray *)recommendGoodsArray {
    if (!_recommendGoodsArray) {
        _recommendGoodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _recommendGoodsArray;
}

- (void)setCarGoodsArray:(NSMutableArray *)carGoodsArray {
    _carGoodsArray = carGoodsArray;
    [self changeCarToolsBar];
}

- (void)resetAllData {
    [self.carGoodsArray removeAllObjects];
    [self.recommendGoodsArray removeAllObjects];
}

/**
 获取是否全选
 */
- (BOOL)isSelectAllGoods {
    for (GSCarShopModel *shopModel in self.carGoodsArray) {
        if (!shopModel.select_shop) {
            return NO;
        }
    }
    return YES;
}


/**
 获取所有已选择商品的价格和选择的商品总数
 */
- (void)getAllSelectGoodsPriceAndAllGoodsCount:(void(^)(NSString *goodsPirce, NSInteger count))completed {
    if (completed) {
        CGFloat totalPrice = 0;
        NSInteger allGoodsCount = 0;
        for (GSCarShopModel *shopModel in self.carGoodsArray) {
            totalPrice += [[shopModel getShopTotalPrice] floatValue];
            allGoodsCount += [shopModel getShopSelectGoodsCount];
        }
        completed([NSString stringWithFormat:@"%.2f",totalPrice], allGoodsCount);
    }
}


/**
 触发代理方法改变购物车工具条的显示内容
 */
- (void)changeCarToolsBar {
    if ([_delegate respondsToSelector:@selector(carProtocolManagerDidChangeTotalPrice:isSelectAllGoods:selectGoodsCount:)]) {
        __weak typeof(self) weakSelf = self;
        [self getAllSelectGoodsPriceAndAllGoodsCount:^(NSString *goodsPirce, NSInteger count) {
            [_delegate carProtocolManagerDidChangeTotalPrice:goodsPirce isSelectAllGoods:[weakSelf isSelectAllGoods] selectGoodsCount:count];
        }];
        
    }
}

/**
 设置全选/全不选

 @param isSelectAll 是否全选
 */
- (void)changeSelectAllGoods:(BOOL)isSelectAll {
    
    for (GSCarShopModel *shopModel in self.carGoodsArray) {
        [shopModel setSelect_shop:isSelectAll];
        [shopModel resetGoodsSelect:isSelectAll];
        [self.tableView reloadData];
    }
    [self changeCarToolsBar];
}

- (NSString *)getSettleTokenStr {
    NSMutableString *tokenStr = [[NSMutableString alloc] initWithCapacity:0];
    for (GSCarShopModel *shopModel in self.carGoodsArray) {
        for (GSCarGoodsModel *goodsModel in shopModel.goods_list) {
            if (goodsModel.select_goods) {
                [tokenStr appendString:[NSString stringWithFormat:@"%@#",goodsModel.rec_id]];
            }
        }
    }
    return [NSString stringWithString:tokenStr];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 实现侧滑删除
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.carGoodsArray.count) {
        GSCarShopModel *shopModel = self.carGoodsArray[indexPath.section];
        if (indexPath.row < shopModel.goods_list.count) {
            GSCarGoodsModel *goodsModel = shopModel.goods_list[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.tableView];
            [GSCarRequestManager deleteCarGoodsWithRec_id:goodsModel.rec_id completed:^(BOOL isSuccess) {
                [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
                if (isSuccess) {
                    NSMutableArray *tempArray = [shopModel.goods_list mutableCopy];
                    [tempArray removeObject:goodsModel];
                    shopModel.goods_list = [NSArray arrayWithArray:tempArray];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    if (shopModel.goods_list.count == 0) {
                        [weakSelf.carGoodsArray removeObject:shopModel];
                        [weakSelf.tableView reloadData];
                        if (weakSelf.carGoodsArray.count == 0) {
                            if ([_delegate respondsToSelector:@selector(carProtocolManagerReloadAllDatas)]) {
                                [_delegate carProtocolManagerReloadAllDatas];
                            }
                        }
                    }
                }
            }];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.carGoodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.carGoodsArray.count) {
        GSCarShopModel *shopModel = self.carGoodsArray[section];
        return shopModel.goods_list.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSCarGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSCarGoodsTableViewCell" forIndexPath:indexPath];
    if (indexPath.section < self.carGoodsArray.count) {
        GSCarShopModel *shopModel = self.carGoodsArray[indexPath.section];
        if (indexPath.row < shopModel.goods_list.count) {
            cell.carGoodsModel = shopModel.goods_list[indexPath.row];
            cell.section = indexPath.section;
            cell.delegate = self;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GSCarShopSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GSCarShopSectionHeader"];
    if (section < self.carGoodsArray.count) {
        sectionHeader.shopModel = self.carGoodsArray[section];
        sectionHeader.section = section;
        sectionHeader.delegate = self;
    }
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

#pragma mark - GSCarRecommendGoodsCollectionViewCellDelegate

/**
 添加推荐商品到购物车

 @param goods_id 商品id
 */
- (void)carRecommendGoodsCellWillAddToCarWithGoods_id:(NSString *)goods_id {
    if ([_delegate respondsToSelector:@selector(carProtocolManagerWillAddGoodsToCarWithGoods_id:)]) {
        [_delegate carProtocolManagerWillAddGoodsToCarWithGoods_id:goods_id];
    }
}

#pragma mark - GSCarGoodsTableViewCellDelegate

/**
 购物车选中或取消选中某件商品时调用的代理方法

 @param goodsModel 商品的模型
 @param section    被操作商品所属区（用于取出对应的shop模型）
 */
- (void)carGoodsCellDidChangeSelectWithGoodsModel:(GSCarGoodsModel *)goodsModel inSection:(NSInteger)section {
    GSCarShopModel *shopModel = self.carGoodsArray[section];
    goodsModel.select_goods ? [shopModel.goods_list_select addObject:goodsModel] : [shopModel.goods_list_select removeObject:goodsModel];
    shopModel.select_shop = shopModel.goods_list_select.count == shopModel.goods_list.count;
    [self changeCarToolsBar];
    [self.tableView reloadData];
}

/**
 购物车产品数量改变
 */
- (void)carGoodsDidChangeCount {
    [self changeCarToolsBar];
}

/**
 购物车商品属性改变
 */
- (void)carGoodsDidChangeAttribute {
    if ([_delegate respondsToSelector:@selector(carProtocolManagerReloadAllDatas)]) {
        [_delegate carProtocolManagerReloadAllDatas];
    }
}
#pragma mark - GSCarShopSectionTableViewCellDelegate

/**
 购物车中选中或取消选中某个店铺下的所有商品时调用的方法

 @param shopModel 店铺的模型
 @param section   被操作店铺所属区（用于刷新当前区内商品的选中状态）
 */
- (void)carShopSectionCellDidChangeSelectWithGoodsModel:(GSCarShopModel *)shopModel inSection:(NSInteger)section {
    if (!shopModel.select_shop) {
        [shopModel resetGoodsSelect:shopModel.select_shop];
    }
    [self changeCarToolsBar];
    [self.tableView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.recommendGoodsArray.count) {
        
        if ([_delegate respondsToSelector:@selector(carProtocolManagerWillPushViewController:)]) {
            GSHomeRecommendModel *recommendModel = self.recommendGoodsArray[indexPath.item];
            GSGoodsDetailInfoViewController *detailInfoViewController = [[GSGoodsDetailInfoViewController alloc] init];
            detailInfoViewController.hidesBottomBarWhenPushed = YES;
            detailInfoViewController.recommendModel = recommendModel;
            [_delegate carProtocolManagerWillPushViewController:detailInfoViewController];
        }
    }
}

#pragma mark - UICollectioonViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.recommendGoodsArray.count != 0 ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendGoodsArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && kind == UICollectionElementKindSectionHeader && self.recommendGoodsArray) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSCarRecommendGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GSCarRecommendGoodsCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item < self.recommendGoodsArray.count) {
        cell.goodsModel = self.recommendGoodsArray[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Width - 5) / 2, (Width - 5) / 2 + 65);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

/**
 cell的最小左右间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

/**
 cell的上下间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Width, 40.0f);
}
@end
