//
//  MyGroupViewController.m
//  guoshang
//
//  Created by JinLian on 16/8/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyGroupViewController.h"
#import "MyGroupTableViewCell.h"
#import "GroupHeaderView.h"
#import "XRCarouselView.h"
#import "TimeModel.h"
#import "GroupBuyNowController.h"
#import "HeadModel.h"
#import "MBProgressHUD.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "GSEmtpyTableVistvView.h"

#define stweak(type) __weak typeof(type) weak##type = type;

@interface MyGroupViewController ()<UITableViewDelegate,UITableViewDataSource,XRCarouselViewDelegate> {
    GroupHeaderView *headerView;
    NSString *tuan_id;
    NSInteger page;
    NSArray *group_data;
    
}

@property(nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *groupArr;        //团购数据
@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, strong) NSTimer *m_timer;
@property (nonatomic, strong) NSMutableArray *image_arr;
@property (nonatomic, strong) GSEmtpyTableVistvView *emptyView;

@end

@implementation MyGroupViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self createTimer];
    [self loadData];
    
    //    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self timerDismiss];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"alreadTimeNotificationName" object:nil];
}

/**
 *  数据请求接口
 */
- (void)loadData {
    page ++;
    stweak(self);
    NSDictionary *tokenDic;
    if (UserId) {
        NSDictionary *paramasdic = @{
                                     @"user_id":UserId,
                                     @"page":[NSString stringWithFormat:@"%ld",(long)page],
                                     
                                     };
        NSString *str = [paramasdic paramsDictionaryAddSaltString];
        tokenDic  = @{@"token":str};
    }else {
        NSDictionary *paramasdic = @{
                                     @"page":[NSString stringWithFormat:@"%ld",(long)page],
                                     };
        NSString *str = [paramasdic paramsDictionaryAddSaltString];
        tokenDic  = @{@"token":str};
    }
    //请求团购列表
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
    [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/index") parameters:tokenDic  success:^(id responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"2"]) {
            [weakself alertShow];
            [weakself.navigationController popViewControllerAnimated:YES];
        } ;
        NSArray *emptyArr = (NSArray *)responseObject[@"result"];
        if ([status isEqualToString:@"1"] && [emptyArr count] == 0  && page == 1) {
            
            [weakself.tableView removeFromSuperview];
            weakself.emptyView.title = @"暂无团购信息";
            [weakself.view addSubview:weakself.emptyView];
            
        }
        
        if ([status isEqualToString:@"0"]) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            
            //顶部图片
            NSArray *imageArr = [result objectForKey:@"ad_list"];
            for (NSDictionary *dic in imageArr) {
                
                NSString *image_url = [dic objectForKey:@"ad_image"];
                if (![image_url isKindOfClass:[NSNull class]] && [image_url rangeOfString:@"http"].location == NSNotFound) {
                    image_url = [NSString stringWithFormat:@"%@%@",ImageBaseURL,image_url];
                }
                if (![image_url isKindOfClass:[NSNull class]]) {
                    [weakself.image_arr addObject:image_url];
                }
            }
            
            group_data = [result objectForKey:@"group_data"];
            for (NSDictionary *dic in group_data) {
                //团购
                NSDictionary *tuan_dataDic = [dic objectForKey:@"tuan_data"];
                HeadModel *model2 = [[HeadModel alloc]initWithContentDic:tuan_dataDic];
                NSMutableDictionary * goodsDic = [NSMutableDictionary dictionaryWithCapacity:1];
                [goodsDic setValue:model2 forKey:@"tuan_data"];
                
                //商品信息
                NSDictionary *dic1 = [dic objectForKey:@"goods_data"];
                MyGroupModel *model1 = [[MyGroupModel alloc]initWithContentDic:dic1];
                [goodsDic setValue:model1 forKey:@"goods_data"];
                
                [weakself.groupArr addObject:goodsDic];
                /*
                 NSTimeInterval time = [weakself getSurplusTimeWithLastTime:@"2016-10-10 14:37:00"];
                 [weakself.m_dataArray addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
                 */
                //计时
                
                NSTimeInterval time = [weakself getSurplusTimeWithLastTime:[tuan_dataDic objectForKey:@"end_time"]];
                //                 NSTimeInterval time = 24*60*60+10;
                if ( time <= 24*60*60) {
                    [weakself.m_dataArray addObject:[TimeModel timeModelWithTitle:[tuan_dataDic objectForKey:@"group_id"] time:time withTimeStyle:timeStyleEndTime]];
                }else if ( time > 24*60*60){
                    NSTimeInterval startTime = [weakself getTimeIntervalWithStartTime:[tuan_dataDic objectForKey:@"start_time"]];
                    //                    NSTimeInterval startTime = 10;
                    [weakself.m_dataArray addObject:[TimeModel timeModelWithTitle:[tuan_dataDic objectForKey:@"group_id"] time:startTime withTimeStyle:timeStyleStatTime]];
                }
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [_tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer endRefreshing];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [weakself alertShow];
            [weakself.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

//获取两个时间点的时间间隔
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的团购";
    page = 0;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0f green:249/255.0f blue:249/255.0f alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.sectionFooterHeight = 10;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerNib:[UINib nibWithNibName:@"MyGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    stweak(self);
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself.groupArr removeAllObjects];
        [weakself.m_dataArray removeAllObjects];
        [weakself.image_arr removeAllObjects];
        page = 0;
        [weakself loadData];
    }];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:@"alreadTimeNotificationName" object:nil];
}

