//
//  OrderPayViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "OrderPayViewController.h"
#import "SuccedPayCell.h"
#import "MyOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "CarViewController.h"
#import "DispatchGoodsViewController.h"
#import "TopupViewController.h"

@interface OrderPayViewController ()

{
    UITableView * myTableView;
}


@end

@implementation OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    
    _dic =[NSMutableDictionary dictionary];
    _dataDic = [NSMutableDictionary dictionary];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    } cancleHandler:^(UIAlertAction *action) {
        
    } viewController:self];
    
    
    
}
-(void)createUIData{
    
    [myTableView reloadData];
    NSString * user_money = [NSString stringWithFormat:@"%@",_dataDic[@"user_money"]];
    NSArray * imageArray = @[@"jinbi",@"可用金币:",user_money];
    
    [_dic setObject:imageArray forKey:@"0"];
    
    //支付宝
    NSArray * zhiArray = @[@"zhifubao1",@"支付宝支付"];
    [_dic setObject:zhiArray forKey:@"1"];
    
    
    //    //微信
    //    NSArray * weiArray = @[@"weixin",@"微信支付"];
    //    [_dic setObject:weiArray forKey:@"2"];
    
    
    
    
    
    
}
-(void)createData{
    NSString * str = [NSString stringWithFormat:@"order_id=%@,shop_id=%@",self.orderId,GS_Business_Shop_id];
    NSString * en = [str encryptStringWithKey:KEY];
    NSLog(@"()()()%@",en);
    
    [HttpTool POST:URLDependByBaseURL(@"Api/Repository/PayPurchaseOrder") parameters:@{@"token":en} success:^(id responseObject) {
        NSString * statusStr = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        NSInteger status = [statusStr integerValue];
        if (status == 3) {
            _dataDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"result"]];
            [self createUIData];
            [myTableView reloadData];
            
        }else if (status == 7){
            
            [AlertTool alertMesasge:@"部分商品已下架，请重新购买！" confirmHandler:nil viewController:self];
            
        }else if (status == 8){
            
            MyOrderViewController * order = [[ MyOrderViewController alloc] init];
            UIViewController * target = nil;
            
            
            for (UIViewController * controller  in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[order class]]) {
                    target = controller;
                }
            }
            
            if (target) {
                [self.navigationController popToViewController:target animated:YES];
                
                
            }else{
                
                
                [self.navigationController pushViewController:order animated:YES];
            }
        }
        
        
    }failure:^(NSError *error) {
        
        NSLog(@"%@",error);
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
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 130)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"40"]];
    [headerView addSubview:imageView];
    
    [imageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerView.mas_right).offset(-20);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(headerView.mas_top).offset(15);
        
    }];
    
    LNLabel * oderLabel = [LNLabel addLabelWithTitle:@"恭喜订单提交成功!" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:16.0 BackGroundColor:nil];
    [headerView addSubview:oderLabel];
    [oderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(20);
        make.right.equalTo(imageView.mas_left).offset(-10);
        make.height.equalTo(@20);
        make.top.equalTo(headerView.mas_top).offset(10);
        
    }];
    
    
    LNLabel * oderPayLabel = [LNLabel addLabelWithTitle:@"请使用以下支付方式进行支付" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:16.0 BackGroundColor:nil];
    [headerView addSubview:oderPayLabel];
    [oderPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(20);
        make.right.equalTo(imageView.mas_left).offset(-10);
        make.height.equalTo(@20);
        make.top.equalTo(oderLabel.mas_bottom).offset(2);
        
    }];
    
    UILabel * wire = [[UILabel alloc] init];
    wire.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [headerView addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(oderPayLabel.mas_bottom).offset(15);
        
    }];
    
    LNLabel * momeyLable = [LNLabel addLabelWithTitle:@"订单总金额：" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:15.0 BackGroundColor:nil];
    [headerView addSubview:momeyLable];
    
    [momeyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.top.equalTo(wire.mas_bottom).offset(15);
        
    }];
    
    LNLabel * payLable = [LNLabel addLabelWithTitle:nil TitleColor:NewRedColor Font:15.0 BackGroundColor:[UIColor whiteColor]];
    NSString * priceStr;
    CGSize  size;
    if (self.dataDic.count > 0) {
        NSString * str = [NSString stringWithFormat:@"%@",self.dataDic[@"all_price"]];
        CGFloat  price = [str floatValue];
        priceStr = [NSString stringWithFormat:@"%.2f",price];
        size  = [LNLabel calculateLableSizeWithString:priceStr AndFont:16.0];
        payLable.text = priceStr;
        
    }else{
        //       NSString * str = [NSString stringWithFormat:@"%@",self.dataDic[@"all_price"]];
        size  = [LNLabel calculateLableSizeWithString:@"10000" AndFont:16.0];
        
    }
    
    [headerView addSubview:payLable];
    [payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(momeyLable.mas_right);
        make.width.equalTo(@(size.width));
        make.height.equalTo(@20);
        make.top.equalTo(momeyLable.mas_top);
    }];
    
    LNLabel * countLable = [LNLabel addLabelWithTitle:@"商品数：" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:15.0 BackGroundColor:[UIColor whiteColor]];
    [headerView addSubview:countLable];
    
    [countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payLable.mas_right).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
        make.top.equalTo(wire.mas_bottom).offset(15);
        
    }];
    
    
    if (self.dataDic.count > 0) {
        NSString * str = [NSString stringWithFormat:@"%@",self.dataDic[@"order_number"]];
        CGSize  size = [LNLabel calculateLableSizeWithString:str AndFont:16.0];
        LNLabel * count = [LNLabel addLabelWithTitle:str TitleColor:NewRedColor Font:15.0 BackGroundColor:[UIColor whiteColor]];
        [headerView addSubview:count];
        [count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countLable.mas_right);
            make.width.equalTo(@(size.width));
            make.height.equalTo(@20);
            make.top.equalTo(momeyLable.mas_top);
        }];
        
    }
    
    UILabel * wire1 = [[UILabel alloc] init];
    wire1.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [headerView addSubview:wire1];
    [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(payLable.mas_bottom).offset(15);
        
    }];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = MyColor;
    [headerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@15);
        make.top.equalTo(wire1.mas_bottom);
        
    }];
    
    UILabel * wire2 = [[UILabel alloc] init];
    wire2.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [headerView addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(view.mas_bottom);
        
    }];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SuccedPayCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.SleteBtn.selected = !cell.SleteBtn.selected;
    cell.SleteBtn.tag = indexPath.row;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 100)];
    view.backgroundColor = MyColor;
    LNButton * btn = [LNButton buttonWithFrame:CGRectMake(30, 30, Width - 60, 45) Type:UIButtonTypeSystem Title:@"确认" Font:20.0 Target:self AndAction:@selector(toPay)];
    btn.backgroundColor = [UIColor colorWithRed:231/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
    btn.tintColor = [UIColor whiteColor];
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
    NSLog(@"$$$$$$$%ld",select);
    NSLog(@"^^^^^^^^%ld",selectCount);
    
    //判断是那种支付方式
    if (select> 0 &&selectCount==1) {
        switch (select) {
                
                //金币支付
            case 1:{
                if ((NSNull *)_dataDic != [NSNull null]) {
                    NSString * str = [NSString stringWithFormat:@"user_id=%@,order_sn=%@,total_fee=%@",UserId,_dataDic[@"ordsubject"],_dataDic[@"all_price"]];
                    NSString * enStr = [str encryptStringWithKey:KEY];
                    NSLog(@"秘钥%@",enStr);
                    [HttpTool POST:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=Order&a=pay" parameters:@{@"token":enStr} success:^(id responseObject) {
                        
                        NSString * dd = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
                        
                        int status = [dd intValue];
                        
                        if (status== 4) {
                            //提示框
                            [AlertTool alertTitle:@"支付成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                                
                                MyOrderViewController * order = [[MyOrderViewController alloc] init];
                                order.informNum = 2;
                                [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"order"];
                                [self.navigationController pushViewController:order animated:YES];
                                
                            } viewController:self];
                            
                            
                        }else if (status== 1){
                            
                            [AlertTool alertTitle:@"金币不足,去充值？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                                TopupViewController * top = [[TopupViewController alloc] init];
                                top.isToPay = YES;
                                top.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:top animated:YES];
                                
                            } cancleHandler:^(UIAlertAction *action) {
                                
                            } viewController:self];
                            
                        }else if (status== 2){
                            
                            [AlertTool alertMesasge:@"订单存在" confirmHandler:nil viewController:self];
                            
                        }else if (status == 7||status == 8){
                            
                            MyOrderViewController * order = [[MyOrderViewController alloc] init];
                            order.informNum = 0;
                            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"order"];
                            
                            [self.navigationController pushViewController:order animated:YES];
                            
                        }
                        
                        else{
                            
                            [AlertTool alertMesasge:@"支付失败，请重新支付" confirmHandler:nil viewController:self];
                            
                        }
                        
                        
                    } failure:^(NSError *error) {
                        
                        [AlertTool alertMesasge:@"请检查您的网络" confirmHandler:nil viewController:self];
                        
                    }];
                    
                }
                break;
                //支付宝支付
            case 2:{
                
                NSLog(@"支付宝支付");
                
                NSArray *array = [[UIApplication sharedApplication] windows];
                UIWindow* win=[array objectAtIndex:0];
                if (win.hidden == YES) {
                    [win setHidden:NO];
                }
                
                [HttpTool toPayWithAliSDKWith:self.dataDic AndViewController:self Isproperty:NO IsToPayForProperty:NO];
                
                
                
            }
                break;
                
            case 3:{
                
            }
                break;
            default:
                break;
            }
                
        }
        
    }else if (selectCount > 1){
        [AlertTool alertMesasge:@"只能选择一种支付方式哟！" confirmHandler:nil
                 viewController:self];
        
    }else if (select== 0){
        [AlertTool alertMesasge:@"请选择一种支付方式" confirmHandler:nil viewController:self];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
