//
//  SucceedPayViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/4/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SucceedPayViewController.h"
#import "SuccedPayCell.h"
#import "MyOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "CarViewController.h"
#import "DispatchGoodsViewController.h"
#import "TopupViewController.h"
#import "SLFRechargeViewController.h"
#import "MyGSViewController.h"
#import "SVProgressHUD.h"
#import "GSGroupOrderViewController.h"
#import "SLFAccountSafe.h"

typedef NS_ENUM(NSInteger, GSOrderPayType) {
    GSOrderPayTypeNotFindGoods = 1,
    GSOrderPayTypeNotFindUser,
    GSOrderPayTypeDefault,
    GSOrderPayTypeAlertMessage = 7,
    GSOrderPayTypeNotFindOrder = 8,
    
};

@interface SucceedPayViewController ()<UIAlertViewDelegate>
{
    UITableView * myTableView;
}


@end

@implementation SucceedPayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    
    _dic =[NSMutableDictionary dictionary];
    _dataDic = [NSMutableDictionary dictionary];
    
    //获取通知中心
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    
    //添加观察者 Observer表示观察者  reciveNotice:表示接收到的消息  name表示再通知中心注册的通知名  object表示可以相应的对象 为nil的话表示所有对象都可以相应
    [center addObserver:self selector:@selector(reciveNotice:) name:@"notice" object:nil];

    
    self.title = @"付款";
    [self createData];
    [self addItem];
    [self createUI];
    

}
-(void)addItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(void)toBack{
    


        
    [AlertTool alertTitle:@"确认要取消吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        NSInteger page = 1;
               [self paySuccessWithOrderType:_orderType ? GSOrderTypeGroupOrder : GSOrderTypeDefaultOrder withPageIndex:page];
    } cancleHandler:^(UIAlertAction *action) {

    } viewController:self];


    
}
-(void)createUIData{
  
    [myTableView reloadData];
    NSString * user_money = [NSString stringWithFormat:@"%@",_dataDic[@"user_money"]];
    
    //支付宝
    NSArray * zhiArray = @[@"payzhifubao",@"支付宝支付"];
    [_dic setObject:zhiArray forKey:@"0"];

    //充值卡
    NSString * chongzhika_money = [NSString stringWithFormat:@"%@",_dataDic[@"rechargeable_card_money"]];
    NSArray * weiArray = @[@"paychongzhika",@"充值卡支付",chongzhika_money];
    [_dic setObject:weiArray forKey:@"1"];

    NSArray * imageArray = @[@"payjinbi",@"可用金币",user_money];
       [_dic setObject:imageArray forKey:@"2"];
    
}
-(void)createData{
    NSString * str = [NSString stringWithFormat:@"order_id=%@,user_id=%@",self.orderId,UserId];
    NSString * en = [str encryptStringWithKey:KEY];
//    NSLog(@"()()()%@",en);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Order/orderPay") parameters:@{@"token":en} success:^(id responseObject) {

        NSString * statusStr = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        GSOrderPayType status = [statusStr integerValue];
        switch (status) {
            case GSOrderPayTypeNotFindGoods: {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf];
            }
                
                break;
                
            case GSOrderPayTypeNotFindUser: {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf];
            }
                
                break;
                
            case GSOrderPayTypeDefault: {
                _dataDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"result"]];
                [self createUIData];
                [myTableView reloadData];
            }
                
                break;
                
            case GSOrderPayTypeAlertMessage: {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf];
            }
                
                break;
                
            case GSOrderPayTypeNotFindOrder: {
                
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf];
                
                MyOrderViewController * order = [[ MyOrderViewController alloc] init];
                UIViewController * target = nil;
                
                
                for (UIViewController * controller  in weakSelf.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[order class]]) {
                        target = controller;
                    }
                }
                
                if (target) {
                    [weakSelf.navigationController popToViewController:target animated:YES];
                }else{
                    [weakSelf.navigationController pushViewController:order animated:YES];
                }

            }
                
                break;
                
            default: {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf];
            }
                break;
        }
        
        
        
    }failure:^(NSError *error) {
        
//        NSLog(@"%@",error);
    }];
    
    
}
-(void)createUI{
    
    myTableView.backgroundColor = MyColor;
    
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    [myTableView registerNib:[UINib nibWithNibName:@"SuccedPayCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
    myTableView.dataSource = self;
    
    [self.view addSubview:myTableView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dic.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   SuccedPayCell  * cell =[tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
    
    if (self.dic.count > 0) {
        NSString * str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSArray * array = [_dic objectForKey:str];
        cell.array = array;
        
        
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    LNLabel * momeyLable = [LNLabel addLabelWithTitle:@"订单总金额：" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:13.0 BackGroundColor:nil];
    [headerView addSubview:momeyLable];
    
    [momeyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        //make.width.equalTo(@100);
        make.height.equalTo(@10);
        make.top.equalTo(headerView.mas_top).offset(15);

    }];
    
     LNLabel * payLable = [LNLabel addLabelWithTitle:nil TitleColor:NewRedColor Font:13.0 BackGroundColor:[UIColor whiteColor]];
     NSString * priceStr = nil;
     //CGSize  size;
   if (self.dataDic.count > 0) {
       NSString * str = [NSString stringWithFormat:@"%@",self.dataDic[@"all_price"]];
       
       CGFloat  price = [str floatValue];
       priceStr = [NSString stringWithFormat:@"%.2f",price];
       NSArray *array = [priceStr componentsSeparatedByString:@"."];
       NSString *formatS = [NSString stringWithFormat:@"%@",array[0]];
       NSMutableAttributedString *formatAS = [[NSMutableAttributedString alloc] initWithString:priceStr];
       [formatAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(formatS.length,priceStr.length - formatAS.length)];
       [formatAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, formatS.length)];
       
       //size  = [LNLabel calculateLableSizeWithString:priceStr AndFont:16.0];
       payLable.attributedText = formatAS;
   }

   
    [headerView addSubview:payLable];
    [payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        //make.width.equalTo(@(size.width));
        make.height.equalTo(@20);
        make.top.equalTo(headerView.mas_top).offset(10);
    }];
    
        UILabel * wire2 = [[UILabel alloc] init];
        wire2.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        [headerView addSubview:wire2];
        [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left);
            make.right.equalTo(headerView.mas_right);
            make.height.equalTo(@1);
            make.top.equalTo(headerView.mas_bottom);
            
        }];

    return headerView;
   }


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        NSUInteger section = 0;
        NSUInteger row = 1;
        NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:row inSection:section];
        SuccedPayCell * cell = [tableView cellForRowAtIndexPath:myindexPath];
        cell.SleteBtn.selected =NO;
        
        NSUInteger section1 = 0;
        NSUInteger row1 = 2;
        NSIndexPath *myindexPath1 = [NSIndexPath indexPathForRow:row1 inSection:section1];
        SuccedPayCell * cell1= [tableView cellForRowAtIndexPath:myindexPath1];
        cell1.SleteBtn.selected =NO;
    }
    if(indexPath.row==1)
    {

        NSUInteger section = 0;
        NSUInteger row = 0;
        NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:row inSection:section];
        SuccedPayCell * cell = [tableView cellForRowAtIndexPath:myindexPath];
        cell.SleteBtn.selected =NO;
        
        NSUInteger section1 = 0;
        NSUInteger row1 = 2;
        NSIndexPath *myindexPath1 = [NSIndexPath indexPathForRow:row1 inSection:section1];
        SuccedPayCell * cell1= [tableView cellForRowAtIndexPath:myindexPath1];
        cell1.SleteBtn.selected =NO;
        

    }
    if(indexPath.row==2)
    {
        NSUInteger section = 0;
        NSUInteger row = 0;
        NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:row inSection:section];
        SuccedPayCell * cell = [tableView cellForRowAtIndexPath:myindexPath];
        cell.SleteBtn.selected =NO;
        
        NSUInteger section1 = 0;
        NSUInteger row1 = 1;
        NSIndexPath *myindexPath1 = [NSIndexPath indexPathForRow:row1 inSection:section1];
        SuccedPayCell * cell1= [tableView cellForRowAtIndexPath:myindexPath1];
        cell1.SleteBtn.selected =NO;
        

    }
    SuccedPayCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.SleteBtn.selected = !cell.SleteBtn.selected;
    cell.SleteBtn.tag = indexPath.row;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    LNButton * btn = [LNButton buttonWithFrame:CGRectMake(80, 50, Width - 160, 45) Type:UIButtonTypeSystem Title:@"确认" Font:20.0 Target:self AndAction:@selector(toPay)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.cornerRadius = 8;
    btn.clipsToBounds = YES;
    btn.tintColor = [UIColor redColor];
    [view addSubview:btn];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100.0;
}
-(void)toPay{
    NSInteger  select = 0;
    NSInteger selectCount = 0;
    
    for (NSInteger i = 0 ; i < 3; i++) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
        
       SuccedPayCell * cell = (SuccedPayCell *)[myTableView cellForRowAtIndexPath:path];
        
        if (cell.SleteBtn.selected && i== 0) {
            select = 1;
        }else if (cell.SleteBtn.selected && i==1){
            select = 2;
        }else if (cell.SleteBtn.selected && i==2){
            select = 3;
        }
        
        if (cell.SleteBtn.selected) {
            selectCount++;
        }

    }

    
    //判断是那种支付方式
    if (select> 0 && selectCount==1) {
        __weak typeof(self) weakSelf = self;
        switch (select) {
                
                //金币支付
            case 3:
                if ((NSNull *)_dataDic != [NSNull null]) {
                    NSString * str = [NSString stringWithFormat:@"user_id=%@,order_sn=%@,total_fee=%@",UserId,_dataDic[@"ordsubject"],_dataDic[@"all_price"]];
                    NSString * enStr = [str encryptStringWithKey:KEY];
//                    NSLog(@"秘钥%@",enStr);
                    //                    @"http://www.ibg100.com/Apiss/index.php?m=Api&c=Order&a=pay"
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                    [SVProgressHUD showWithStatus:@"正在请求数据"];
                    
                    [HttpTool POST:URLDependByBaseURL(@"/Api/Order/pay") parameters:@{@"token":enStr} success:^(id responseObject) {
//                        NSLog(@"%@",responseObject);
                        NSString * dd = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
                        
                        int status = [dd intValue];
                        
                        if (status== 4) {
                            //提示框
                            [AlertTool alertTitle:@"支付成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
#warning  aaaaaaa
                                [weakSelf paySuccessWithOrderType:_orderType ? GSOrderTypeGroupOrder : GSOrderTypeDefaultOrder withPageIndex:2];
                                
                            } viewController:weakSelf];
                            
                            
                        }else if (status== 1){
                            
                            [AlertTool alertTitle:@"金币不足,去充值？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                                TopupViewController * top = [[TopupViewController alloc] init];
                                top.isToPay = YES;
                                top.hidesBottomBarWhenPushed = YES;
                                [weakSelf.navigationController pushViewController:top animated:YES];
                                
                            } cancleHandler:^(UIAlertAction *action) {
                                
                            } viewController:weakSelf];
                            
                        }else if (status== 2){
                            
                            [AlertTool alertMesasge:@"订单不存在" confirmHandler:nil viewController:weakSelf];
                            
                        }else if (status == 7||status == 8){
                            
                            MyOrderViewController * order = [[MyOrderViewController alloc] init];
                            order.informNum = 0;
                            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"order"];
                            
                            [weakSelf.navigationController pushViewController:order animated:YES];
                            
                        }
                        
                        else{
                            
                            [AlertTool alertMesasge:@"支付失败，请重新支付" confirmHandler:nil viewController:weakSelf];
                            
                        }
                        
                        [SVProgressHUD dismiss];
                    } failure:^(NSError *error) {
//                        NSLog(@"%@",error);
                        [AlertTool alertMesasge:@"请检查您的网络" confirmHandler:nil viewController:weakSelf];
                        [SVProgressHUD dismiss];

                    }];
                    
                }
                break;
                //支付宝支付
            case 1:{
                
//                NSLog(@"支付宝支付");
                
                NSArray *array = [[UIApplication sharedApplication] windows];
                UIWindow* win=[array objectAtIndex:0];
                if (win.hidden == YES) {
                    [win setHidden:NO];
                }
                
                [HttpTool toPayWithAliSDKWith:self.dataDic AndViewController:self Isproperty:NO IsToPayForProperty:YES];
            }
                break;
                
            case 2:{
                NSUInteger section1 = 0;
                NSUInteger row1 = 1;
                NSIndexPath *myindexPath1 = [NSIndexPath indexPathForRow:row1 inSection:section1];
                SuccedPayCell * cell1= [myTableView cellForRowAtIndexPath:myindexPath1];
                
                NSString * all_price = [NSString stringWithFormat:@"%@",_dataDic[@"all_price"]];
                if (all_price.integerValue>cell1.moneyLabel.text.integerValue) {
                    [AlertTool alertTitle:@"提示" mesasge:@"余额不足是否充值" preferredStyle:UIAlertControllerStyleActionSheet confirmHandler:^(UIAlertAction *action) {
                        
                        SLFRechargeViewController * slf = [[SLFRechargeViewController alloc]init];
                        [weakSelf.navigationController pushViewController:slf animated:YES];
                        
                    } cancleHandler:^(UIAlertAction *action) {
                        
                    } viewController:self];
                }
                else
                {
                    //进行密码判断
                    
                    NSString *  encryptString;
                    NSString * userId = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]];
                    encryptString = [userId encryptStringWithKey:KEY];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                    [SVProgressHUD showWithStatus:@"正在请求数据"];
                    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GetPasswordTag") parameters:@{@"token":encryptString} success:^(id responseObject) {
                        
                        if ([responseObject[@"result"] isEqualToString:@"1"]) {
                            //弹窗
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            alert.alertViewStyle =  UIAlertViewStyleSecureTextInput;
                            [alert show];
                            
                        }else
                        {
                            //去支付
                            [weakSelf PayWithRecharge];
                        }
                        
                        [SVProgressHUD dismiss];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    
                }
                break;
            }
                break;
            default:
                break;
        }
        
    
    }else if (selectCount > 1){
        [AlertTool alertMesasge:@"只能选择一种支付方式哟！" confirmHandler:nil
                 viewController:self];
        
    }else if (select== 0){
        [AlertTool alertMesasge:@"请选择一种支付方式" confirmHandler:nil viewController:self];
    }
    
}

