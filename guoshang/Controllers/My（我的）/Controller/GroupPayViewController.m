//
//  GroupPayViewController.m
//  guoshang
//
//  Created by JinLian on 16/8/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupPayViewController.h"
#import "MoneyCell.h"
#import "GoodsModel.h"
#import "TotalModel.h"
#import "addressModel.h"
#import "SucceedPayViewController.h"
#import "MyAddressViewController.h"
#import "CarViewController.h"
#import "SVProgressHUD.h"


@interface GroupPayViewController () {
    NSArray *data;
}

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation GroupPayViewController

- (NSMutableArray *)addressArray {
    if (!_addressArray) {
        _addressArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _addressArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    if (self.dataArray.count > 0) {
//        
//        [self.dataArray removeAllObjects];
//    }
    
    if (self.totalArray.count > 0) {
        [self.totalArray removeAllObjects];
    }
    if (self.addressArray.count > 0) {
        [self.addressArray removeAllObjects];
    }
    
    //加载数据
    [self loadAddressData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.isGB = NO;
    /*在设置的时候将用户的收货地址等存在本地，若本地没有就从服务器中取 服务器没有就让用户去设置
     */
    self.title = @"确认订单";
    self.view.backgroundColor = MyColor;
    self.dataArray = [NSMutableArray array];
    self.totalArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    [self createTabelView];
    [self createHeaderAndFooter];
    [self createAccountBar];
    
}
//获取收货地址
- (void)loadAddressData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dataDic= @{@"user_id":UserId};
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/myaddress") parameters:@{@"token":[dataDic paramsDictionaryAddSaltString]} success:^(id responseObject) {
        
        for (NSDictionary *dic in [responseObject objectForKey:@"result"]) {
            NSNumber *index = [dic objectForKey:@"is_default"];
            if ([index integerValue] == 1) {
                addressModel * address = [[addressModel alloc] initWithDictionary:dic error:nil];
                weakSelf.addressStr = address.address_id;
                [weakSelf.addressArray addObject:address];            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf settingData];
            [weakSelf.myTableView reloadData];
        });
        
    } failure:^(NSError *error) {
    }];
    
}

- (void)setDataList:(NSDictionary *)dataList {
    
    _dataList = dataList;
    
}

//传入展示的商品信息
- (void)setGoodsData:(NSDictionary *)goodsData {
    _goodsData = goodsData;
    
    NSDictionary *dic2 = [goodsData objectForKey:@"goods_info"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setValue:[dic2 objectForKey:@"goods_img"] forKey:@"goods_thumb"];
    [dic setValue:[dic2 objectForKey:@"goods_name"] forKey:@"goods_name"];
    [dic setValue:[goodsData objectForKey:@"group_price"] forKey:@"goods_price"];
    [dic setValue:@"0" forKey:@"shipping_price"];
    [dic setValue:[_dataList objectForKey:@"goods_num"] forKey:@"goods_number"];
    
    GoodsModel * model = [[GoodsModel alloc] initWithDictionary:dic error:nil];
    
    data = [NSArray arrayWithObject:model];
    
    [self.myTableView reloadData];
    
}



#pragma mark - 头视图尾视图
-(void)createHeaderAndFooter{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 110)];
    headerView.backgroundColor = MyColor;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Width, 80)];
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
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView * subFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Width, 50)];
    
    subFooterView.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:subFooterView];
//    UILabel * GBlabel = [self addLableWithSuperView:footerView Font:17 Text:@"可获" TextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
//    
//    [GBlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(footerView.mas_left).offset(20);
//        make.top.equalTo(footerView.mas_top);
//        make.width.equalTo(@50);
//        make.bottom.equalTo(footerView.mas_bottom).offset(10);
//    }];
//    
//    UIImageView * GBIcon =[[UIImageView alloc] init];
//    GBIcon.image = [UIImage imageNamed:@"guobi"];
//    [footerView addSubview:GBIcon];
//    [GBIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(GBlabel.mas_right);
//        make.top.equalTo(footerView.mas_top).offset(20);
//        make.width.equalTo(@25);
//        make.height.equalTo(@25);
//    }];
    
    //        NSString * str = [NSString stringWithFormat:@"%@  个",totalModel.g_price];
    UILabel * allPrice = [self addLableWithSuperView:subFooterView Font:18 Text:nil TextColor:[UIColor colorWithRed:227/255.0 green:65/255.0 blue:64/255.0 alpha:1.0]];
    allPrice.tag = 93;
    allPrice.textAlignment = NSTextAlignmentRight;
    [allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView.mas_right).offset(-20);
        make.top.equalTo(footerView.mas_top).offset(10);
        make.width.equalTo(@100);
        make.bottom.equalTo(footerView.mas_bottom).offset(10);
        
    }];
    self.myTableView.tableFooterView = footerView;
    
    
}

