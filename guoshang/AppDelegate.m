//
//  AppDelegate.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "AppDelegate.h"
#import "GSTabbarController.h"
#import "GSGuideView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JPUSHService.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "LNcheckVersion.h"
#import "UMSocial.h"
#import "GSBusinessTabBarController.h"
//包含微信分享的头文件
#import "UMSocialWechatHandler.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialQQHandler.h"
#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"
static NSString *appKey = @"cf6c2f593567658016dea766";
//static BOOL isProduction = FALSE;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [NSThread sleepForTimeInterval:1.5 ];
    [_window makeKeyAndVisible];
    
    if (usName!=nil) {
        [self gotoHomePage];
        
    }else{
        
        
        [self gotoGuidePage];
    
    }
    
   //注册友盟
    [self setShare];
  
    //获取网络状态
    [self getNetworkStatus];
    
    
    [self changeItemWord];
    
    
    //检查版本
    [self checkVersion];
    
    
    //极光推送
    [self gotoJGPush:launchOptions];
    
    
    return YES;
}
-(void)setShare{
    
    
  [UMSocialData setAppKey:appKey];//@"5732d7a1e0f55a7994001d20"
    
    
 //设置微信分享的APPID
    [UMSocialWechatHandler setWXAppId:@"wxad68c725c59a0bc9" appSecret:@"b632ab1c69ebcea81c02d877da6ab29b" url:@"http://www.ibg100.com"];
    
    //设置QQ
   [UMSocialQQHandler setQQWithAppId:@"1105370307" appKey:@"10Juuu4Dt7uLISLn" url:@"http://www.ibg100.com"];
   
    
    //设置新浪
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"secret:@"04b48b094faeb16683c32669824ebdad" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    
    [UMSocialData openLog:YES];
    
}
-(void)gotoJGPush:(NSDictionary *)launchOptions{
    

    //打包的时候需要修改为生产环境
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:nil apsForProduction:YES advertisingIdentifier:nil];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //注册推送
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    //获取自定义消息
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
     [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

}




//
//-(void)networkDidReceiveMessage:(NSNotification *)notification{
//    
//    NSDictionary * userInfo = [notification userInfo];
//    
//    NSString *content = [userInfo valueForKey:@"content"];//获取推送的内容
//    
//    
//    NSLog(@"获取的自定义的消息是:%@",content);
// 
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];//获取用户自定义参数
//    
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];//根据自定义key获取自定义的value
//
//}

//获取动态的deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    //把获取的deviceToken发给极光
//    NSLog(@"获取的token%@",deviceToken);
    
    [JPUSHService  registerDeviceToken:deviceToken];
    
}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
//      NSLog(@"didReceiveUsefff = %@",userInfo);
//    NSString * typeStr = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
//    NSLog(@"类型%@",typeStr);
//    /**
//     * 判断APP是不是在前台运行
//     */
//    //在前台
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        UIViewController * notitionView = [self getCurrentVC];
//        //检测更新
//        if ([typeStr isEqualToString:@"1"]) {
//            
//            [self checkVersion];
//            
//            //商品详情
//        }else if ([typeStr isEqualToString:@"2"]){
//            
//            [AlertTool alertTitle:@"商品推荐" mesasge:@"有最新的商品了哟！便宜哟！赶快去看看！" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
//                GoodsShowViewController * show = [[GoodsShowViewController alloc] init];
//                show.goodId = [NSString stringWithFormat:@"%@",userInfo[@"txt"]];
//                show.hidesBottomBarWhenPushed = YES;
//                [notitionView.navigationController pushViewController:show animated:YES];
//            } cancleHandler:^(UIAlertAction *action) {
//                
//            } viewController:notitionView];
//            
//            
//        }else if ([typeStr isEqualToString:@"3"]){
//            
//            [AlertTool alertMesasge:[NSString stringWithFormat:@"%@",userInfo[@"type"]] confirmHandler:^(UIAlertAction *action) {
//                
//            } viewController:notitionView];
//            
//        }
//        
//        //在后台 或者没有启动App
//    }else{
//        
//        
//        //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//        //    NSString *content = [aps valueForKey:@"alert"];//推送显示的内容
//        
//        
//        //检测更新
//        if ([typeStr isEqualToString:@"1"]) {
//            
//            [self checkVersion];
//            
//            //商品详情
//        }else if ([typeStr isEqualToString:@"2"]){
//            UIViewController * notitionView = [self getCurrentVC];
//            GoodsShowViewController * show = [[GoodsShowViewController alloc] init];
//            show.goodId = [NSString stringWithFormat:@"%@",userInfo[@"txt"]];
//            show.hidesBottomBarWhenPushed = YES;
//            [notitionView.navigationController pushViewController:show animated:YES];
//        }else if ([typeStr isEqualToString:@"3"]){
//            
//        }
//        
//        
//        application.applicationIconBadgeNumber = 0;
//        [JPUSHService setBadge:0];
//        [JPUSHService handleRemoteNotification:userInfo];
//       
//    }
//
//
//    
//}
// 极光处理借到的推送信息  APP 接收到通知的信息对通信信息进行处理
//IOS 7.0 remote Notification
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
//    NSLog(@"didReceiveUse = %@",userInfo);
    NSString * typeStr = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
