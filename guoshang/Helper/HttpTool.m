//
//  HttpTool.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "MyOrderViewController.h"
#import "MyPropertyViewController.h"
#import "SLFRechargeViewController.h"
#import "GSOrderInfoViewController.h"
#import "SucceedPayViewController.h"
#import "GSMyOrderPayController.h"
#import "GSBusinessTabBarController.h"
#import "GSBusinessHomeViewController.h"
@implementation HttpTool


+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure

{
    
    //post请求
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    
    session.responseSerializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
  
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


+(void)GET:(NSString *)URLString parameters:(id)parameters
   success:(void (^)(id responseObject))success
   failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
session.responseSerializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            [SVProgressHUD dismiss];
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
    
    
}
+(void)toPayWithAliSDKWith:(NSDictionary *)rootDic AndViewController:(UIViewController *)controller Isproperty:(BOOL)isProperty IsToPayForProperty:(BOOL) isToPayForProperty{
    
    __block BOOL isPr = isProperty;
    __block BOOL isGSPay;
    NSString *partner = @"2088811345355803";
    NSString *seller = Alipay_seller_ID;
    NSString * privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMDKA/IkIsqVTCsC9A4jxTxokDjjmn4jrIlp7pMzFdSTYFxFtu3ksDsrWZGNmE/0V3AxB4Z0Jy8bKURGkjptCCdsjHR1+XHUu9krhlexbBWZbI1uIl4ACpXYQWRWiS+fRDN42ig/6FuN8eJ+o43yJJINOQUGIw8aDb56mMnycC2PAgMBAAECgYBnAYjqL3SHWQ3BTWqow2P2yseEHdfF3bmqEfdunrTjR3sM0hLTOIUQmDDbHBRtY9f0Eb47kIP/HzwFRs+KeAcKWmUAlkkBO26tbt7L+7Gje/Ig7PUsf+Ia3cN7nVphhRuztphU1XnjNnkjZ1j4jOJgZY0OCR14PLWERnYIkLELgQJBAPnJ4Ec07QMP7spW4CcX6W9/42tErwVsVWbnRspd8e6H1jfiba7yVAR2BdPgSCGFyBuX9d+KgYXa6l2ZMYsiGLcCQQDFlUmlQHUcpzrvVnUQzx6Nx7kMlro65/wDaFFchCZ5fEGDjjEx7ZoppkBxeLOrk4VHrtYFlVOLF0YTkKbNAMnpAkEA4f14MVQ7/uJCW8Qfxp7Grv8YpSsd4h0yYwhprpsyUGmLMUJlk7tgsiyJdzjaaaHc+sIQTG/GYXE/SvFXtpZhnwJBAINGYAr6m5TxCzgvslH7uuoqc6mIj61Jqug8rCoS51k6FHEqzUbF/fKEMjbyIjXyKtBoumw1Pa+hQ/8F0b1NM9kCQQCzbYve56CXUFdlXSXpWq+edoQoJATbTO97Ucq2ohUzZb8mlDLZcRW90IyBxZq05Ok9Z0bw3HIJlBhgovWsI2a9";
    
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        
        [AlertTool alertMesasge:@"缺少partner或者seller或者私钥" confirmHandler:nil viewController:controller];
        return ;
    }
    
    Order * order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
//    NSLog(@"****%@",rootDic);
    
    /**
     *  支付价格需要改变
     */
    order.tradeNO = rootDic[@"trade_no"];
    order.productName = rootDic[@"ordsubject"];