-(void)settingData{
    UILabel * userLable = [self.view viewWithTag:80];
    UILabel * addLable = [self.view viewWithTag:81];
    
    if (self.addressArray.count > 0) {
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
    if (data.count > 0) {
        GoodsModel * model = data[0];
        UILabel * priceLabel = [self.view viewWithTag:90];
//        if (self.isGB) {
//            priceLabel.text = [NSString stringWithFormat:@"兑换:%.2f个",[model.total_exchange_integral floatValue]];
//            
//        }else{
        CGFloat price = [model.goods_price floatValue];
        NSInteger count = [model.goods_number integerValue];
        priceLabel.text =[NSString stringWithFormat:@"合计：%.2f",price * count];
//        }
        
        
        UILabel * fieLabel = [self.view viewWithTag:91];
        NSString * str =[NSString stringWithFormat:@"%@",model.shipping_price];
        CGFloat  shipping = [str  floatValue];
        fieLabel.text =[NSString stringWithFormat:@"(含运费：%.2f)",shipping];
      
//        UILabel * cionLabel = [self.view viewWithTag:93];
//        NSInteger gCount = [model.goods_number integerValue] ;
//        NSString * cionStr = @"0 个";
//        if (gCount > 0) {
//            
//            cionStr = [NSString stringWithFormat:@"%@  个",model.g_price];
//        }
        
//        cionLabel.text = cionStr;
        
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
        make.top.equalTo(accontView.mas_top);
        make.right.equalTo(accontView.mas_right);
        make.width.equalTo(@93);
        make.height.equalTo(@50);
    }];
    
    UILabel * pricelabel = [[UILabel alloc] init];
    pricelabel.tag = 90;
//    pricelabel.backgroundColor = [UIColor orangeColor];
    pricelabel.textAlignment = NSTextAlignmentRight;
    pricelabel.textColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    pricelabel.font = [UIFont systemFontOfSize:15];
    [accontView addSubview:pricelabel];
    [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-5);
        make.top.equalTo(accontView.mas_top).offset(10);
        make.height.equalTo(@10);
        make.left.equalTo(accontView.mas_left).offset(10);
    }];
    
    
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.tag = 91;
//    freightLabel.backgroundColor = [UIColor purpleColor];
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
-(void)toAddress {
    
    MyAddressViewController * address = [[MyAddressViewController alloc] init];
    
    [self.navigationController pushViewController:address animated:YES];
}

//支付页面 提交订单接口
-(void)toConfim{
    
    if (self.addressStr.length > 2) {
        
        SucceedPayViewController   *succeed = [[SucceedPayViewController alloc] init];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在参加团购..."];
        NSLog(@"%@",self.dataList);
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/joinGroup") parameters:@{@"token":[self.dataList paramsDictionaryAddSaltString]}  success:^(id responseObject) {
            
            //跳转确认订单页面
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"0"]) {
                [SVProgressHUD dismiss];
                
                succeed.orderId = responseObject[@"result"][@"order_id"];
                succeed.orderType = GSOrderTypeGroupOrder;
                succeed.navigationItem.hidesBackButton = YES;
                [weakSelf.navigationController pushViewController:succeed animated:YES];
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"参团失败,请稍后再试!"];
            
        }];
    
    }else {
        
        [AlertTool alertTitle:@"没有收货地址，请添加收货地址" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            MyAddressViewController * my = [[MyAddressViewController alloc] init];
            [self.navigationController pushViewController:my  animated:YES];
            
        } viewController:self];
        
    }
    
}

-(void) createTabelView{
    
    self.myTableView.backgroundColor = MyColor;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height- 49) style:UITableViewStylePlain];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MoneyCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
}

#pragma mark -- UITableViewDelegate --

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"--->%ld",data.count);
    return data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsModel * model = data[indexPath.row];
    MoneyCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell  让颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
