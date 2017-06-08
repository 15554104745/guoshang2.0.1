//
//  MoneyViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyCell.h"
#import "GoodsModel.h"
#import "TotalModel.h"
#import "addressModel.h"
#import "SucceedPayViewController.h"
#import "MyAddressViewController.h"
#import "CarViewController.h"
#import "SVProgressHUD.h"
#import "MoneyButton.h"
#import "UIImageView+WebCache.h"

@interface MoneyViewController () {
//    MoneyButton *selectButton;
    NSString *_shipping_id;
    UIView *buttonView;
    

    
}
@property(nonatomic, strong)NSMutableDictionary *buttonSlected;

@end

static NSString *tabHeaderFotter = @"headerIdentifier";

@implementation MoneyViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (self.dataArray.count > 0) {
        
        [self.dataArray removeAllObjects];
    }
    
    if (self.totalArray.count > 0) {
        [self.totalArray removeAllObjects];
    }
    if (self.addressArray.count > 0) {
        [self.addressArray removeAllObjects];
    }
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self createDataMoney];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isGB = NO;
    /*在设置的时候将用户的收货地址等存在本地，若本地没有就从服务器中取 服务器没有就让用户去设置
     */
    self.title = @"确认订单";
    self.view.backgroundColor = MyColor;
    self.dataArray = [NSMutableArray array];
    self.totalArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    [self createTabelView];
    [self createAccountBar];
}

-(void)createDataMoney{
    
    if (self.shippingArr.count > 0) {
        [self.shippingArr removeAllObjects];
    }
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
            
            
            NSDictionary *dic = @{@"user_id":UserId,
                                  @"rec_id":self.tokenStr};
            //获取订单接口
//            NSLog(@"%@",[dic paramsDictionaryAddSaltString]);
            dispatch_group_enter(getDataGroup);
            [HttpTool POST:URLDependByBaseURL(@"/Api/Order/new_checkOut") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
                
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
                        [list setObject:[dic objectForKey:@"shoplogo"] forKey:@"shoplogo"];
                        
                        [self.dataArray addObject:list];
                    }
                    
//                    TotalModel * total = [[TotalModel alloc] initWithDictionary:rootDic[@"total"] error:nil];
                    TotalModel *total = [[TotalModel alloc]initWithContentDic:rootDic[@"total"]];
                    [weakSelf.totalArray addObject:total];
                    NSDictionary  * value = [rootDic objectForKey:@"address"];
                    
                    
                    if ((NSNull *)value == [NSNull null]) {
                        
                    }else{
                        addressModel * address = [[addressModel alloc] initWithDictionary:rootDic[@"address"] error:nil];
                        weakSelf.addressStr = address.address_id;
                        [weakSelf.addressArray addObject:address];
                        
                    }
                    
                }else if ([responseObject[@"status"]isEqualToNumber:@3])
                {
                 [AlertTool alertMesasge:@"存在失效商品,提交订单失败" confirmHandler:nil viewController:weakSelf];
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
#pragma mark - 头视图尾视图
-(void)createHeaderAndFooter{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 80)];
    headerView.backgroundColor = MyColor;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 80)];
    
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAddress)];
    [view addGestureRecognizer:tap];
    UILabel * userLabel = [self addLableWithSuperView:view Font:15 Text:@"" TextColor:[UIColor grayColor]];
    userLabel.tag = 80;
    CGFloat size = [LNLabel calculateMoreLabelSizeWithString:@"欧阳春月 15100313116" AndWith:Width - 30 AndFont:16];
    
    [userLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(5);
        make.top.equalTo(view.mas_top).offset(5);
        make.right.equalTo(view.mas_right).offset(-30);
        make.height.equalTo(@(size));
    }];
    
    UILabel * addressLabel = [self addLableWithSuperView:view Font:15 Text:@"" TextColor:[UIColor grayColor]];
    addressLabel.tag = 81;
    addressLabel.numberOfLines = 0;
    [addressLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(5);
        make.top.equalTo(userLabel.mas_bottom).offset(5);
        make.right.equalTo(view.mas_right).offset(-30);
        make.bottom.equalTo(view.mas_bottom).offset(-2);
    }];
    
    UIImageView * addIcon = [[UIImageView alloc] init];
    addIcon.image = [UIImage imageNamed:@"gengduo"];
    [view addSubview:addIcon];
    [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(20);
        make.height.equalTo(@16);
        make.width.equalTo(@9);
        
    }];
    UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, Width, 10)];
    imagev.image = [UIImage imageNamed:@"26435235-0459-4FC8-BFE8-812955057811"];
    [headerView addSubview:imagev];
    //    UIImageView * imageView = [[UIImageView alloc] init];
    //    imageView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    //    [view addSubview:imageView];
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(view.mas_left).offset(5);
    //        make.bottom.equalTo(view.mas_bottom);
    //        make.right.equalTo(view.mas_right).offset(-5);
    //        make.height.equalTo(@1);
    //    }];
    
    [headerView addSubview:view];
    
    self.myTableView.tableHeaderView = headerView;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView * subFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Width, 60)];
    subFooterView.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:subFooterView];
    
    UILabel * GBlabel = [self addLableWithSuperView:footerView Font:13 Text:@"可获" TextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
    
    [GBlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(20);
        make.top.equalTo(footerView.mas_top);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    UIImageView * GBIcon =[[UIImageView alloc] init];
    GBIcon.image = [UIImage imageNamed:@"guobi"];
    [footerView addSubview:GBIcon];
    [GBIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(GBlabel.mas_right);
        make.centerY.equalTo(GBlabel.mas_centerY);
        make.width.equalTo(@23);
        make.height.equalTo(@26.5);
    }];
    
    //        NSString * str = [NSString stringWithFormat:@"%@  个",totalModel.g_ price];
    UILabel * allPrice = [self addLableWithSuperView:subFooterView Font:15 Text:nil TextColor:[UIColor colorWithRed:227/255.0 green:65/255.0 blue:64/255.0 alpha:1.0]];
    allPrice.tag = 93;
    allPrice.textAlignment = NSTextAlignmentRight;
    [allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView.mas_right).offset(-20);
        make.top.equalTo(GBlabel.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        
    }];
    
    
    
    self.myTableView.tableFooterView = footerView;
}

