
//
//  GSChackOutOrderViewController.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderViewController.h"

#import "GSChackOutOrderTableViewCell.h"
#import "GSChackOutOrderSectionHeaderCell.h"
#import "GSChackOutOrderSectionFooterCell.h"
#import "GSChackOutTotalInfoView.h"
#import "ChooseLocationView.h"

#import "GSChooseAddressManager.h"
#import "GSChooseAddressViewController.h"
#import "GSAddAddressViewController.h"
#import "AlertTool.h"
#import "MBProgressHUD.h"
#import "RequestManager.h"
#import "GSSettleManager.h"


@interface GSChackOutOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,GSChooseAddressViewControllerDelegate,GSAddAddressViewControllerDelegate,GSChackOutOrderSectionFooterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GSChackOutTotalInfoView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewTop;
@property (weak, nonatomic) IBOutlet UIView *navView;



@property (weak, nonatomic) ChooseLocationView *chooseLocationView;
@property (weak, nonatomic) UIView *cover;
@end

@implementation GSChackOutOrderViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getOrderData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)getOrderData {
    __weak typeof(self) weakSelf = self;
    //[MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t getDataGroup = dispatch_group_create();
        [weakSelf getOrderDataWithGCDGroup:getDataGroup];
        dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:nil animated:YES];
        });
    });
}

- (void)getOrderDataWithGCDGroup:(dispatch_group_t)GCDGroup {
    __weak typeof(self) weakSelf = self;
    
    if (GCDGroup) {
        dispatch_group_enter(GCDGroup);
    }
    
    NSString *URLString = nil;
    NSDictionary *params = nil;
    switch (self.chackOutOrderType) {
        case GSChackOutOrderTypeDefault:
            URLString = @"/Api/Order/new_checkOut";
            params = @{@"user_id":UserId,
                       @"rec_id":[NSString stringWithFormat:@"%@",self.tokenStr]};
            break;
            
        case GSChackOutOrderTypeGuoBi:
            URLString = @"?m=Api&c=Order&a=checkOutExchange";
            params = @{@"user_id":UserId,
                       @"type":@"4"};
            break;
            
        case GSChackOutOrderTypeBusiness:
            URLString = @"/Api/Repository/checkOut";
            params = @{@"shop_id":GS_Business_Shop_id,
                       @"rec_id":self.tokenStr};
            break;
            
        default:
            break;
    }
    
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(URLString) parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
    
        if (error) {
            [self.navigationController popViewControllerAnimated:NO];
            CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"服务器繁忙，请稍后再试!"];
            CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:nil];
            
            [alert addAction:cancel];
            [self presentViewController:alert animated:NO completion:nil];
            
        } else if (responseObject[@"result"] && [responseObject[@"status"] integerValue] == 3) {
            weakSelf.chackOutDetailModel = [GSChackOutDetailModel mj_objectWithKeyValues:responseObject[@"result"]];
        } else {
            
            
            CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:responseObject[@"message"]];
            CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:NO completion:nil];

        }
        if (GCDGroup) {
            dispatch_group_leave(GCDGroup);
        }
    }];
}

- (void)setChackOutDetailModel:(GSChackOutDetailModel *)chackOutDetailModel {
    _chackOutDetailModel = chackOutDetailModel;
    if (chackOutDetailModel.address) {
        [self.userInfoView updateAddressWithAddressModel:chackOutDetailModel.address];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有收货地址，请先添加收货地址" delegate:self cancelButtonTitle:@"去添加" otherButtonTitles:@"取消", nil];
        alertView.tag = 10080;
        [alertView show];
    }
    
    chackOutDetailModel.total.chackOutOrderType = self.chackOutOrderType;
    [self.bottomView setTotalModel:chackOutDetailModel.total];
    [self.tableView reloadData];
}

#pragma mark - Button Click Functions

- (IBAction)changeDetailInfoClick:(UIButton *)sender {
    
    GSChooseAddressViewController *chooseAddressViewController = ViewController_in_Storyboard(@"Main", @"GSChooseAddressViewController");
    chooseAddressViewController.selectAddressID = self.chackOutDetailModel.address.address_id;
    chooseAddressViewController.delegate = self;
    [self.navigationController pushViewController:chooseAddressViewController animated:YES];
    
}

- (IBAction)toSettleButtonClick:(UIButton *)sender {
    [self settle];
}

