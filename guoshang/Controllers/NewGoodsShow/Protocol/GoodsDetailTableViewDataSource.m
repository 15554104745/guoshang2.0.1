//
//  GoodsDetailTableViewDataSource.m
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailTableViewDataSource.h"
#import "MerchandiseBasicInfoTableViewCell.h"
#import "MerchandiseCommentTableViewCell.h"
#import "MerchandiseShopBasicInfoTableViewCell.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "GoodsDetailShopInfoModel.h"
#import "GSStoreDetailViewController.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
@interface GoodsDetailTableViewDataSource () {
    
    
}

@end

@implementation GoodsDetailTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView == self.tableView) {
    
    __weak typeof(self) weakSelf = self;
        switch (indexPath.row) {
            case 0: {
                MerchandiseBasicInfoTableViewCell *basicInfoCell = [tableView dequeueReusableCellWithIdentifier:kMerchandiseBasicInfoTableViewCellIdentifier forIndexPath:indexPath];
                
                GoodsDetailGoodsInfoModel *goodsInfoModel = [self.dataListDic objectForKey:@"goodsInfo"];
                basicInfoCell.model = goodsInfoModel;
                basicInfoCell.block = ^(NSInteger index){
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(passValueDelegate)]) {
                        [weakSelf.delegate passValueDelegate];
                    }
                };
                return basicInfoCell;
            }
                break;
            case 1: {
                MerchandiseCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kMerchandiseCommentTableViewCellIdentifier forIndexPath:indexPath];
                commentCell.dataListDic = self.dataListDic;
                return commentCell;
            }
                break;
            case 2: {
                MerchandiseShopBasicInfoTableViewCell *shopInfoCell = [tableView dequeueReusableCellWithIdentifier:kMerchandiseShopBasicInfoTableViewCellIdentifier forIndexPath:indexPath];
                
                GoodsDetailShopInfoModel *shopModel = [self.dataListDic objectForKey:@"shop_info"];
                shopInfoCell.model = shopModel;
                
                GoodsDetailGoodsInfoModel *GoodspModel = [self.dataListDic objectForKey:@"goodsInfo"];
                NSString *is_collect = shopModel.is_collect;
                if ([is_collect isEqualToString:@"Y"]) {
                    shopInfoCell.concernBtn.selected = YES;
                }else {
                    shopInfoCell.concernBtn.selected = NO;
                }

                __weak typeof(shopInfoCell) shopCell = shopInfoCell;
                //__weak typeof(self) weakSelf = self;
                shopInfoCell.block = ^(NSInteger index){
                    
                    switch (index) {
                            
                        case 1:{
//                            weakSelf.popTitle = @"进店逛逛";
                            //NSDictionary *dic = [shopModel toDictionary];
                            GSStoreDetailViewController *detailVC =ViewController_in_Storyboard(@"Main", @"storeDetailViewController");
                            detailVC.hidesBottomBarWhenPushed = NO;
                            //detailVC.view.backgroundColor = [UIColor whiteColor];
                            //detailVC.storeModel = [GSStoreListModel mj_objectWithKeyValues:dic];
                            GSStoreListModel *storeDetailModel = [GSStoreListModel mj_objectWithKeyValues:[self.dataListDic objectForKey:@"shop_info"]];
//                            storeDetailModel.shop_id = shopModel.shop_id;
//                            NSLog(@"------%@",shopModel.shop_id);
                            detailVC.storeModel = storeDetailModel;
                            
                            [self.conreoller.navigationController pushViewController:detailVC animated:YES];
                        }
                            break;
                        case 2:{
                            if (UserId) {
                                
//                                //关注
                                NSDictionary *dic = @{@"user_id":UserId,@"shop_id":GoodspModel.shop_id};
                                
                                [HttpTool POST:URLDependByBaseURL(@"/Api/Collect/CollectShop") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
                                    
                                    NSString *message = [responseObject objectForKey:@"message"];
                                    
                                    if ([message isEqualToString:@"取消收藏店铺成功"]) {
                                        shopCell.concernBtn.selected = NO;
                                    }
                                    if ([message isEqualToString:@"收藏店铺成功"]) {
                                        shopCell.concernBtn.selected = YES;
                                    }
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
                                
                                }else {
                                    [self PlaestLogIn];
                                }
                        }
                            break;
                    }
                };
                return shopInfoCell;
            }
                break;
        }
//    } else {
//        
//        UITableViewCell *cell = [[UITableViewCell alloc]init];
//        return cell;
//    }
    return nil;
}



- (void)setDataListDic:(NSDictionary *)dataListDic {
    _dataListDic = dataListDic;
    
    
    
}



//登录提示
- (void)PlaestLogIn {
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GSNewLoginViewController * lvc = [[GSNewLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.conreoller.navigationController pushViewController:lvc animated:YES];
    }]];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self.conreoller presentViewController:alertvc animated:YES completion:nil];
}



























@end