-(void)settingData{
    UILabel * userLable = [self.view viewWithTag:80];
    UILabel * addLable = [self.view viewWithTag:81];
    if (_addressArray.count > 0) {
        addressModel * addModel = _addressArray[0];
        NSString * userStr = [NSString stringWithFormat:@"收件人：%@ %@",addModel.consignee,addModel.tel];
        NSString * addStr = [NSString stringWithFormat:@"收货地址:%@,%@,%@", addModel.province,addModel.city,addModel.address];
        
        userLable.text = userStr;
        
        addLable.text = addStr;
        addLable.hidden = NO;
    }else{
        userLable.text = @"没有收货地址，请添加收货地址";
        addLable.hidden = YES;
    }
    if (_totalArray.count > 0) {
        TotalModel * model = _totalArray[0];
        UILabel * priceLabel = [self.view viewWithTag:90];
        UILabel * fieLabel = [self.view viewWithTag:91];
        NSString * str =[NSString stringWithFormat:@"%@",model.shipping_price];
        CGFloat  shipping = [str  floatValue];
        if (self.isGB) {
            priceLabel.text = [NSString stringWithFormat:@"兑换:%.2f个",[model.total_exchange_integral floatValue]];
            fieLabel.text =[NSString stringWithFormat:@"(运费：%.2f)",shipping];
        }else{
            //            NSString *subStr = [model.goods_price substringFromIndex:1];           is_selectParams = 1;
            priceLabel.text =[NSString stringWithFormat:@"合计：%@",model.goods_price];
            fieLabel.text =[NSString stringWithFormat:@"(含运费：0.00)"];
        }
        
        UILabel * cionLabel = [self.view viewWithTag:93];
        NSInteger gCount = model.total_give_integral.integerValue ;
        NSString * cionStr = @"0 个";
        if (gCount > 0) {
            cionStr = [NSString stringWithFormat:@"%@  个",model.g_price];
        }
        cionLabel.text = cionStr;
    }
}

