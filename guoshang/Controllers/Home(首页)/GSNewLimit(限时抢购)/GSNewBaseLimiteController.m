//
//  GSNewBaseLimiteController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewBaseLimiteController.h"
#import "LimitSelectView.h"
#import "GSNewLimiteTableViewCell.h"
#import "GSNewLimitModel.h"
#import "GSNewLimitingViewController.h"
#import "GSNewStartViewController.h"
#import "GSNavigationViewDropView.h"
#import "TimeModel.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeClear = 0,
    RefreshTypeAdd,
    RefreshTypeAnother,
};


@interface GSNewBaseLimiteController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,GSNavigationViewDropViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *LoaddataSource;
@property (weak, nonatomic) GSNavigationViewDropView *dropView;
@property (nonatomic) UIPageViewController * pvc;
@property (nonatomic) NSMutableArray * subVCArray;
@property (nonatomic, strong)NSMutableArray *m_dataArr;
@property (nonatomic, strong)NSTimer *timer;


//测试
@property (nonatomic, weak)   id           m_data;
@property (nonatomic, assign)   NSInteger section;

@end

@implementation GSNewBaseLimiteController
{
    LimitSelectView *_selectView;
    NSMutableArray *_subVCArray;
    UIPageViewController *_pvc;
    NSString *WhichVC;
    
    //开场时间
    NSString *_time1;
    NSString *_time2;
    
    //结束时间
    NSString *_EndTime1;
    NSString *_EndTime2;
    
    //截取后的的时间
    NSString * _Timeresult1;
    NSString * _Timeresult2;
    
    NSString *_showTime;
    
    NSMutableArray *_limitCount;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //先添加header
    _selectView = [[LimitSelectView alloc] initWithFrame:CGRectMake(0, 0.5, Width, 70)];
    _selectView.popVC = self;
    self.view.backgroundColor = MyColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_goodsDetail_point"] style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    self.title = @"限时抢购";
    
    //默认进的第一个controller为0;
    WhichVC = @"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLimiteData:) name:@"LimiteUpdateData" object:nil];
    //加载数据
    [self refreshDataWithRefreshType:RefreshTypeAnother];

}

-(void)refreshDataWithRefreshType:(RefreshType)refreshType;
{
    __weak typeof(self) weakSelf = self;
    
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
        NSString * urlStr = URLDependByBaseURL(@"/Api/Active/flash");
        [HttpTool GET:urlStr parameters:nil success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            NSInteger status = [str integerValue];
            //如果请求成功
            if (status == 20000) {
                
                _limitCount = [[NSMutableArray alloc] init];
                //判断专场的场数
                for (NSDictionary *dic in responseObject[@"result"]) {
                    [_limitCount addObject:dic];
                }
                
                    //获取专场开始时间
                    _time1 = [NSString stringWithFormat:@"%@",responseObject[@"result"][0][@"shift"]];
                    _Timeresult1 = [NSString stringWithFormat:@"%@",responseObject[@"result"][0][@"shift_format"]];
                    _EndTime1 = [NSString stringWithFormat:@"%@",responseObject[@"result"][0][@"end_time_format"]];
                [[NSUserDefaults standardUserDefaults] setObject:_EndTime1 forKey:@"endtime"];
                
                for ( NSDictionary * dic  in responseObject[@"result"]) {
                    GSNewLimitModel * model = [GSNewLimitModel mj_objectWithKeyValues:dic];
                    if (model) {
                        [weakSelf.LoaddataSource addObject:model];
                    }
                }
                
                if (_limitCount.count > 1) {
                    _time2 = [NSString stringWithFormat:@"%@",responseObject[@"result"][1][@"shift"]];
                    _Timeresult2 = [NSString stringWithFormat:@"%@",responseObject[@"result"][1][@"shift_format"]];
                    _EndTime2 = [NSString stringWithFormat:@"%@",responseObject[@"result"][1][@"end_time_format"]];
                }
                    
                
                    //解析时间
                    [weakSelf paseTimeData];
                    [weakSelf createPageView];
                
            }else
            {
            //当限时抢购为空的时候
                [weakSelf creatNilUI];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}

-(void)creatNilUI
{
    UILabel *nilLable = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 40, Height/2 - 100, 80, 40)];
    nilLable.text  = @"敬请期待";
    nilLable.textColor = [UIColor blackColor];
    nilLable.textAlignment = NSTextAlignmentCenter;
    nilLable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nilLable];
}