//    order.amount =   @"0.01";//价格
    order.amount =   rootDic[@"all_price"];//价格

    
    //order.amount =   @"0.01";//价格
    
    order.notifyURL = rootDic[@"notify_url"];
    NSLog(@"****%@",order.notifyURL);
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";//支付类型
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"ibgguoshang";
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    NSString *signedString = [signer signString:orderSpec];
    //   // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    
    NSString *orderString = nil;
    if (signedString != nil) {
    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            NSString * str = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            NSInteger  status = [str integerValue];
                        //支付成功
            if (status == 9000 ) {
                
                if ([controller isKindOfClass:[SucceedPayViewController class]]) {
                    SucceedPayViewController *successPay = (SucceedPayViewController *)controller;
                    if (successPay.orderType == GSOrderTypeGroupOrder) {
                        [successPay paySuccessWithOrderType:successPay.orderType withPageIndex:2];
                        
                        return;
                    }
                }
                if([controller isKindOfClass:NSClassFromString(@"GSMyOrderPayController")]){
                    isGSPay = YES;
                    GSMyOrderPayController *vc =(GSMyOrderPayController*)controller;
                    [vc pusheVC];
                }

                
                //创建一个消息对象
                NSNotification * notice =[NSNotification notificationWithName:@"notice" object:nil userInfo:@{@"text":order.amount}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                if (isPr == YES&&isToPayForProperty == NO) {
                    MyPropertyViewController * pro = [[MyPropertyViewController alloc] init];
                    [controller.navigationController pushViewController:pro animated:YES];
                    
                    
                }else if (isToPayForProperty== YES && isPr == YES){
                    
                    MyOrderViewController * order = [[MyOrderViewController alloc] init];
                    order.informNum = 1;
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"order"];
                    
                    [controller.navigationController pushViewController:order animated:YES];
                    
                    
                }else if (isPr == NO &&isToPayForProperty == NO)
                {
                    
                    SLFRechargeViewController * pro = [[SLFRechargeViewController alloc] init];
                    pro.type = 3;
                    [controller.navigationController pushViewController:pro animated:YES];
                    
                }else if(isPr == NO &&isToPayForProperty == YES){
                    
                    if (isGSPay == YES) {
                        GSOrderInfoViewController * order = [[GSOrderInfoViewController alloc] init];
                        order.informNum = 2;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"order"];
                        
                        [controller.navigationController pushViewController:order animated:YES];
                    }else {
                        MyOrderViewController * order = [[MyOrderViewController alloc] init];
                        order.informNum = 2;
                        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
                        [controller.navigationController pushViewController:order animated:YES];
                    }
                    
                    
                }else{
                    
                    
                    MyOrderViewController * order = [[MyOrderViewController alloc] init];
                    order.informNum = 2;
                    [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
                    [controller.navigationController pushViewController:order animated:YES];
                }

                
            }else if (status == 6001){
                __block int num = 0;
                __block int sum = 0;
                [AlertTool alertTitle:@"确定要取消吗?" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    if ([controller isKindOfClass:[SucceedPayViewController class]]) {
                        
                        SucceedPayViewController *successPay = (SucceedPayViewController *)controller;
                        if (successPay.orderType == GSOrderTypeGroupOrder) {
                            [successPay paySuccessWithOrderType:successPay.orderType withPageIndex:1];
                            
                            return;
                        }
                    }

                    //判断取消支付调到那个页面
                    for (UIViewController * view in controller.navigationController.childViewControllers) {
                        
                        if ([view isKindOfClass:[MyOrderViewController class]]) {
                            [controller.navigationController popViewControllerAnimated:YES];
                            sum++;
                            return ;
                            
                        }else if ([view isKindOfClass:[SLFRechargeViewController class]]){
                            //创建一个消息对象
                            NSNotification * buyRecord =[NSNotification notificationWithName:@"buyRecord" object:nil userInfo:@{@"text":@3}];
                            //发送消息
                            [[NSNotificationCenter defaultCenter]postNotification:buyRecord];
                            
                            [controller.navigationController popViewControllerAnimated:YES];
                            num++;
                            return;
                            
                        }else if ([view isKindOfClass:[GSOrderInfoViewController class]]){
                            [controller.navigationController popViewControllerAnimated:YES];
                            num++;
                            return;
                        }else if ([view isKindOfClass:[GSBusinessHomeViewController class]]){
                            [controller.navigationController popViewControllerAnimated:YES];

                        
//                            GSBusinessTabBarController *businessTabbar = [[GSBusinessTabBarController alloc] init];
//                            businessTabbar.selectedIndex = 3;
//                            UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:businessTabbar];
//                            mainNav.navigationBarHidden = YES;
//                            
//                            [UIView beginAnimations:@"trans" context:nil];
//                            [UIView setAnimationDuration:0.5];
//                            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication].delegate window] cache:NO];
//                            [[UIApplication sharedApplication].delegate window].rootViewController = mainNav;
//                            [UIView commitAnimations];
                            
                            
                            GSOrderInfoViewController * order = [[GSOrderInfoViewController alloc] init];
                            order.informNum = 1;
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"order"];
                            
                            [controller.navigationController pushViewController:order animated:YES];
                            
                            return;
                        }
                        else{
                            num++;
                            
                        }
                    }
                   
                    
                    if (sum == 0&&isPr == NO) {
                        
                        MyOrderViewController * order = [[MyOrderViewController alloc] init];
                        order.informNum = 1;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"order"];
                        
                        [controller.navigationController pushViewController:order animated:YES];
                        
                    }
                    else{
                        
                        [controller.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                } viewController:controller];
                
                
            }else if (status == 4000){
                [AlertTool alertMesasge:@"支付失败" confirmHandler:nil viewController:controller];
            }else if (status == 6002){
                
                
                [AlertTool alertMesasge:@"网络连接出错" confirmHandler:nil viewController:controller];
                
            }else{
                
//                NSLog(@"正在处理");
                
            }
            
            
//            NSLog(@"#####reslut = %@",resultDic);
            
            
        }];
        
        
        
    }
    
    
    
    
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cache"];
}
+(void)clearAllCaches{
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
//            NSLog(@"clear caches error: %@", error);
        } else {
//            NSLog(@"clear caches ok");
        }
    }
    
}
@end
