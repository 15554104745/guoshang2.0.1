//  GroupBuyNowController.m
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupBuyNowController.h"
#import "XRCarouselView.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "BuyNewModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "GroupPayViewController.h"
#import "TimeModel.h"
#import "ThreeViewModel.h"
#import "GSChackOutOrderViewController.h"
#import "GSGroupChackOutOrderDetailModel.h"
#define timerNotificationName @"alreadTimeNotificationNameBuyNow"

@interface GroupBuyNowController ()<UITableViewDelegate,UITableViewDataSource> {
    
    FirstTableViewCell *firstView;
    NSArray *attrArray;                 //商品属性
    NSInteger goodsCount;               //选择的商品数量
    UILabel *countLabel;                //展示商品数量 lab
    UIView *transparentView;            //商品选择背景
    NSDictionary *addressDic;           //用户地址
    NSString *address_id;
    NSArray *ruleData;
    NSMutableDictionary *timeDic;
    NSString *service;
    NSDictionary *goodsData;
    CGFloat priceData;
    UILabel *priceLabel1;               //价格底部
    UIButton *buyNowbutton;
    BOOL timeIsOver;                    //团购时间到了
    BOOL GroupRuleIsCreate;                    //防止重复创建团购规则
}
@property (nonatomic, strong)NSMutableArray *threeModelArr;         //精选推荐
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *image_Arr;             //存储image
@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSMutableArray *m_dataArr;
@end

#define kscreen_W [UIScreen mainScreen].bounds.size.width
#define kscreen_H [UIScreen mainScreen].bounds.size.height