-(void)paseTimeData{

    [self.m_dataArr removeAllObjects];
    //判断当前抢购状态
    NSInteger buyType = [self judgeTimeWithStarttime];
    NSString *buytypeStr = [NSString stringWithFormat:@"%ld",(long)buyType];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyType" object:nil userInfo:@{@"buyType":buytypeStr}];
    _selectView.ReturnTitle(_Timeresult1,_Timeresult2,buyType);
    //当前为第一个控制器
if ( [WhichVC isEqualToString:@"0"]) {
    
    if (buyType == 0) {
        NSTimeInterval time = [self getTimeIntervalWithStartTime:_time1];
        [self.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleStatTime]];
    }else
    {
        NSTimeInterval time = [self getSurplusTimeWithLastTime:_EndTime1];
        [self.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
    }
    
    //当前为第二个控制器
}else if ([WhichVC isEqualToString:@"1"]){
    if (buyType == 0 || buyType == 1 || buyType == 2 || buyType == 3|| buyType == 4) {
        NSTimeInterval time = [self getTimeIntervalWithStartTime:_time2];
        [self.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleStatTime]];
    }else
    {
        NSTimeInterval time = [self getSurplusTimeWithLastTime:_EndTime2];
        [self.m_dataArr addObject:[TimeModel timeModelWithTitle:@"timeModel" time:time withTimeStyle:timeStyleEndTime]];
    }
}
    [self createTimer];
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

//创建定时器
- (void)createTimer {
self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(buytimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)buytimeAction {
        TimeModel *model = self.m_dataArr[0];
        [model countDown];
    
    [self creatTimeDateString];
}

//获取时间字符串
-(void)creatTimeDateString{
    TimeModel *timeModel = nil;
    if ([WhichVC isEqualToString:@"1"]) {
        timeModel = self.m_dataArr[0];
    }else{
        timeModel = self.m_dataArr[0];
    }
    
    //获取限时抢购状态
    NSInteger type = [self judgeTimeWithStarttime];    
    
    //判断当前抢购状态
    NSString *buytypeStr = [NSString stringWithFormat:@"%ld",(long)type];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyType" object:nil userInfo:@{@"buyType":buytypeStr}];
    if ([timeModel isMemberOfClass:[TimeModel class]]) { 
        [self storeWeakValueWithData:timeModel index:0];
        NSString *grouptime = [NSString stringWithFormat:@"%@",[timeModel currentTimeString]];
        _showTime = grouptime;
        
        if ([_showTime isEqualToString:@"时间已到"]) {
            //销毁定时器
            [self.timer invalidate];
            self.timer = nil;
            [self paseTimeData];
        }
        
        _selectView.ReturnTime(_showTime,WhichVC,type);
    }
    }

//判断抢购的状态
-(NSInteger)judgeTimeWithStarttime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [NSDate date]; //当前时间
    NSDate *timeFirst = [dateFormatter dateFromString:_time1];  //第一个时间
    NSDate *timeSecond = [dateFormatter dateFromString:_time2];  //第二个时间
    
    NSString *endtimeOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"endtime"];
    NSDate *EtimeFirst = [dateFormatter dateFromString:endtimeOne];  //第一个结束时间
    NSDate *EtimeSecond = [dateFormatter dateFromString:_EndTime2];  //第二个结束时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval1 = [timeFirst timeIntervalSinceDate:date1];
    NSTimeInterval timeInterval2 = [timeSecond timeIntervalSinceDate:date1];
    
    NSTimeInterval timeInterval3 = [EtimeFirst timeIntervalSinceDate:date1];
    NSTimeInterval timeInterval4 = [EtimeSecond timeIntervalSinceDate:date1];
    
    if (timeInterval1 > 0) {
        //全部即将开始
        return 0;
    }else if (timeInterval1 == 0)
    {
        //第一个开始
        return 1;
    }else if (timeInterval1 < 0 && timeInterval3 > 0)
    {
        //第一个开始了
        return 2;
    }else if ( timeInterval3 == 0)
    {
        //第一个结束
        return 3;
    }else if (timeInterval3 < 0 && timeInterval2 > 0)
    {
        //第二个即将开始
        return 4;
    }
    else if (timeInterval2 == 0)
    {
        //第二个开始
        return 5;
    }
    else if (timeInterval2 < 0 && timeInterval4 > 0)
    {
        //第二个开始了
        return 6;
    }else if (timeInterval4 == 0)
    {
        //第二个结束
        return 7;
    }else
    {
        //全部结束了
        return 8;
    }
    
}