- (void)notificationAction {
//    [self.m_dataArray removeAllObjects];
//    for (NSDictionary *dic in group_data) {
//        NSDictionary *tuan_dataDic = [dic objectForKey:@"tuan_data"];
//        NSTimeInterval time = [self getSurplusTimeWithLastTime:[tuan_dataDic objectForKey:@"end_time"]];
//        if ( time <= 24*60*60) {
//            [self.m_dataArray addObject:[TimeModel timeModelWithTitle:[tuan_dataDic objectForKey:@"group_id"] time:time withTimeStyle:timeStyleEndTime]];
//        }else if ( time > 24*60*60){
//            NSTimeInterval startTime = [self getTimeIntervalWithStartTime:[tuan_dataDic objectForKey:@"start_time"]];
//            [self.m_dataArray addObject:[TimeModel timeModelWithTitle:[tuan_dataDic objectForKey:@"group_id"] time:startTime withTimeStyle:timeStyleStatTime]];
//        }
//    }
//    [self.tableView reloadData];
}

- (void)createTimer {
    
    self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
    for (int count = 0; count < self.m_dataArray.count; count++) {
        TimeModel *model = self.m_dataArray[count];
        [model countDown];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}


#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    //    NSDictionary *dic = self.groupArr[section];
    //    NSArray *arr = [dic objectForKey:@"goods_data"];
    //    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.groupArr[indexPath.section];
    MyGroupModel *model = [dic objectForKey:@"goods_data"];
    cell.model = model;
    
    HeadModel *model2 = [dic objectForKey:@"tuan_data"];
    cell.headModel = model2;
    //    NSLog(@"++++%@",model2.is_clerk);
    cell.tuan_id = model2.group_id;
    
    __weak typeof(self) weakSelf = self;
    cell.block = ^(NSString *tuanid){
        
        [weakSelf timerDismiss];
        
        if (UserId) {
            
            GroupBuyNowController *groupVC = [[GroupBuyNowController alloc]init];
            groupVC.tun_id = tuanid;
            groupVC.enterstyle = enterWith_Shouye;
            [weakSelf.navigationController pushViewController:groupVC animated:YES];
            
        }else {
            
            [weakSelf loginAction];
        }
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (UserId) {
    //
    //    NSDictionary *dic = self.groupArr[indexPath.section];
    //    HeadModel *model2 = [dic objectForKey:@"tuan_data"];
    //    GroupBuyNowController *groupVC = [[GroupBuyNowController alloc]init];
    //    groupVC.tun_id = model2.group_id;
    //    groupVC.enterstyle = enterWith_Shouye;
    //
    ////    NSLog(@"%@",model2.group_id);
    //    [self.navigationController pushViewController:groupVC animated:YES];
    //    }else {
    //        [self loginAction];
    //    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 240;
    }
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.groupArr[section];
    HeadModel *model = [dic objectForKey:@"tuan_data"];
    tuan_id = model.group_id;
    if (section == 0) {
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
        
        XRCarouselView *carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
        carouselView.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        
        if (self.image_arr.count == 0) {
            [self.image_arr addObject:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
        }
        
        carouselView.imageArray = self.image_arr;
        //用代理处理图片点击
        carouselView.delegate = self;
        //设置每张图片的停留时间，默认值为5s，最少为2s
        carouselView.time = 2;
        //设置分页控件的图片,不设置则为系统默认
        [carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentPageImage:[UIImage imageNamed:@"current"]];
        
        UIColor *bgColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        UIFont *font = [UIFont systemFontOfSize:15];
        UIColor *textColor = [UIColor greenColor];
        [carouselView setDescribeTextColor:textColor font:font bgColor:bgColor];
        [backview addSubview:carouselView];
        
        GroupHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"GroupHeaderView" owner:nil options:nil] lastObject];
        view.frame = CGRectMake(0, 150, self.view.frame.size.width, 90);
        view.tag = 816;
        view.model = model;
        [backview addSubview:view];
        
        return backview;
    }
    
    headerView = [[[NSBundle mainBundle]loadNibNamed:@"GroupHeaderView" owner:nil options:nil] lastObject];
    TimeModel *model2 = self.m_dataArray[section];
    [headerView loadData:model2 index:section];
    headerView.model = model;
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        GroupHeaderView *headerV = [view viewWithTag:816];
        headerV.m_isDisplayed = YES;
        [headerV loadData:_m_dataArray[section] index:section];
    }else {
        GroupHeaderView *headerV = (GroupHeaderView *)view;
        headerV.m_isDisplayed = YES;
        [headerV loadData:_m_dataArray[section] index:section];
    }
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        GroupHeaderView *headerV = [view viewWithTag:816];
        headerV.m_isDisplayed = NO;
    }else {
        GroupHeaderView *headerV = (GroupHeaderView *)view;
        headerV.m_isDisplayed = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //清除缓存
    [XRCarouselView clearDiskCache];
}

