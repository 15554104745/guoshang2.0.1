//
//  GSMyOrderPayController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyOrderPayController.h"
#import "RequestManager.h"
#import "GSBusinessUserInfoModel.h"
#import "TopupViewController.h"
#import "SVProgressHUD.h"
#import "GoodsInfoViewController.h"
#import "GSBusinessHomeViewController.h"
#import "GSOrderInfoViewController.h"
#import "GSBusinessMineViewController.h"
#import "GSCustomOrderViewController.h"
#import "GSOrderInfoViewController.h"
@interface GSMyOrderPayController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContainsH;

@property (weak, nonatomic) IBOutlet UIView *orderView;
//产品总额
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
//产品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
//国币另个按钮
@property (weak, nonatomic) IBOutlet UIButton *CornBtn;
//国币余额
@property (weak, nonatomic) IBOutlet UILabel *cornMoney;
//国币按钮
@property (weak, nonatomic) IBOutlet UIButton *cornSelectBtn;
//支付按钮
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic,assign) CGFloat selectIndex;

@property (nonatomic,strong) GSBusinessUserInfoModel *propertyModel;
@property (nonatomic,weak) UIButton *selectBtn;
@end

@implementation GSMyOrderPayController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self defaultSetting];
    [self createNav];
    [self getPropertyData];
  }

-(void)defaultSetting{
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    self.goodsCountLabel.text =self.all_goods_count;
     self.orderMoneyLabel.text = self.all_goods_price;
//    是否显示订单提交成功的提示
    if (!self.isOrder) {
    self.orderContainsH.constant = 0;
    }

   
   
}
- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"付款";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
    
    
}
- (void)toBack{
        __weak typeof(self) weakSelf = self;
    
  [AlertTool alertTitle:@"提示" mesasge:@"确认要取消吗" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
      [weakSelf paySuccessWithOrderType:GSOrderTypeDefaultOrder withPageIndex:1];
  } cancleHandler:^(UIAlertAction *action) {
      
  } viewController:self];
   
}
//设置跳转

- (void)paySuccessWithOrderType:(GSOrderType)orderType withPageIndex:(NSInteger) pageIndex{
    switch (orderType) {
        case GSOrderTypeDefaultOrder:
        {
            self.tabBarController.selectedIndex = 3;
            UINavigationController *nav = [[self.tabBarController viewControllers] objectAtIndex:3];
            
            GSOrderInfoViewController * order = [[GSOrderInfoViewController alloc] init];
            order.informNum = pageIndex;
            [order.navigationController setNavigationBarHidden:YES animated:YES];
            [nav pushViewController:order animated:YES];
            
            if (![self.navigationController isEqual:nav]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 获取资产数据
- (void)getPropertyData {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
        NSString * encryptString = [userId encryptStringWithKey:KEY];
//        NSLog(@"%@",encryptString);
        __weak typeof(self) weakSelf = self;
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/myprofile") parameters:@{@"token":encryptString} completed:^(id responseObject, NSError *error) {
            
            if ([responseObject[@"status"] isEqualToNumber:@(0)]) {
                
            weakSelf.propertyModel = [GSBusinessUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            }
        }];
    }
    
}

-(void)setPropertyModel:(GSBusinessUserInfoModel *)propertyModel{
    _propertyModel = propertyModel;
    
   self.cornMoney.text =propertyModel.user_money_org;

   }


//金币支付或者是支付宝 支付的选择
- (IBAction)PayBtnAction:(UIButton *)sender {
  
    switch (sender.tag-100) {
        case 100:
        {
            
            if([self.all_goods_price integerValue] > [_propertyModel.user_money_org integerValue]){
                [AlertTool alertTitle:@"金币不足,去充值？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    
                    TopupViewController * top = [[TopupViewController alloc] init];
                    top.isToPay = YES;
                    top.hidesBottomBarWhenPushed = YES;
                    top.navigationController.navigationBarHidden= NO;
                    [self.navigationController pushViewController:top animated:YES];
                    
                } cancleHandler:^(UIAlertAction *action) {
                    
                } viewController:self];

                return;
            }
            
            self.payBtn.selected = NO;
            self.cornSelectBtn.selected = YES;
    }
            break;
            
        case 101:{
//            选择支付宝
            self.cornSelectBtn.selected = NO;
            self.payBtn.selected = YES;
           
          }
           break;
        default:
            break;
    }

     self.selectIndex = sender.tag;
}
//付款事件
- (IBAction)payMoney:(UIButton *)sender {
    
    NSString *payType = @"";
    
    if(self.selectIndex ==200){
        payType = @"coin";
       
        
        
    }else if(self.selectIndex ==201){
        
         payType = @"alipay";
        
    }else{
        [AlertTool alertMesasge:@"请选择支付方式" confirmHandler:nil viewController:self];

    }
    
    NSString * encryptString;
    
    __weak typeof(self) weakSelf = self;
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@,pay_method=%@",self.shopID,self.orderID,payType];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    [SVProgressHUD showWithStatus:@"正在付款"];
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/PayPurchaseOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
//             支付宝支付
            if ([responseObject[@"status"] isEqualToString:@"0"] && [payType isEqualToString:@"alipay"]) {

                    [SVProgressHUD dismiss];
                    NSDictionary *result = responseObject[@"result"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"trade_no"] = result[@"order_sn"];
                    dic[@"ordsubject"]= result[@"order_sn"];
                    dic[@"all_price"]= weakSelf.all_goods_price;
                    dic[@"notify_url"]= result[@"notify_url"];
                    [HttpTool toPayWithAliSDKWith:dic AndViewController:weakSelf Isproperty:NO IsToPayForProperty:YES];
                    return ;
//
                }
//             金币支付
            else if ([responseObject[@"status"] isEqualToString:@"0"] && [payType isEqualToString:@"coin"]){

                    [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                        [weakSelf paySuccessWithOrderType:GSOrderTypeDefaultOrder withPageIndex:2];
                        
                    } viewController:weakSelf];

                }
//        其他
            else if(![responseObject[@"status"] isEqualToString:@"0"] && [payType isEqualToString:@"coin"]){
                    
                    [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                        
                        [weakSelf paySuccessWithOrderType:GSOrderTypeDefaultOrder withPageIndex:0];
                    } viewController:weakSelf];
                   
                }
           [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
    
    

}

- (void)pusheVC{
      __weak typeof(self) weakSelf = self;
    if (weakSelf.navigationController.viewControllers.count>=5) {
        GSBusinessMineViewController *minVC = self.navigationController.viewControllers[1];
        [weakSelf.navigationController popToViewController:minVC animated:NO];

        GSOrderInfoViewController *infoVC = [[GSOrderInfoViewController alloc] init];
            infoVC.informNum = 2;
            [minVC.navigationController pushViewController:infoVC animated:YES];
    }else{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
}

@end