-(void)PayWithRecharge
{
    if ((NSNull *)_dataDic != [NSNull null]) {
        NSString * str = [NSString stringWithFormat:@"user_id=%@,order_sn=%@,total_fee=%@",UserId,_dataDic[@"ordsubject"],_dataDic[@"all_price"]];
        NSString * enStr = [str encryptStringWithKey:KEY];
//        NSLog(@"秘钥%@",enStr);
        __weak typeof(self) weakSelf = self;
        //                    @"http://www.ibg100.com/Apiss/index.php?m=Api&c=Order&a=pay"
        [HttpTool POST:URLDependByBaseURL(@"/Api/Order/RechargePay") parameters:@{@"token":enStr} success:^(id responseObject) {
            NSString * dd = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            
            
            int status = [dd intValue];
            
            if (status== 4||status== 0) {
                //提示框
                [AlertTool alertTitle:@"支付成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    
                    [weakSelf paySuccessWithOrderType:_orderType ? GSOrderTypeGroupOrder : GSOrderTypeDefaultOrder withPageIndex:2];
                    
                } viewController:weakSelf];
                
            }
            else if (status == 1000) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该商品不支持充值卡支付" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else  if (status == 5){
                [AlertTool alertMesasge:@"支付失败，请重新支付" confirmHandler:nil viewController:weakSelf];
                
            }
            
        } failure:^(NSError *error) {
            
            [AlertTool alertMesasge:@"请检查您的网络" confirmHandler:nil viewController:weakSelf];
            
        }];
        
    }

}