-(void) createPageView{
    
    if (_limitCount.count == 1) {
        
        NSInteger otherT = 9;//当只有一场时
        _selectView.ReturnTitle(_Timeresult1,@"敬请期待",otherT);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondIsNil" object:nil];
        
    }
    
    _subVCArray = [NSMutableArray array];
    GSNewLimitingViewController * limiting =[[GSNewLimitingViewController alloc] init];
    limiting.dataArray = _LoaddataSource;
    limiting.popView = self;
    [_subVCArray addObject:limiting];
    GSNewStartViewController * start = [[GSNewStartViewController alloc] init];
    if (_limitCount.count > 1) {
        start.dataArray = _LoaddataSource;
        start.popView = self;
    }
    
    [_subVCArray addObject:start];
    UIView * subView =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    subView.backgroundColor =MyColor;
    [self.view addSubview:subView];
    
    _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pvc.view.frame = CGRectMake(0, 0, Width, Height);
    [self.view addSubview:_pvc.view];
    _pvc.dataSource = self;
    _pvc.delegate = self;
    [_pvc setViewControllers:@[_subVCArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
    
    //获取通知中心
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reciveNoticeTochangeVc:) name:@"reciveNoticeTochangeVc" object:nil];
    //实现block
    [self creatHeaderView];
}

-(void)creatHeaderView
{
    NSInteger type = [self judgeTimeWithStarttime];
    //数据出来之后刷新Header
    _selectView.ReturnTitle(_Timeresult1,_Timeresult2,type);
    [self.view addSubview:_selectView];
}

//从后台进入收到通知从新更新时间
-(void)updateLimiteData:(NSNotification *)notification
{
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
    [self paseTimeData];
}

-(void)reciveNoticeTochangeVc:(NSNotification *)notification
{
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
    
    WhichVC = [NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"textOne"]];
    if ([WhichVC isEqualToString:@"0"]) {
        [self.pvc setViewControllers:@[_subVCArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        [self paseTimeData];
    }else{
        if (_limitCount.count == 1) {
           
            NSInteger type = 8;
            _selectView.ReturnTime(@"敬请期待",WhichVC,type);
            
            return;
        }
        [self.pvc setViewControllers:@[_subVCArray[1]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        [self paseTimeData];
    }
}

///rightBarButtonItem点击事件
-(void)right:(UIButton *)button
{
    [self.dropView changeDropViewStatusWithframe:nil];
}

- (void)dropViewDidSelectIndex:(NSInteger)index {
    UINavigationController *navigationController = self.tabBarController.viewControllers[index];
    if (navigationController == self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.tabBarController setSelectedIndex:index];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//下拉菜单
- (GSNavigationViewDropView *)dropView {
    if (!_dropView) {
        GSNavigationViewDropView *dropView = [[GSNavigationViewDropView alloc] init];
        dropView.delegate = self;
        _dropView = dropView;
        [self.view addSubview:dropView];
        return _dropView;
    }
    return _dropView;
}

-(NSMutableArray *)LoaddataSource
{
    if (_LoaddataSource == nil) {
        _LoaddataSource = [[NSMutableArray alloc] init];
    }
    return _LoaddataSource;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)m_dataArr {
    if (!_m_dataArr) {
        _m_dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _m_dataArr;
}

- (void)storeWeakValueWithData:(id)data index:(NSInteger )section {
    
    self.m_data         = data;
    self.section = section;
}

-(void)dealloc
{
//    //销毁定时器
//    [self.timer invalidate];
//    self.timer = nil;
//    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeVCtongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LimiteUpdateData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