-(void)createAccountBar{
    
    __weak typeof (self) weakSelf = self;
    
    UIView * accontView = [[UIView alloc] init];
    accontView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accontView];
    [accontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view.mas_width);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    
    UIButton * buyButton = [[UIButton alloc] init];
    buyButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    [buyButton setTitle:@"去结算" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(toConfim) forControlEvents:UIControlEventTouchUpInside];
    [accontView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(accontView.mas_bottom);
        make.right.equalTo(accontView.mas_right);
        make.width.equalTo(@93);
        make.height.equalTo(@50);
    }];
    
    
    UIImageView *iamge = [[UIImageView alloc]init];
    iamge.image = [UIImage imageNamed:@"xuxian"];
    [accontView addSubview:iamge];
    [iamge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyButton.mas_top);
        make.left.equalTo(accontView.mas_left);
        make.right.equalTo(buyButton.mas_left);
        make.height.equalTo(@1);
    }];
    
    
    UILabel * pricelabel = [[UILabel alloc] init];
    pricelabel.tag = 90;
    pricelabel.textAlignment = NSTextAlignmentRight;
    pricelabel.textColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    pricelabel.font = [UIFont systemFontOfSize:15];
    [accontView addSubview:pricelabel];
    [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-5);
        make.top.equalTo(buyButton.mas_top).offset(10);
        make.height.equalTo(@10);
        make.left.equalTo(accontView.mas_left).offset(10);
    }];
    
    
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.tag = 91;
    freightLabel.textAlignment = NSTextAlignmentRight;
    freightLabel.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
    freightLabel.font = [UIFont systemFontOfSize:15];
    [accontView addSubview:freightLabel];
    [freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-5);
        make.top.equalTo(pricelabel.mas_bottom).offset(5);
        make.left.equalTo(accontView.mas_left).offset(10);
        make.height.equalTo(pricelabel);
    }];
    
    
}

//跳转到设置地址页面
-(void)toAddress{
    //    [self toPopToOrder];
    MyAddressViewController * address = [[MyAddressViewController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
    
}
//支付页面 提交订单接口

-(void)toConfim{
    
    if (self.addressStr.length > 2) {
        
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
        
//        NSLog(@"%@",shipping_id_str);
//        NSLog(@"%@",shop_id_str);
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在生成订单..."];
        
        SucceedPayViewController   * succeed = [[SucceedPayViewController alloc] init];
        NSDictionary *dic = @{@"user_id":UserId,
                              @"shipping_id":shipping_id_str,
                              @"shop_id":shop_id_str,
                              @"address_id":self.addressStr,
                              @"flow_type":@"0",
                              @"rec_id":self.tokenStr};
        [HttpTool POST:URLDependByBaseURL(@"/Api/Order/new_order_done") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            if ([responseObject[@"message"] isEqualToString:@"易购商品订单提交成功"]) {
                [SVProgressHUD dismiss];
                succeed.orderId = responseObject[@"result"][@"order_id"];
                succeed.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:succeed animated:YES];
            }else if((int)responseObject[@"status"] == 4){
                
                [AlertTool alertMesasge:@"提交失败，请重新提交" confirmHandler:nil viewController:self];
                [SVProgressHUD showErrorWithStatus:@"提交订单失败,请稍后再试!"];
                
            }else if((int)responseObject[@"status"] == 8){
                
                [AlertTool alertMesasge:@"存在失效商品,提交订单失败" confirmHandler:nil viewController:self];
                
            }else if ([responseObject[@"status"] isEqualToNumber:@7]){
                //调到购物车
                CarViewController * car = [[CarViewController alloc] init];
                UIViewController * target = nil;
                
                
                for (UIViewController * controller  in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[car class]]) {
                        target = controller;
                    }
                }
                if (target) {
                    
                    [self.navigationController popToViewController:target animated:YES];
                    
                }else{
                    
                    [self.navigationController pushViewController:car animated:YES];
                }
            }
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"生成订单失败,请稍后再试!"];
        }];
        
        
    }else{
        [AlertTool alertTitle:@"没有收货地址，请添加收货地址" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            MyAddressViewController * my = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:my  animated:YES];
            
        } viewController:self];
        
    }
    
}


-(void) createTabelView{
    
    self.myTableView.backgroundColor = MyColor;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-49-20-44) style:UITableViewStyleGrouped];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MoneyCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.myTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:tabHeaderFotter];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
}

#pragma mark -- UITableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    NSArray *arr = [dic objectForKey:@"goods_list"];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = [dic objectForKey:@"goods_list"];
    GoodsModel * model = arr[indexPath.row];
    MoneyCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = model;
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    NSDictionary *dic = self.dataArray[section];
//    if ([[dic objectForKey:@"shop_id"]integerValue] == 0) {
    
    if (self.isGB) {
        return 0.01;
    }else {
        return 30;
    }
