//
//  GSOrderDetailViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderDetailViewController.h"
#import "GoodsModel.h"
#import "OrderPayViewController.h"
#import "GSOrderGoosInfoTableViewCell.h"
#import "GSOrderUserInfoTableViewCell.h"
#import "GSOrderLogisticsTableViewCell.h"
#import "GSOrderOrderInfoTableViewCell.h"
#import "RequestManager.h"
#import "GSOrderDeitalFooterView.h"
#import "GSOrderGoodsModel.h"
#import "MBProgressHUD.h"
#import "GSOrderGoodsListModel.h"
#import "GSOrderDetailShopHeaderView.h"
#import "UIImageView+WebCache.h"
static NSString *goodsInfoCell = @"goodsInfoCell";
static NSString *userInfoCell  = @"userInfoCell";
static NSString *logisticsCell = @"logisticsCell";
static NSString *orderInfoCell = @"orderInfoCell";
static NSString *shopHeaderView = @"shopHeaderView";

@interface GSOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GSOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //[self createTableFooterView];
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _goodsArray;
}

- (void)getData {
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/my_order_detail") parameters:@{@"token":[@{@"user_id":UserId,@"order_id":_order_id} paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
//        NSLog(@"%@",[@{@"user_id":UserId,@"order_id":_order_id} paramsDictionaryAddSaltString]);
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];

        if (responseObject) {
//            [responseObject[@"result"] logDictionary];
            
            weakSelf.detailModel = [GSOrderDetailModel mj_objectWithKeyValues:responseObject[@"result"]];
        }
    }];
}

- (void)setDetailModel:(GSOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    __weak typeof(self) weakSelf = self;
    [detailModel.shop_list enumerateObjectsUsingBlock:^(GSOrderGoodsListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.goodsArray addObjectsFromArray:obj.goods_list];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    [self createTableFooterView];
}

- (void)createTableFooterView {
    __weak typeof(self) weakSelf = self;
    GSOrderDeitalFooterView *footerView = [[GSOrderDeitalFooterView alloc] initWithHeight:130 orderDetailModel:self.detailModel];
    footerView.payButtonClickBlock = ^{
        OrderpayViewController *payViewController = [[OrderpayViewController alloc] init];
        payViewController.orderType = self.orderType;
        payViewController.orderId = _detailModel.order_id;
        [weakSelf.navigationController pushViewController:payViewController animated:YES];
    };
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.detailModel.shop_list.count) {
        GSOrderGoodsListModel *goodsListModel = self.detailModel.shop_list[section];
        return goodsListModel.goods_list.count;
    } else {
        return _detailModel ? 3 : 0;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailModel.shop_list.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.detailModel.shop_list.count) {
        return 100;
    } else {
        if (indexPath.row == 2) {
            return 100;
        } else if (indexPath.row == 1){
            return 40;
        } else {
            return 70;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < self.detailModel.shop_list.count) {
        GSOrderDetailShopHeaderView *header = [tableView dequeueReusableCellWithIdentifier:shopHeaderView];
        GSOrderGoodsListModel *shopListModel = self.detailModel.shop_list[section];
        header.shop_title_label.text = shopListModel.shop_title;
        [header.icon_imageView sd_setImageWithURL:[NSURL URLWithString:shopListModel.shop_logo] placeholderImage:[UIImage imageNamed:@"icon"]];
        return header;
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.detailModel.shop_list.count) {
        return 30;
    } else {
        return 20;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.detailModel.shop_list.count) {
        
        GSOrderGoosInfoTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCell forIndexPath:indexPath];
        GSOrderGoodsListModel *goodsListModel = self.detailModel.shop_list[indexPath.section];
        if (indexPath.row < goodsListModel.goods_list.count) {
            goodsCell.goodsModel = goodsListModel.goods_list[indexPath.row];
        }
        
        return goodsCell;
        
    } else {
        if (indexPath.row == 0) {
            GSOrderUserInfoTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:userInfoCell forIndexPath:indexPath];
            userCell.nameLabel.text = self.detailModel.consignee;
            userCell.phoneLabel.text = self.detailModel.tel;
            userCell.addressLabel.text = self.detailModel.strAddress;
            return userCell;
        } else if (indexPath.row == 1) {
            GSOrderLogisticsTableViewCell *logistCell = [tableView dequeueReusableCellWithIdentifier:logisticsCell forIndexPath:indexPath];
            
            logistCell.distributionTypeLabel.text =[self.detailModel.shipping_name isEqualToString:@""] ? @"上门取货":self.detailModel.shipping_name;
            if (![self.detailModel.shipping_name isEqualToString:@"国商快递"]) {
                logistCell.logisticsInfoLabel.text = [self.detailModel.shipping_name isEqualToString:@""]? @"上门取货" : self.detailModel.shipping_name;
            } else {
                logistCell.logisticsInfoLabel.text = @"暂无物流信息";
            }
            
            return logistCell;
        } else {
            GSOrderOrderInfoTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:orderInfoCell forIndexPath:indexPath];
            orderCell.orderNumberLabel.text = self.detailModel.order_sn;
            orderCell.payTypeLabel.text = [self.detailModel.pay_name isEqualToString:@""]? @"  ":self.detailModel.pay_name;
            orderCell.orderDateLabel.text = self.detailModel.add_time;
            return orderCell;
        }
    }
}



- (IBAction)backButtonClick:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