//    NSLog(@"类型%@",typeStr);
    /**
     * 判断APP是不是在前台运行
     */
    //在前台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
         UIViewController * notitionView = [self getCurrentVC];
        //检测更新
        if ([typeStr isEqualToString:@"1"]) {
            
            [self checkVersion];
            
            //商品详情
        }else if ([typeStr isEqualToString:@"2"]){
        
            [AlertTool alertTitle:@"商品推荐" mesasge:@"有最新的商品了哟！便宜哟！赶快去看看！" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                GoodsDetailViewController * show = [GoodsDetailViewController createGoodsDetailView];
                show.goodsId = [NSString stringWithFormat:@"%@",userInfo[@"txt"]];
                show.hidesBottomBarWhenPushed = YES;
                [notitionView.navigationController pushViewController:show animated:YES];
            } cancleHandler:^(UIAlertAction *action) {
               
            } viewController:notitionView];
          
            
        }else if ([typeStr isEqualToString:@"3"]){
            
            [AlertTool alertMesasge:[NSString stringWithFormat:@"%@",userInfo[@"type"]] confirmHandler:^(UIAlertAction *action) {

            } viewController:notitionView];
            
        }
      
        //在后台 或者没有启动App
    }else{
        
        
        //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
        //    NSString *content = [aps valueForKey:@"alert"];//推送显示的内容
   
        
        //检测更新
        if ([typeStr isEqualToString:@"1"]) {

            [self checkVersion];
            
        //商品详情
        }else if ([typeStr isEqualToString:@"2"]){
            UIViewController * notitionView = [self getCurrentVC];
            GoodsDetailViewController * show = [GoodsDetailViewController createGoodsDetailView];
            show.goodsId = [NSString stringWithFormat:@"%@",userInfo[@"txt"]];
            show.hidesBottomBarWhenPushed = YES;
            [notitionView.navigationController pushViewController:show animated:YES];
        }else if ([typeStr isEqualToString:@"3"]){
            
        }
        
        
      
       
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       // Check result of your operation and call completion block with the result
                       completionHandler(UIBackgroundFetchResultNewData);
                   });
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [JPUSHService handleRemoteNotification:userInfo];
  

}

//注册APNS 失败的调用的方法，失败原因
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    
    NSLog(@"did fail To Register For Remote Notifications With Error :%@",error);
}


-(void)checkVersion{
    LNcheckVersion * viesion = [[LNcheckVersion alloc] init];
    viesion.isStart = YES;
    [viesion showAlertView];
}
-(void)changeItemWord{
    
    //更改整体导航栏的文字
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName :[UIColor whiteColor]};
    [[UINavigationBar appearance]setTitleTextAttributes:dic];
}

-(void)gotoGuidePage{
    
    GSGuideView * view = [[GSGuideView alloc] init];
    [self.window setRootViewController:view];
}
-(void)gotoHomePage{
 
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GSTabbarController alloc] init]];
        nav.navigationBarHidden = YES;
        [self.window setRootViewController:nav];
    
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == false) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"#####result = %@",resultDic);
            }];
        }
        
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
            
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//                NSLog(@"result = %@",resultDic);
            }];
        }

    }
    
        return YES;
}




-(void)getNetworkStatus{
    
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"连接出错，请检查网络,给您带来的不便，敬请谅解。" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
[manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    switch (status)
    {
            
        case AFNetworkReachabilityStatusUnknown: // 未知网络
//            NSLog(@"未知网络");
            [al dismissWithClickedButtonIndex:0 animated:YES];
            
            break;
        case AFNetworkReachabilityStatusNotReachable://// 没有网络(断网)
        {
              [al show];
        }
          
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//            NSLog(@"手机自带网络");
            [al dismissWithClickedButtonIndex:0 animated:YES];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//            NSLog(@"WIFI");
            [al dismissWithClickedButtonIndex:0 animated:YES];
            break;
    }

    
}];
    
    
    [manager startMonitoring];
}
-(UIViewController *)getCurrentVC{
    
    UIViewController * result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponer = nil;
    
    UIViewController * appRootVc = window.rootViewController;
    if (appRootVc.presentedViewController) {
        nextResponer = appRootVc.presentedViewController;
    }else{
        
        UIView * forntView = [[window subviews]objectAtIndex:0];
        nextResponer = [forntView nextResponder];
    }
    
    
    if ([nextResponer isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabbar = (UITabBarController *)nextResponer;
        UIViewController * nav = (UIViewController *)tabbar.viewControllers[tabbar.selectedIndex];
        result  = nav.childViewControllers.lastObject;
    }else if([nextResponer isKindOfClass:[UINavigationController class]]){
        UIViewController * anv = (UIViewController *)nextResponer;
        result = anv.childViewControllers.lastObject;
    }else{
        
        result = nextResponer;
    }
    
    return result;
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    NSOperationQueue *cacheInQueue = [[NSOperationQueue alloc] init];
    
    [cacheInQueue cancelAllOperations];
    
    [HttpTool clearAllCaches];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//APP进入后台，设置通知角标
- (void)applicationDidEnterBackground:(UIApplication *)application {
 
}

//APP即将进入后台的时候设置通知的角标，显示通知的个数
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    //取消所有的本地通知
    [application cancelAllLocalNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //通知限时抢购刷新数据
    NSNotification *notification =[NSNotification notificationWithName:@"LimiteUpdateData" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