#pragma mark ======================= alertView的代理方法 ===================
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]){
        UITextField *tf=[alertView textFieldAtIndex:0];//获得输入框
        NSString * secret =tf.text;//获得值
        
        //判断密码是否正确
        NSString *  encryptString;
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,pay_password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],secret];
        encryptString = [userId encryptStringWithKey:KEY];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在请求数据"];
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/verifyPayPassword") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"0"]) {
                //去支付
                [weakSelf PayWithRecharge];
               
            }else
            {
                [alertView textFieldAtIndex:0].text = @"";
                //弹窗
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码输入错误请重新输入" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle =  UIAlertViewStyleSecureTextInput;
                [alert show];
                

            }
            
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
       
    }

}
//跳到哪个页面的哪一项
- (void)paySuccessWithOrderType:(GSOrderType)orderType withPageIndex:(NSInteger) pageIndex{
    switch (orderType) {
        case GSOrderTypeDefaultOrder:
        {
            self.tabBarController.selectedIndex = 3;
            UINavigationController *nav = [[self.tabBarController viewControllers] objectAtIndex:3];
            MyOrderViewController * order = [[MyOrderViewController alloc] init];
            order.informNum = pageIndex;
            [order.navigationController setNavigationBarHidden:YES animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
            [nav pushViewController:order animated:YES];

            if (![self.navigationController isEqual:nav]) {
               [self.navigationController popToRootViewControllerAnimated:NO];
            }
            
            
        }
            break;
            
        case GSOrderTypeGroupOrder:
        {
            self.tabBarController.selectedIndex = 3;
            UINavigationController *nav = [[self.tabBarController viewControllers] objectAtIndex:3];
            GSGroupOrderViewController *order = [[GSGroupOrderViewController alloc] init];
            [nav pushViewController:order animated:YES];
            
//            [self.navigationController popToRootViewControllerAnimated:NO];
            if (![self.navigationController isEqual:nav]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }

        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reciveNotice:(NSNotification *)notification{
    
//    NSLog(@"收到消息啦!!!");
    NSUInteger section1 = 0;
    NSUInteger row1 = 1;
    NSIndexPath *myindexPath1 = [NSIndexPath indexPathForRow:row1 inSection:section1];
    SuccedPayCell * cell1= [myTableView cellForRowAtIndexPath:myindexPath1];
    cell1.moneyLabel.text =[NSString stringWithFormat:@"%.2ld",cell1.moneyLabel.text.integerValue+ [[notification.userInfo objectForKey:@"text"] integerValue] ];

}

@end
