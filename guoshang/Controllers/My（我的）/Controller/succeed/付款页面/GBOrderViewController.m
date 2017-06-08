//
//  GBOrderViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GBOrderViewController.h"
#import "TotalModel.h"
#import "GoodsModel.h"
#import "addressModel.h"
#import "MyOrderViewController.h"
#import "SucceedPayViewController.h"
#import "SVProgressHUD.h"
@interface GBOrderViewController ()

@end

@implementation GBOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGB = YES;
}

-(void)createDataMoney{
    
    __weak typeof(self) weakSelf = self;
    
    if (UserId) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_group_t getDataGroup = dispatch_group_create();
    //获取配送方式
    dispatch_group_enter(getDataGroup);
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shipping/ShippingList") parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            NSArray *arr = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in arr) {
                [weakSelf.shippingArr addObject:dic];
            }
        }
        dispatch_group_leave(getDataGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(getDataGroup);
    }];

    NSString * tokenStr = [NSString stringWithFormat:@"user_id=%@,type=4",UserId];
    NSString * encryptString = [tokenStr encryptStringWithKey:KEY];
    dispatch_group_enter(getDataGroup);
        //NSLog(@"%@",@{@"token":encryptString} );
        __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Order&a=checkOutExchange") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"]isEqualToNumber:@1]) {
            NSString *title = [responseObject objectForKey:@"message"];
            [AlertTool alertTitle:title mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            } cancleHandler:nil viewController:weakSelf];
        }
        if ([responseObject[@"status"]isEqualToNumber:@3]) {
            NSMutableDictionary * rootDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"result"]];
            //请求商品数据
            NSArray * goodArray = [NSArray arrayWithArray:rootDic[@"shop_goods_info"]];
            
            
            for (NSDictionary * dic in goodArray) {
                
                NSMutableArray *goodsModelArr = [[NSMutableArray alloc] initWithCapacity:0];
                
                NSMutableDictionary *list = [[NSMutableDictionary alloc]initWithCapacity:0];
                NSArray *arr = [dic objectForKey:@"goods_list"];
                for (NSDictionary *dic2 in arr) {
                    
                    GoodsModel * model = [[GoodsModel alloc] initWithDictionary:dic2 error:nil];
                    [goodsModelArr addObject:model];
                }
                
                [list setObject:goodsModelArr forKey:@"goods_list"];
                
                [list setObject:[dic objectForKey:@"shop_id"] forKey:@"shop_id"];
                [list setObject:[dic objectForKey:@"shop_title"] forKey:@"shop_title"];
                
                [weakSelf.dataArray addObject:list];
            }
            NSDictionary *totalDic = [rootDic objectForKey:@"total"];
//            TotalModel * total = [[TotalModel alloc] initWithDictionary:totalDic error:nil];
            TotalModel *total = [[TotalModel alloc]initWithContentDic:totalDic];
            [weakSelf.totalArray addObject:total];
            NSDictionary  * value = [rootDic objectForKey:@"address"];
            
            
            if ((NSNull *)value == [NSNull null]) {
                
            }else{
                addressModel * address = [[addressModel alloc] initWithDictionary:rootDic[@"address"] error:nil];
                weakSelf.addressStr = address.address_id;
                [weakSelf.addressArray addObject:address];
                
            }
            
            
        }
        dispatch_group_leave(getDataGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(getDataGroup);

    }];
        
        dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf createHeaderAndFooter];
            [weakSelf settingData];
            [weakSelf.myTableView reloadData];
            
        });
        

        
    });
    }
}



-(void)toConfim{
    
    NSString *shipping_id_str;
    NSString *shop_id_str;
    
    for (int i = 0; i < [self.shiping_id_arr allKeys].count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSString *shipstr =  [self.shiping_id_arr objectForKey:str];
        if (shipping_id_str.length == 0) {
            shipping_id_str = [NSString stringWithFormat:@"%@#",shipstr];
        }else {
            shipping_id_str = [shipping_id_str stringByAppendingFormat:@"#%@",shipstr];
        }
        
    }
    
    for (int i = 0; i < [self.shop_id_arr allKeys].count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i+1000];
        NSString *shopstr =  [self.shop_id_arr objectForKey:str];
        if (shop_id_str.length == 0) {
            shop_id_str = [NSString stringWithFormat:@"%@#",shopstr];
        }else {
            shop_id_str = [shop_id_str stringByAppendingFormat:@"#%@",shopstr];
        }
    }
    
//    NSLog(@"%@",shipping_id_str);
//    NSLog(@"%@",shop_id_str);
    
    //从数组中取数据让后传给订单成功页面
    NSString * tokenStr = [NSString stringWithFormat:@"user_id=%@,flow_type=4,address_id=%@,shipping_id=%@",UserId,self.addressStr,shipping_id_str];
    NSString * encrStr = [tokenStr encryptStringWithKey:KEY];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在生成订单..."];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Order&a=gbdone") parameters:@{@"token":encrStr} success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        int status = [str intValue];
    
        if (status == 5) {
            
            [AlertTool alertTitle:@"支付成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                MyOrderViewController * order = [[MyOrderViewController alloc] init];
                order.informNum = 2;
                [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
                
                [weakSelf.navigationController pushViewController:order animated:YES];

            } cancleHandler:^(UIAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } viewController:weakSelf];
            
            
        }else if(status == 4){
            
            [AlertTool alertMesasge:@"当前国币不足，请购买商品兑换国币" confirmHandler:nil viewController:weakSelf];
            
        }else if (status == 8){
            
            [AlertTool alertTitle:@"需支付国币商品的运费" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                SucceedPayViewController * succeed = [[SucceedPayViewController alloc] init];
                succeed.orderId =responseObject[@"result"][@"order_id"];
                succeed.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:succeed animated:YES];
                
            } cancleHandler:^(UIAlertAction *action) {
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
            } viewController:weakSelf];
        }else if (status == 1) {
            [AlertTool alertTitle:responseObject[@"message"] mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                
            } cancleHandler:^(UIAlertAction *action) {
                
            } viewController:weakSelf];
 
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"生成订单失败,请稍后再试!"];

    }];
    

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
