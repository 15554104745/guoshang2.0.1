//
//  SpecialSaleViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SpecialSaleViewController.h"

@interface SpecialSaleViewController ()

@end

@implementation SpecialSaleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"特卖商城";
    
    self.siftButton.hidden = YES;
    [self creteItem];
    self.url = URLDependByBaseURL(@"?m=Api&c=Category&a=category&is_give_integral=1");
    [self allDataInit];
}


-(void)creteItem{
//    UIBarButtonItem * shareItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"gengduo1"] highlightedImage:nil target:self action:@selector(toShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * menuItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"gengduo1"] highlightedImage:nil target:self action:@selector(toMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuItem;

}
-(void)toShare{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"国商易购，http://m.ibg100.com/index.php?m=default&c=salegoods&a=index"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToTencent,UMShareToSina]
                                       delegate:self];
}




-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    /*  UMSResponseCodeSuccess            = 200,        //成功
     UMSREsponseCodeTokenInvalid       = 400,        //授权用户token错误
     UMSResponseCodeBaned              = 505,        //用户被封禁
     UMSResponseCodeFaild              = 510,        //发送失败（由于内容不符合要求或者其他原因）
     UMSResponseCodeArgumentsError     = 522,        //参数错误,提供的参数不符合要求
     UMSResponseCodeEmptyContent       = 5007,       //发送内容为空
     UMSResponseCodeShareRepeated      = 5016,       //分享内容重复
     UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
     UMSResponseCodeAccessTokenExpired = 5027,       //token过期
     UMSResponseCodeNetworkError       = 5050,       //网络错误
     UMSResponseCodeGetProfileFailed   = 5051,       //获取账户失败
     UMSResponseCodeCancel             = 5052,        //用户取消授权
     UMSResponseCodeNotLogin           = 5053,       //用户没有登录
     UMSResponseCodeNoApiAuthority     = 100031      //QQ空间应用没有在QQ互联平台上申请上传图片到相册的权限
     */
//        NSLog(@"分享结果:%d",response.responseCode);
    if (response.responseCode == UMSResponseCodeSuccess) {
    
        [AlertTool alertMesasge:@"分享成功" confirmHandler:^(UIAlertAction *action) {
            
           
        } viewController:self];
        
        
    }else if(response.responseCode == UMSResponseCodeCancel){
        
        [AlertTool alertMesasge:@"取消分享" confirmHandler:^(UIAlertAction *action) {
            
        } viewController:self];   
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
