//
//  GSActivityManager.m
//  guoshang
//
//  Created by Rechied on 2016/11/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSActivityManager.h"
#import "RequestManager.h"
#import "GSGoodsDetailModel.h"
#import "GSGoodsDetailInfoViewController.h"
#import "MBProgressHUD.h"
#import "GSActivityWebViewController.h"

@implementation GSActivityManager
+ (void)pushToActivityWithActiviryURL:(NSString *)url navigationController:(UINavigationController *)navigationController {
    if ([url containsString:@"m=default&c=goods&a=index&id="]) {
    NSString *goods_id = [[url componentsSeparatedByString:@"m=default&c=goods&a=index&id="] lastObject];
    [self changeToGoodsDetialWithGoods_id:goods_id navigationController:navigationController hudView:nil];
    } else {
        GSActivityWebViewController *webViewController = [[GSActivityWebViewController alloc] init];
        webViewController.url = url;
        [navigationController pushViewController:webViewController animated:YES];
    }
}

+ (void)changeToGoodsDetialWithGoods_id:(NSString *)goods_id navigationController:(UINavigationController *)navigationController hudView:(UIView *)hudView {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:hudView];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Goods/view") parameters:UserId ? @{@"goods_id":goods_id,@"user_id":UserId} : @{@"goods_id":goods_id} completed:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:hudView animated:YES];
        GSGoodsDetailModel *goodsDetailModel = [GSGoodsDetailModel mj_objectWithKeyValues:responseObject[@"result"]];
        GSGoodsDetailInfoViewController *goodsDetailViewController = [[GSGoodsDetailInfoViewController alloc] init];
        goodsDetailViewController.goodsDetailModel = goodsDetailModel;
        [navigationController pushViewController:goodsDetailViewController animated:YES];
    }];
}
@end