//
//    return 0.01;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell  让颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//每组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.dataArray[section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tabHeaderFotter];
    [[headerView.contentView subviews]enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"shoplogo"]] placeholderImage:[UIImage imageNamed:@"shopuser"]];
    [headerView.contentView addSubview:imageView];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(headerView.contentView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    label.text =  [dic objectForKey:@"shop_title"];
    [headerView.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.centerY.equalTo(headerView.contentView.mas_centerY);
    }];
    
    return headerView;
}
//每组尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
        
        UIView* backview = [[UIView alloc]initWithFrame:CGRectZero];
        backview.backgroundColor = [UIColor whiteColor];
        buttonView = backview;
        
        UILabel *deliverStylelab = [self addLableWithSuperView:backview Font:13 Text:@"配送方式" TextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
        [backview addSubview:deliverStylelab];
        [deliverStylelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backview.mas_left).offset(20);
            make.top.equalTo(backview.mas_top);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            
        }];
    
    //判断是否是国币
    if (!self.isGB) {
    //判断是否是国商自营
        
        for (int i = 0; i < self.shippingArr.count; i++) {
            
            MoneyButton *buttton = [[MoneyButton alloc]init];
            buttton.layer.borderWidth = 1;
            [buttton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            buttton.layer.borderColor = [[UIColor redColor] CGColor];
            buttton.layer.cornerRadius = 5;
            buttton.titleLabel.font = [UIFont systemFontOfSize:12];
            buttton.clipsToBounds = YES;
            [backview addSubview:buttton];
            buttton.index = section;
            buttton.orignIndex = i; //记录button在每一行的位置
            NSDictionary *dic1 = [self.shippingArr objectAtIndex:i];
            [buttton setTitle:[dic1 objectForKey:@"shipping_name"] forState:UIControlStateNormal];
            [buttton setTitle:[dic1 objectForKey:@"shipping_name"] forState:UIControlStateSelected];
            [buttton addTarget:self action:@selector(deliverStyButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //国商快递
            if ( [[dic objectForKey:@"shop_id"]integerValue] == 0 && [[dic1 objectForKey:@"shipping_id"] integerValue] == 10) {
                buttton.frame = CGRectMake(210, deliverStylelab.frame.origin.y, 80, 25);
                buttton.tag = section + 100;
//                defaultShippingID = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"shipping_id"]];
//                defaultShopID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]];
                
            //上门自提
            }else if ([[dic1 objectForKey:@"shipping_id"] integerValue] == 9){
                buttton.tag = section + 1000;
                buttton.frame = CGRectMake(100, deliverStylelab.frame.origin.y, 80, 25);
                buttton.backgroundColor = [UIColor redColor];
                [buttton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [self.shiping_id_arr setObject:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"shipping_id"]] forKey:[NSString stringWithFormat:@"%ld",section]];
                [self.shop_id_arr setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]] forKey:[NSString stringWithFormat:@"%ld",section +1000]];
            }
            
            //判断button的选中状态
            if ([self.buttonSlected allKeys].count > 0) {
                NSString *str = [self.buttonSlected objectForKey:[NSString stringWithFormat:@"%ld",buttton.tag]];
                if ([str isEqualToString:@"1"]) {
                    buttton.backgroundColor = [UIColor redColor];
                    [buttton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else if ([str isEqualToString:@"0"]) {
                    buttton.backgroundColor = [UIColor whiteColor];
                    [buttton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
            }
        }
        
        return backview;

   //设置国币默认配送方式为快递
    } else {
        
        GoodsModel *model = [[dic objectForKey:@"goods_list"] firstObject];
        if ([model.shipping_price floatValue] == 0) {
            for (int i = 0; i < self.shippingArr.count; i++) {
                NSDictionary *dic1 = [self.shippingArr objectAtIndex:i];
                if ([[dic1 objectForKey:@"shipping_id"] integerValue] == 9) {
                    [self.shiping_id_arr setObject:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"shipping_id"]] forKey:[NSString stringWithFormat:@"%ld",section]];
                    [self.shop_id_arr setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]] forKey:[NSString stringWithFormat:@"%ld",section +1000]];
                }
            }
        } else {
            for (int i = 0; i < self.shippingArr.count; i++) {
                NSDictionary *dic1 = [self.shippingArr objectAtIndex:i];
                if ([[dic1 objectForKey:@"shipping_id"] integerValue] == 10) {
                    [self.shiping_id_arr setObject:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"shipping_id"]] forKey:[NSString stringWithFormat:@"%ld",section]];
                    [self.shop_id_arr setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]] forKey:[NSString stringWithFormat:@"%ld",section +1000]];
                }
                
            }
        }
    }
    return nil;
}