- (IBAction)backButtonClick:(id)sender {
    CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:nil message:@"便宜不等人，请三思而行～"];
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我再想想" handler:nil];
    CKAlertAction *commit = [CKAlertAction actionWithTitle:@"去意已决" backgroundColor:[UIColor colorWithHexString:@"f23030"] titleColor:[UIColor whiteColor] handler:^(CKAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:cancel];
    [alert addAction:commit];
    [self presentViewController:alert animated:NO completion:nil];
    
}

#pragma mark - 去结算
- (void)settle {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[self.chackOutDetailModel getTotalShopIDAndTotalShippingID]];
    
    [params setObject:UserId forKey:@"user_id"];
    [params setObject:@"iOS" forKey:@"referer"];
    [params setObject:self.chackOutDetailModel.address.address_id forKey:@"address_id"];
    
    switch (self.chackOutOrderType) {
        case GSChackOutOrderTypeDefault: {
            [params setObject:self.tokenStr forKey:@"rec_id"];
            [params setObject:@"0" forKey:@"flow_type"];
            [GSSettleManager settleDefaultOrderWithParams:[NSDictionary dictionaryWithDictionary:params] viewController:self];
        }
            break;
            
        case GSChackOutOrderTypeGuoBi: {
            [params setObject:@"4" forKey:@"flow_type"];
            [GSSettleManager settleGuoBiOrderWithParams:[NSDictionary dictionaryWithDictionary:params] viewController:self];
        }
            break;
            
        case GSChackOutOrderTypeBusiness: {
            [params setObject:self.tokenStr forKey:@"rec_id"];
            [params setObject:GS_Business_Shop_id forKey:@"shop_id"];
            [GSSettleManager settleBusinessOrderWithParams:params viewController:self];
        }
            
        default:
            break;
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10080) {
        switch (buttonIndex) {
            case 0: {
                GSAddAddressViewController *addAddress = ViewController_in_Storyboard(@"Main", @"GSAddAddressViewController");
                addAddress.delegate = self;
                [self.navigationController pushViewController:addAddress animated:YES];
            }
                break;
                
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - GSChooseAddressViewControllerDelegate

- (void)chooseAddressViewControllerDidSelectAddress:(GSChackOutOrderAddressModel *)addressModel {
    
    self.chackOutDetailModel.address = addressModel;
    [self.userInfoView updateAddressWithAddressModel:addressModel];
    if (self.chackOutOrderType == GSChackOutOrderTypeDefault || self.chackOutOrderType == GSChackOutOrderTypeGuoBi) {
//        [self updateShippingPrice];
    }
}

- (void)addAddressViewControllerDidFinishAddAddress:(GSChackOutOrderAddressModel *)addressModel {
    [self.navigationController popViewControllerAnimated:YES];
    self.chackOutDetailModel.address = addressModel;
    [self.userInfoView updateAddressWithAddressModel:addressModel];
}

#pragma mark - GSChackOutOrderSectionFooterCellDelegate
- (void)chackOutOrderSectionFooterDidChangeShipping {
    if (self.chackOutOrderType == GSChackOutOrderTypeDefault || self.chackOutOrderType == GSChackOutOrderTypeGuoBi) {
#pragma mark ----------------------- 运费模板暂时不用 -----------------
        [self updateShippingPrice];
        
    }
}

#pragma mark - 刷新运费

- (void)updateShippingPrice {
    /*
    NSDictionary *params = @{@"rec_id":self.tokenStr, @"shipping_id":[self.chackOutDetailModel getTotalShopIDAndTotalShippingID][@"shipping_id"], @"user_id":UserId, @"province_id":self.chackOutDetailModel.address.province_id};
    
    NSLog(@"%@",[self.chackOutDetailModel getTotalShopIDAndTotalShippingID][@"shipping_id"]);
    __weak typeof(self) weakSelf = self;
    //[MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shipping/getFreight") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        //[MBProgressHUD hideHUDForView:nil animated:YES];
        if (responseObject) {
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                weakSelf.chackOutDetailModel.total.shipping_price = [responseObject[@"result"][@"shipping_price"] copy];
                weakSelf.chackOutDetailModel.total.goods_price = [responseObject[@"result"][@"total_price"] copy];
                weakSelf.chackOutDetailModel.total.order_amount = nil;
                [weakSelf.bottomView setTotalModel:weakSelf.chackOutDetailModel.total];
            }
        }
    }];
     */
    if ([[self.chackOutDetailModel getTotalShopIDAndTotalShippingID][@"shipping_id"] isEqualToString:@"10#"])  {
        self.chackOutDetailModel.total.Deliver = @"1";
    }else
    {
       self.chackOutDetailModel.total.Deliver = @"0";
    }
    [self.bottomView setTotalModel:self.chackOutDetailModel.total];
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView.contentSize.height < Height - 64 - 49) {
//        [scrollView setContentOffset:CGPointZero];
//        return;
//    }
//    
//    [self.view bringSubviewToFront:self.navView];
//    
//    if (scrollView.contentOffset.y >= self.userInfoView.frame.size.height) {
//        self.userInfoViewTop.constant = - self.userInfoView.frame.size.height;
//    }
//    
//    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < self.userInfoView.frame.size.height && self.userInfoViewTop.constant > -self.userInfoView.frame.size.height) {
//        self.userInfoViewTop.constant -= scrollView.contentOffset.y;
//        [scrollView setContentOffset:CGPointZero];
//    }
//    
//    if (scrollView.contentOffset.y <= 0 && self.userInfoViewTop.constant <= 0) {
//        if (scrollView.contentOffset.y < -self.userInfoView.frame.size.height) {
//            self.userInfoViewTop.constant = 0;
//        } else {
//            CGFloat topConstant = self.userInfoViewTop.constant +-scrollView.contentOffset.y > 0 ? 0 : self.userInfoViewTop.constant +-scrollView.contentOffset.y;
//            self.userInfoViewTop.constant = topConstant;
//            [scrollView setContentOffset:CGPointZero];
//        }
//    }
//    
//    if (scrollView.contentOffset.y < 0) {
//        [scrollView setContentOffset:CGPointZero];
//    }
//    
//}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.chackOutDetailModel && self.chackOutDetailModel.shop_goods_info) ? self.chackOutDetailModel.shop_goods_info.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSChackOutOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSChackOutOrderTableViewCell" forIndexPath:indexPath];
    if (self.chackOutDetailModel) {
        if (self.chackOutDetailModel.shop_goods_info && self.chackOutDetailModel.shop_goods_info.count > indexPath.section) {
            GSChackOutOrderShopGoodsInfoModel *shopInfo = self.chackOutDetailModel.shop_goods_info[indexPath.section];
            if (shopInfo.goods_list && shopInfo.goods_list.count > indexPath.row) {
                GSChackOutOrderSingleGoodsModel *singleGoodsModel = shopInfo.goods_list[indexPath.row];
                cell.chackOutOrderType = self.chackOutOrderType;
                cell.singleGoodsModel = singleGoodsModel;
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GSChackOutOrderSectionHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"GSChackOutOrderSectionHeaderCell"];
    if (self.chackOutDetailModel) {
        if (self.chackOutDetailModel.shop_goods_info && self.chackOutDetailModel.shop_goods_info.count > section) {
            header.shopGoodsInfoModel = self.chackOutDetailModel.shop_goods_info[section];
        }
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.chackOutOrderType == GSChackOutOrderTypeGroup) {
        return nil;
    }
    
    GSChackOutOrderSectionFooterCell *footer = [tableView dequeueReusableCellWithIdentifier:@"GSChackOutOrderSectionFooterCell"];
    if (section < self.chackOutDetailModel.shop_goods_info.count) {
        footer.shopGoodsInfoModel = self.chackOutDetailModel.shop_goods_info[section];
        footer.delegate = self;
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.chackOutOrderType == GSChackOutOrderTypeGroup) {
        return 0;
    }
    
    if (self.chackOutDetailModel.shop_goods_info.count > section) {
        GSChackOutOrderShopGoodsInfoModel *shopInfoModel = self.chackOutDetailModel.shop_goods_info[section];
        if ([shopInfoModel.is_integral isEqualToString:@"Y"]) {
            return 105;
        } else {
            return 105;
        }
    } else {
        return 0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.chackOutDetailModel) {
        if (self.chackOutDetailModel.shop_goods_info) {
            if (self.chackOutDetailModel.shop_goods_info.count > section) {
                
                GSChackOutOrderShopGoodsInfoModel *shopInfo = self.chackOutDetailModel.shop_goods_info[section];
                return shopInfo.goods_list.count;
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
