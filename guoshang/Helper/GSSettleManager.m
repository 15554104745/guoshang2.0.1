//
//  GSSettleManagre.m
//  guoshang
//
//  Created by Rechied on 16/9/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSettleManager.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"
#import "SucceedPayViewController.h"
#import "CarViewController.h"
#import "MyOrderViewController.h"
#import "GSMyOrderPayController.h"
#import "WKProgressHUD.h"
@implementation GSSettleManager

+ (void)settleGuoBiOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController {
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"?m=Api&c=Order&a=gbdone") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:nil animated:YES];
        if (responseObject) {
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            int status = [str intValue];
            
            if (status == 5) {
                
                [AlertTool alertTitle:@"支付成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    MyOrderViewController * order = [[MyOrderViewController alloc] init];
                    order.informNum = 2;
                    [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
                    
                    [viewController.navigationController pushViewController:order animated:YES];
                    
                } cancleHandler:^(UIAlertAction *action) {
                    [viewController.navigationController popViewControllerAnimated:YES];
                } viewController:viewController];
                
                
            }else if(status == 4){
                
                [AlertTool alertMesasge:@"当前国币不足，请购买商品兑换国币" confirmHandler:nil viewController:viewController];
                
            }else if (status == 8){
                
                [AlertTool alertTitle:@"需支付国币商品的运费" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    SucceedPayViewController * succeed = [[SucceedPayViewController alloc] init];
                    succeed.orderId =responseObject[@"result"][@"order_id"];
                    succeed.hidesBottomBarWhenPushed = YES;
                    [viewController.navigationController pushViewController:succeed animated:YES];
                    
                } cancleHandler:^(UIAlertAction *action) {
                    
                    [viewController.navigationController popToRootViewControllerAnimated:YES];
                    
                } viewController:viewController];
            }else if (status == 1) {
                [AlertTool alertTitle:responseObject[@"message"] mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    
                } cancleHandler:^(UIAlertAction *action) {
                    
                } viewController:viewController];
                
            }
        }
    }];
}

+ (void)settleDefaultOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Order/new_order_done") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        if ([responseObject[@"message"] isEqualToString:@"易购商品订单提交成功"]) {
            SucceedPayViewController   * succeed = [[SucceedPayViewController alloc] init];
            succeed.orderId = responseObject[@"result"][@"order_id"];
            succeed.navigationItem.hidesBackButton = YES;
            [viewController.navigationController pushViewController:succeed animated:YES];
        }else if((int)responseObject[@"status"] == 4){
            
            [AlertTool alertMesasge:@"提交失败，请重新提交" confirmHandler:nil viewController:viewController];
            //[SVProgressHUD showErrorWithStatus:@"提交订单失败,请稍后再试!"];
            
        }else if([responseObject[@"status"] isEqualToNumber:@8]){
            
            [AlertTool alertMesasge:@"存在失效商品,提交订单失败" confirmHandler:nil viewController:viewController];
            //[SVProgressHUD showErrorWithStatus:@"提交订单失败,请稍后再试!"];
            
        }else if([responseObject[@"status"] isEqualToNumber:@9]){
            
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:viewController];
            //[SVProgressHUD showErrorWithStatus:@"提交订单失败,请稍后再试!"];
            
        }else if ([responseObject[@"status"] isEqualToNumber:@7]){
            //调到购物车
            CarViewController * car = [[CarViewController alloc] init];
            UIViewController * target = nil;
            
            for (UIViewController * controller  in viewController.navigationController.viewControllers) {
                if ([controller isKindOfClass:[car class]]) {
                    target = controller;
                }
            }
            if (target) {
                [viewController.navigationController popToViewController:target animated:YES];
            }else{
                [viewController.navigationController pushViewController:car animated:YES];
            }
        }
    }];
    
}

+ (void)settleBusinessOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController {
     WKProgressHUD *hud = [WKProgressHUD showInView:viewController.view withText:@"订单提交中" animated:YES];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Repository/CreatePurchaseOrder") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            
            GSMyOrderPayController   * myOrderPay = [[GSMyOrderPayController alloc] init];
            
            //                myOrderPay.navigationItem.hidesBackButton = YES;
            myOrderPay.shopID = [[NSString alloc] initWithString:params[@"shop_id"]];
            myOrderPay.orderID = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"purchase_order_id"]];
            
            //                myOrderPay.all_goods_price = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"order_amount"]];
            myOrderPay.all_goods_price = [NSString stringWithFormat:@"%.2f",[responseObject[@"result"][@"order_amount"] floatValue]];
            myOrderPay.all_goods_count =[NSString stringWithFormat:@"%@", responseObject[@"result"][@"goods_num"]];
            myOrderPay.isOrder = YES;
            [hud dismiss:YES];
            [viewController.navigationController pushViewController:myOrderPay animated:YES];
        }else if((int)responseObject[@"status"] == 4){
                [hud dismiss:YES];
            [AlertTool alertMesasge:@"提交失败，请重新提交" confirmHandler:nil viewController:viewController];
            //[SVProgressHUD showErrorWithStatus:@"提交订单失败,请稍后再试!"];
            
        }else if ([responseObject[@"status"] isEqualToNumber:@7]){
            //调到购物车
                [hud dismiss:YES];
            CarViewController * car = [[CarViewController alloc] init];
            UIViewController * target = nil;
            
            
            for (UIViewController * controller  in viewController.navigationController.viewControllers) {
                if ([controller isKindOfClass:[car class]]) {
                    target = controller;
                }
            }
            if (target) {
                
                [viewController.navigationController popToViewController:target animated:YES];
                
            }else{
                
                [viewController.navigationController pushViewController:car animated:YES];
            }
        }
    }];
}

@end