//配送方式
- (void)deliverStyButton:(MoneyButton *)sender {
    
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor redColor];

    NSInteger section = sender.index;
    
    NSDictionary *dic = self.dataArray[section];
    NSDictionary *dic1 = [self.shippingArr objectAtIndex:sender.orignIndex];
    
    [self.shiping_id_arr setObject:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"shipping_id"]] forKey:[NSString stringWithFormat:@"%ld",section]];
    [self.shop_id_arr setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]] forKey:[NSString stringWithFormat:@"%ld",section +1000]];
    
    NSInteger tag = sender.tag;
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",sender.tag];
    [self.buttonSlected setObject:@"1" forKey:buttonTag];
    
    //重新结算价格
    TotalModel * model = _totalArray[0];
    NSString *subStr = [model.goods_price substringFromIndex:1];
    CGFloat price = [subStr floatValue];                                    //返回的总的价格
    CGFloat freight = [model.shipping_price floatValue];                    //返回的总的邮费
    
    UILabel * priceLabel = [self.view viewWithTag:90];                      //总价
    UILabel * freightLabel = [self.view viewWithTag:91];                    //运费
    
    if (tag == section+100) {
        
        MoneyButton *button = (MoneyButton *)[sender.superview viewWithTag:section+1000];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        NSString *buttonTag2 = [NSString stringWithFormat:@"%ld",section+1000];
        [self.buttonSlected setObject:@"0" forKey:buttonTag2];
        
        priceLabel.text =[NSString stringWithFormat:@"合计：￥%.2f",price + freight];
        freightLabel.text =[NSString stringWithFormat:@"(含运费：%.2f)",freight];

    }
    else if (tag == section+1000) {
        MoneyButton *button = (MoneyButton *)[sender.superview viewWithTag:section + 100];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        NSString *buttonTag2 = [NSString stringWithFormat:@"%ld",section+100];
        [self.buttonSlected setObject:@"0" forKey:buttonTag2];
        
        priceLabel.text =[NSString stringWithFormat:@"合计：￥%.2f",price];
        freightLabel.text =[NSString stringWithFormat:@"(含运费：0.00)"];

    }
    

}


-(UILabel *)addLableWithSuperView:(UIView *)superView Font:(CGFloat)font Text:(NSString *) text TextColor:(UIColor *)textColor{
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.textColor = textColor;
    [superView addSubview:label];
    return label;
}

-(UIButton *)addBtnWithSuperView:(UIView *)superView Title:(NSString *)title BackgroundColor:(UIColor *) backgroundColor BackgroundImage:(UIImage *) backgroundImage
                          Target:(id)target Action:(SEL)action ForControlEvents:(UIControlEvents)controlEvents{
    UIButton * button = [[UIButton alloc] init];
    button.backgroundColor = backgroundColor;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button setTitle:title forState:UIControlStateNormal];
    [superView addSubview:button];
    return button;
    
}



#pragma mark - setter and getter

- (NSMutableDictionary *)shiping_id_arr {
    if (!_shiping_id_arr) {
        _shiping_id_arr = [NSMutableDictionary dictionary];
    }
    return _shiping_id_arr;
}
- (NSMutableDictionary *)shop_id_arr {
    if (!_shop_id_arr) {
        _shop_id_arr = [NSMutableDictionary dictionary];
    }
    return _shop_id_arr;
}

- (NSMutableArray *)shippingArr {
    if (!_shippingArr) {
        _shippingArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _shippingArr;
}
- (NSMutableDictionary *)buttonSlected {
    if (!_buttonSlected) {
        _buttonSlected = [NSMutableDictionary dictionary];
    }
    return _buttonSlected;
}




//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60;
//}
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