@implementation GroupBuyNowController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的团购";
    [self createSubView];
    [self loadData];
    goodsCount = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ntificationCenterAction:) name:timerNotificationName object:nil];
    
}
#pragma mark - 加载数据
//加载网络数据
- (void)loadData {
    [self.threeModelArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    
    //团购商品
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t getDataGroup = dispatch_group_create();
        
        NSDictionary *dic1;
        if ((self.enterstyle == enterWith_Dingdan)) {
            dic1 = UserId ? @{@"tuan_id":self.tun_id,@"params":@"order",@"user_id":UserId} : @{@"tuan_id":self.tun_id,@"params":@"order"};
        }else {
            dic1 = UserId ? @{@"tuan_id":self.tun_id,@"user_id":UserId} : @{@"tuan_id":self.tun_id} ;
        }
        
        dispatch_group_enter(getDataGroup);
        
        //        NSLog(@"%@",[dic1 paramsDictionaryAddSaltString]);
        [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/getGroupInfo") parameters:@{@"token":[dic1 paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            NSString *str = [responseObject objectForKey:@"status"];
            
            if ([str isEqualToString:@"1"]) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [weakSelf alertShowWithTitle:[responseObject objectForKey:@"message"]];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
            if ([str isEqualToString:@"0"]) {
                //第一组数据
                goodsData = [responseObject objectForKey:@"result"];
                BuyNewModel* titleModel = [[BuyNewModel alloc]initWithContentDic:goodsData];
                [weakSelf.titleArr addObject:titleModel];
                priceData = [[goodsData objectForKey:@"group_price"] floatValue];
                //图片
                NSDictionary *image = [goodsData objectForKey:@"goods_info"];
                NSArray *arr = [image objectForKey:@"goods_gallery"];
                for (NSDictionary *img in arr) {
                    NSString *imageStr = [img objectForKey:@"img_url"];
                    if (![imageStr isKindOfClass:[NSNull class]] && [imageStr rangeOfString:@"http"].location == NSNotFound) {
                        imageStr = [NSString stringWithFormat:@"%@%@",ImageBaseURL,imageStr];
                    }
                    if (![imageStr isKindOfClass:[NSNull class]]) {
                        [weakSelf.image_Arr addObject:imageStr];
                    }
                    
                }
                //团购规则
                ruleData = [goodsData objectForKey:@"rule"];
                
                //时间测试
                /*
                 NSTimeInterval time = [weakSelf getSurplusTimeWithLastTime:@"2016-10-10 14:16:00"];
                 [weakSelf.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
                 */
                //计时
                NSTimeInterval time = [weakSelf getSurplusTimeWithLastTime:[goodsData objectForKey:@"end_time_date"]];
//                NSTimeInterval time = 24*60*60+10;
                if ( time <= 24*60*60) {
                    [weakSelf.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
                }else if ( time > 24*60*60){
                    NSTimeInterval startTime = [weakSelf getTimeIntervalWithStartTime:[goodsData objectForKey:@"start_time_date"]];
//                    NSTimeInterval startTime = 10;
                    [weakSelf.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:startTime withTimeStyle:timeStyleStatTime]];
                }
                
                //服务
                service = [goodsData objectForKey:@"shop_name"];
                
                dispatch_group_leave(getDataGroup);
            }
        } failure:^(NSError *error) {
            dispatch_group_leave(getDataGroup);
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf alertShowWithTitle:@"请求数据失败"];
        }];
        
        
        //推荐商品
        dispatch_group_enter(getDataGroup);
        [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:nil success:^(id responseObject) {
            NSArray *arr = [responseObject objectForKey:@"result"];
            if (arr.count > 6) {
                arr = [arr subarrayWithRange:NSMakeRange(0, 6)];
            }
            for (NSDictionary *dic in arr) {
                
                ThreeViewModel *model = [[ThreeViewModel alloc]initWithContentDic:dic];
                NSDictionary *dic2 = @{@"Id":[dic objectForKey:@"id"]};
                model.mapDic = dic2;
                [weakSelf.threeModelArr addObject:model];
            }
            
            dispatch_group_leave(getDataGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(getDataGroup);
            
        }];
        
        //用户地址
        NSDictionary *data= @{@"user_id":UserId};
        dispatch_group_enter(getDataGroup);
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/myaddress") parameters:@{@"token":[data paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            for (NSDictionary *dic in [responseObject objectForKey:@"result"]) {
                NSNumber *index = [dic objectForKey:@"is_default"];
                if ([index integerValue] == 1) {
                    
                    address_id = [dic objectForKey:@"address_id"];
                    addressDic = [NSDictionary dictionaryWithDictionary:dic];
                }else {
                    NSDictionary *dicAddress = [[responseObject objectForKey:@"result"] firstObject];
                    address_id = [dicAddress objectForKey:@"address_id"];
                    addressDic = [NSDictionary dictionaryWithDictionary:dicAddress];
                }
            }
            
            dispatch_group_leave(getDataGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(getDataGroup);
        }];
        
        
        
        
        dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [_tableView reloadData];
            [weakSelf createTimer];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    });
}

- (void)ntificationCenterAction:(NSNotification *)center {
    NSTimeInterval time = [self getSurplusTimeWithLastTime:[goodsData objectForKey:@"end_time_date"]];
    if (time == 0) {
        timeIsOver = YES;
        [self.timer invalidate];
        self.timer = nil;
    }else {
        GroupRuleIsCreate = YES;
        [self.m_dataArr removeAllObjects];
        [self.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
        [self.tableView reloadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:timerNotificationName object:nil];
}

- (NSTimeInterval )getSurplusTimeWithLastTime:(NSString *)endTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [NSDate date]; //开始时间
    NSDate *date2 = [dateFormatter dateFromString:endTime];  //结束时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [date2 timeIntervalSinceDate:date1];
    return timeInterval;
}

- (void)createTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)timerAction {
    for (int i = 0; i < self.m_dataArr.count; i++) {
        TimeModel *model = self.m_dataArr[i];
        [model countDown];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FirstTableViewCellNotifaction object:nil];
}