- (void)timerDismiss {
    
    [self.m_timer invalidate];
    self.m_timer = nil;
}


#pragma mark XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {
    //    NSLog(@"点击了第%ld张图片", index);
}

#pragma mark - 提示信息
- (void)alertShow {
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"团购信息不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}
- (void)loginAction {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请登录..." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GSNewLoginViewController * lvc = [[GSNewLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {  }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//团购结束时间与当前时间的比较
- (NSTimeInterval)getTimeIntervalWithStartTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *start_date = [dateFormatter dateFromString:endTime]; //结束时间
    NSDate *end_date = [[NSDate alloc]init];  //当前时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [start_date timeIntervalSinceDate:end_date];
    return timeInterval;
}
#pragma mark - setter and getter

- (NSMutableArray *)image_arr {
    if (!_image_arr) {
        _image_arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _image_arr;
}

- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        _groupArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _groupArr;
}

- (NSMutableArray *)m_dataArray {
    if (!_m_dataArray) {
        _m_dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _m_dataArray;
}

- (GSEmtpyTableVistvView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[GSEmtpyTableVistvView alloc]initWithFrame:self.view.bounds];
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 //刷新数据接口
 //- (void)refreshData {
 //    page ++;
 //    stweak(self);
 //    NSDictionary *tokenDic;
 //    if (UserId) {
 //        NSDictionary *paramasdic = @{
 //                                     @"user_id":UserId,
 //                                     @"page":[NSString stringWithFormat:@"%ld",(long)page],
 //                                     };
 //        NSString *str = [paramasdic paramsDictionaryAddSaltString];
 //        tokenDic  = @{@"token":str};
 //    }else {
 //        NSDictionary *paramasdic = @{
 //                                     @"page":[NSString stringWithFormat:@"%ld",(long)page],
 //                                     };
 //        NSString *str = [paramasdic paramsDictionaryAddSaltString];
 //        tokenDic  = @{@"token":str};
 //    }
 //
 //    [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/index") parameters:tokenDic success:^(id responseObject) {
 //        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
 //        if ([status isEqualToString:@"0"]) {
 //
 //            NSDictionary *result = [responseObject objectForKey:@"result"];
 //            NSArray *group_data = [result objectForKey:@"group_data"];
 //            for (NSDictionary *dic in group_data) {
 //                //团购
 //                NSDictionary *dic2 = [dic objectForKey:@"tuan_data"];
 //                HeadModel *model2 = [[HeadModel alloc]initWithContentDic:dic2];
 //                NSMutableDictionary * goodsDic = [NSMutableDictionary dictionaryWithCapacity:1];
 //                [goodsDic setValue:model2 forKey:@"tuan_data"];
 //
 //                //商品信息
 //                NSDictionary *dic1 = [dic objectForKey:@"goods_data"];
 //                MyGroupModel *model1 = [[MyGroupModel alloc]initWithContentDic:dic1];
 //                [goodsDic setValue:model1 forKey:@"goods_data"];
 //
 //                [weakself.groupArr addObject:goodsDic];
 //
 //                //计时
 //                NSTimeInterval time = [weakself getSurplusTimeWithLastTime:[dic2 objectForKey:@"end_time"]];
 //                if ( time <= 24*60*60) {
 //                    [weakself.m_dataArray addObject:[TimeModel timeModelWithTitle:[dic2 objectForKey:@"group_id"] time:time withTimeStyle:timeStyleEndTime]];
 //                }else if ( time > 24*60*60){
 //                    NSTimeInterval startTime = [weakself getTimeIntervalWithStartTime:[dic2 objectForKey:@"start_time"]];
 //                    [weakself.m_dataArray addObject:[TimeModel timeModelWithTitle:[dic2 objectForKey:@"group_id"] time:startTime withTimeStyle:timeStyleStatTime]];
 //                }
 //            }
 //
 //        }
 //        dispatch_async(dispatch_get_main_queue(), ^{
 //            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
 //            //            [weakself createTimer];
 //            [_tableView reloadData];
 //            [weakself.tableView.mj_footer endRefreshing];
 //        });
 //    } failure:^(NSError *error) {
 //        dispatch_async(dispatch_get_main_queue(), ^{
 //            NSLog(@"%@",error);
 //            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
 //            [weakself alertShow];
 //            [weakself.navigationController popViewControllerAnimated:YES];
 //
 //        });
 //    }];
 //
 //}
 */
@end