- (void)createSubView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kscreen_W, kscreen_H-44-20) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [_tableView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:@"threeCell"];
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    buyNowbutton = [[UIButton alloc]init];
    buyNowbutton.backgroundColor = [UIColor colorWithRed:226/255.0f green:57/255.0f blue:60/225.0 alpha:1];
    [buyNowbutton setTitle:@"马上参团" forState:UIControlStateNormal];
    [buyNowbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyNowbutton.layer.cornerRadius = 5;
    buyNowbutton.clipsToBounds = YES;
    [buyNowbutton addTarget:self action:@selector(BottombuttonActon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyNowbutton];
    if (self.enterstyle ==  enterWith_Dingdan) {
        buyNowbutton.hidden = YES;
    }
    [buyNowbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
    }];
    
}
//创建底部商品选择视图
- (void)createCountView {
    
    transparentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, kscreen_H-49)];
    transparentView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.7];
    [self.view addSubview:transparentView];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,transparentView.frame.size.height - 200, Width, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [transparentView addSubview:backView];
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0,-25, 50, 50)];
    icon.layer.borderWidth = 5;
    icon.layer.borderColor = [[UIColor whiteColor] CGColor];
    [icon sd_setImageWithURL:[NSURL URLWithString:[self.image_Arr firstObject]] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    [backView addSubview:icon];
    
    priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 20)];
    [backView addSubview:priceLabel1];
    priceLabel1.textColor = NewRedColor;
    priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",priceData];
    //    if (attrArray.count != 0) {
    //        goodsPrice = [[attrArray[0] shop_price]integerValue];
    //        priceLabel1.text = [NSString stringWithFormat:@"￥%ld",(long)goodsPrice];
    //    }else{
    //        NSString *str = [_dataArray[0] shop_price];
    //        goodsPrice = [str floatValue];
    //        NSLog(@"%f",goodsPrice);
    //        priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsPrice];
    //        priceLabel1.text = [NSString stringWithFormat:@"￥100.00"];
    //    }
    
    
    //商品属性
    if (attrArray.count != 0) {
        UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, backView.bounds.size.height-210, 40, 20)];
        typeLabel.text = @"类型:";
        typeLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:typeLabel];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(65, backView.bounds.size.height-210, Width-80, 80)];
        [backView addSubview:view];
        
        int len = (Width-80)/4;
        for (int i =0; i<attrArray.count; i++) {
            UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            typeButton.frame = CGRectMake(i%4*len, i/4*30, len-5, 25);
            typeButton.backgroundColor = [UIColor whiteColor];
            typeButton.tag = 50+i;
            if (i==0) {
                typeButton.selected = YES;
            }else{
                typeButton.selected = NO;
            }
            typeButton.layer.borderColor = [UIColor grayColor].CGColor;
            typeButton.layer.borderWidth = 1;
            typeButton.layer.cornerRadius = 5;
            typeButton.titleLabel.font = [UIFont systemFontOfSize:10];
            typeButton.titleLabel.numberOfLines = 2;
            [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [typeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [typeButton setTitle:[NSString stringWithString:[attrArray[i] attr_names]] forState:UIControlStateNormal];
            typeButton.titleLabel.adjustsFontSizeToFitWidth = YES;//字体大小自适应
            [typeButton addTarget: self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:typeButton];
        }
    }
    
    UILabel * countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 40, 20)];
    countLabel1.text = @"数量:";
    countLabel1.font = [UIFont systemFontOfSize:15];
    [backView addSubview:countLabel1];
    
    UIButton * descButton = [UIButton buttonWithType:UIButtonTypeCustom];
    descButton.frame = CGRectMake(Width/2-90, countLabel1.frame.origin.y, 30, 30);
    descButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    descButton.tag = 8000;
    descButton.layer.cornerRadius = 5;
    [descButton setImage:[UIImage imageNamed:@"jianhao"] forState:UIControlStateNormal];
    [descButton addTarget: self action:@selector(paramasButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:descButton];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(Width/2+60, countLabel1.frame.origin.y, 30, 30);
    addButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    addButton.tag = 8001;
    addButton.layer.cornerRadius = 5;
    [addButton setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [addButton addTarget: self action:@selector(paramasButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addButton];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-30, countLabel1.frame.origin.y, 60, 30)];
    //    countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
    countLabel.text = @"1";
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.layer.borderColor = [UIColor grayColor].CGColor;
    countLabel.layer.borderWidth = 1.0;
    countLabel.layer.cornerRadius = 5;
    [backView addSubview:countLabel];
    
    UIButton * certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.frame = CGRectMake(Width/2-110, countLabel.frame.origin.y + 50, 70, 25);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    certainButton.tag = 8002;
    certainButton.layer.cornerRadius = 5;
    certainButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [certainButton addTarget: self action:@selector(paramasButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:certainButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(Width/2+40, countLabel.frame.origin.y + 50, 70, 25);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.tag = 8003;
    cancelButton.layer.cornerRadius = 5;
    cancelButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [cancelButton addTarget: self action:@selector(paramasButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelButton];
    
    
}
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            NSInteger count = ruleData.count;
            CGFloat lab_h = 20;
            CGFloat height = (count + lab_h) * ((count - 1) / 3 + 1);
            return height + 89;
        }
            break;
        case 1:{
            return 100;
        }
            break;
        case 2:{
            return ((kscreen_W-60)/3+47)*2+80;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.view.frame.size.width-100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    switch (index) {
        case 0: {
            firstView = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
            firstView.selectionStyle = UITableViewCellSelectionStyleNone;
            BuyNewModel *model =  [self.titleArr firstObject];
            firstView.model = model;
            
            //刷新数据时不重复创建团购规则
            if (!GroupRuleIsCreate) {
                firstView.group_rule = ruleData;
            }
            
            if (self.m_dataArr.count >0) {
                TimeModel *timeModel = self.m_dataArr[0];
                [firstView loadData:timeModel index:0];
            }
            return firstView;
        }
            break;
            
        case 1: {
            
            SecondTableViewCell *secondView = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
            secondView.selectionStyle = UITableViewCellSelectionStyleNone;
            
            __weak typeof(self) weakSelf = self;
            secondView.block = ^(){
                
                if (self.enterstyle != enterWith_Dingdan) {
                    [weakSelf BottombuttonActon:nil];
                }
            };
            NSString *str1;
            NSString *str2;
            NSString *str3;
            NSString *address;
            if (![[addressDic objectForKey:@"province"] isEqual:[NSNull null]]) {
                str1 = [addressDic objectForKey:@"province"];
                address = [NSString stringWithFormat:@"%@",str1];
            }
            if (![[addressDic objectForKey:@"city"] isEqual:[NSNull null]]) {
                str2 = [addressDic objectForKey:@"city"];
                address = [NSString stringWithFormat:@"%@>%@",str1,str2];
            }
            if (![[addressDic objectForKey:@"district"] isEqual:[NSNull null]]) {
                str3 = [addressDic objectForKey:@"district"];
                address = [NSString stringWithFormat:@"%@>%@>%@",str1,str2,str3];
            }
            if (address.length > 0) {
                NSDictionary *dic = @{@"address":address};
                secondView.addressDic = dic;
            }
            secondView.service = service;
            return secondView;
        }
            break;
        case 2: {
            
            ThreeTableViewCell *threeView = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
            threeView.selectionStyle = UITableViewCellSelectionStyleNone;
            threeView.dataList = self.threeModelArr;
            return threeView;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XRCarouselView *carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.width)];
    //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
    carouselView.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
    
    carouselView.imageArray = self.image_Arr;
    //设置每张图片的停留时间，默认值为5s，最少为2s
    carouselView.time = 3;
    //设置分页控件的图片,不设置则为系统默认
    [carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentPageImage:[UIImage imageNamed:@"current"]];
    UIColor *bgColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *textColor = [UIColor greenColor];
    [carouselView setDescribeTextColor:textColor font:font bgColor:bgColor];
    
    return carouselView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.m_dataArr.count > 0) {
        FirstTableViewCell *firstCell = (FirstTableViewCell *)cell;
        firstCell.m_isDisplayed = YES;
        [firstCell loadData:self.m_dataArr[0] index:0];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0 && self.m_dataArr.count > 0) {
        FirstTableViewCell *firstCell = (FirstTableViewCell *)cell;
        firstCell.m_isDisplayed = NO;
    }
}

#pragma mark - buttonAction
//马上参团跳转  弹出商品选择
- (void)BottombuttonActon:(UIButton *)sender {
    
    if (timeIsOver) {
        [self alertShowWithTitle:@"活动已结束"];
        return;
    }
    
    NSString *starTimeData = [goodsData objectForKey:@"start_time_date"];
    NSString *is_buy = [goodsData objectForKey:@"is_buy"];
    NSTimeInterval timeInterval = [self getTimeIntervalWithStartTime:starTimeData];
    if (timeInterval > 0) {
        [self alertShowWithTitle:@"活动时间未开始"];
    }else if([is_buy isEqualToString:@"N"]){
        [self alertShowWithTitle:@"团购购买数量已超上线"];
    }else {
        [self createCountView];
    }
}

- (void)paramasButtonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 8000;
    switch (index) {
            //减号
        case 0:{
            
            if (goodsCount>=1) {
                goodsCount --;
                countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
                priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsCount*priceData];
            }
        }
            break;
            //加号
        case 1:{
            
            NSInteger each_amount = [goodsData[@"buy_num"] integerValue];
            if (goodsCount < each_amount) {
                goodsCount ++;
                countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
                priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsCount*priceData];
            }else {
                [self alertShowWithTitle:[NSString stringWithFormat:@"最多购买%ld个",each_amount]];
            }
        }
            break;
            //确定  参与团购
        case 2: {
            
            [transparentView removeFromSuperview];
            
            GroupPayViewController *groupPay = [[GroupPayViewController alloc]init];
            NSString *count = countLabel.text;
            NSDictionary *dic = @{
                                  @"user_id":UserId,
                                  @"address_id":address_id,
                                  @"goods_num":count,
                                  @"tuan_id":self.tun_id,
                                  };
            groupPay.dataList = dic;
            groupPay.goodsData = goodsData;
            groupPay.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupPay animated:YES];

            //新版确认订单页面
            /*
            GSChackOutOrderViewController *chackOutOrderViewController = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
            GSGroupChackOutOrderDetailModel *model = [GSGroupChackOutOrderDetailModel mj_objectWithKeyValues:goodsData];
            chackOutOrderViewController.groupDetailModel = model;
            [self.navigationController pushViewController:chackOutOrderViewController animated:YES];
             */
        }
            break;
            //取消
        case 3:{
            [transparentView removeFromSuperview];
            goodsCount = 1;
        }
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
}


- (NSTimeInterval)getTimeIntervalWithStartTime:(NSString *)startTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *start_date = [dateFormatter dateFromString:startTime]; //开始时间
    NSDate *end_date = [[NSDate alloc]init];  //当前时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [start_date timeIntervalSinceDate:end_date];
    return timeInterval;
}


- (void)alertShowWithTitle:(NSString *)titleStr {
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:titleStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}

#pragma mark - setter and getter
- (NSMutableArray *)image_Arr {
    if (!_image_Arr) {
        _image_Arr = [NSMutableArray arrayWithCapacity:0];
    }
    return _image_Arr;
}
- (NSMutableArray *)threeModelArr {
    if (!_threeModelArr) {
        _threeModelArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _threeModelArr;
}
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArr;
}
- (NSMutableArray *)m_dataArr {
    if (!_m_dataArr) {
        _m_dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _m_dataArr;
}


@end
