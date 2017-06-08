//
//  GSNearbyStoreListViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNearbyStoreListViewController.h"
#import "GSNearbyStoreListTableViewCell.h"
#import "CFPicModel.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "GSStoreDetailViewController.h"
#import "NJBannerView.h"
//#import <CoreLocation/CoreLocation.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

//#import "WGS84ToGCJ02.h"

#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0
static NSString *cellIdentfiy = @"nearbyStoreListCell";

const static NSInteger kOpenLocationAlertTag = 100;

@interface GSNearbyStoreListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,AMapLocationManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NJBannerView *banner;
@property (strong, nonatomic) NSMutableArray *allStoreArray;
@property (strong, nonatomic) NSMutableArray *bannerArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) MKMapView *mkMapView;
@property (strong, nonatomic) AMapLocationManager *aMapLocationManager;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (assign, nonatomic) BOOL isFirstResponse;

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *keyWord;

@property (assign, nonatomic) BOOL isRequesting;

@end

@implementation GSNearbyStoreListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    

    
    //[self startLocation];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self updataBanner];
    [self startMapLocation];
}

- (void)startMapLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AMapServices sharedServices].apiKey =@"6263b57ed4d895d45ef399527c9782a4";
    });
    
    if (!self.aMapLocationManager) {
        self.aMapLocationManager = [[AMapLocationManager alloc] init];
        self.aMapLocationManager.delegate = self;
    }
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [self.aMapLocationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    
    [SVProgressHUD dismiss];
    if (error) {
        if (error.code && error.code == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位权限被禁止,请先在设置中允许！" delegate:self cancelButtonTitle:@"打开" otherButtonTitles:@"取消", nil];
            //            NSLog(@"%zi",kOpenLocationAlertTag);
            alertView.tag = kOpenLocationAlertTag;
            [alertView show];
        }
    }
    
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
    [manager stopUpdatingLocation];
    
    if (!_isFirstResponse) {
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf startMapLocation];
        }];
        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            //            NSLog(@"%@",[NSString stringWithFormat:@"%zi",(_allStoreArray.count/10) + 1]);
            [weakSelf getStoreListWithLongitude:_longitude latitude:_latitude keyWord:_keyWord page:[NSString stringWithFormat:@"%zi",(_allStoreArray.count/10) + 1] refreshType:MJRefreshTypeAdd];
        }];
        
        _isFirstResponse = YES;
    }
    
    if (!_isRequesting) {
        _isRequesting = YES;
        //        NSLog(@"经纬度:%lf,%lf",location.coordinate.latitude,
        //              location.coordinate.longitude);
        self.longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
        [self getStoreListWithLongitude:_longitude latitude:_latitude keyWord:_keyWord ? _keyWord : @"" page:@"1" refreshType:MJRefreshTypeClear];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [SVProgressHUD dismiss];
    if (alertView.tag == kOpenLocationAlertTag) {
        switch (buttonIndex) {
            case 0:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                break;
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }
    
}


/*
 #pragma mark - 定位
 - (void)startLocation {
 [SVProgressHUD showWithStatus:@"正在获取数据..."];
 if([CLLocationManager locationServicesEnabled]) {
 
 _locationManager = [[CLLocationManager alloc] init];
 _locationManager.delegate = self;
 //设置定位精度
 _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
 _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
 if (iOS8) {
 //使用应用程序期间允许访问位置数据
 [_locationManager requestWhenInUseAuthorization];
 }
 // 开始定位
 [_locationManager startUpdatingLocation];
 }else {
 //提示用户无法进行定位操作
 [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"appCanLocation"];
 NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
 [self getStoreListWithLongitude:nil latitude:nil];
 }
 }
 
 
 
 
 - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
 [manager stopUpdatingLocation];
 
 CLLocation *location = [locations lastObject];
 NSLog(@"经纬度：%lf,%lf",location.coordinate.latitude,location.coordinate.longitude);
 CLLocationCoordinate2D newLocation = [WGS84ToGCJ02 transformFromWGSToGCJ:location.coordinate];
 NSLog(@"new 经纬度：%lf,%lf",newLocation.latitude,newLocation.longitude);
 
 
 [self getStoreListWithLongitude:[NSString stringWithFormat:@"%lf",newLocation.longitude] latitude:[NSString stringWithFormat:@"%lf",newLocation.latitude]];
 }
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
 [self getStoreListWithLongitude:nil latitude:nil];
 }
 */

- (void)getStoreListWithLongitude:(NSString *)longitude latitude:(NSString *)latitude keyWord:(NSString *)keyWord page:(NSString *)page refreshType:(MJRefreshType)refreshType {
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"正在获取附近门店..."];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (UserId) {
        [params setObject:UserId forKey:@"user_id"];
    }
    if (page && ![page isEqualToString:@""]) {
        [params setObject:page forKey:@"page"];
    }
    [params setObject:@"10" forKey:@"page_size"];
    
    if (longitude && latitude && ![longitude isEqualToString:@""] && ![latitude isEqualToString:@""]) {
        [params setObject:longitude forKey:@"longitude"];
        [params setObject:latitude forKey:@"latitude"];
    }
    if (keyWord && ![keyWord isEqualToString:@""]) {
        [params setObject:keyWord forKey:@"keyword"];
    }
    
    //NSDictionary *dic = [params addSaltParamsDictionary];
    
    
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopList") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        _isRequesting = NO;
        
        if (responseObject && ([responseObject[@"status"] isEqualToString:@"0"] || [responseObject[@"status"] isEqualToString:@"1"])) {
            
            //if (responseObject[@"result"] && [responseObject[@"result"] count] > 0) {
            
            if (refreshType == MJRefreshTypeClear) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
                weakSelf.allStoreArray = [GSStoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            } else {
                NSArray *array = [GSStoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                [weakSelf.allStoreArray addObjectsFromArray:array];
            }
            
            if ([responseObject[@"result"] count] < 10) {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.isRequesting = NO;
                [weakSelf.tableView.mj_header endRefreshing];
                
                [SVProgressHUD dismiss];
                [weakSelf.tableView reloadData];
                
            });
            
        }
        /*
         else {
         dispatch_async(dispatch_get_main_queue(), ^{
         weakSelf.isRequesting = NO;
         //                    [weakSelf.allStoreArray removeAllObjects];
         [weakSelf.tableView.mj_header endRefreshing];
         if ([weakSelf.allStoreArray count] < 10) {
         [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         } else {
         [weakSelf.tableView.mj_footer endRefreshing];
         }
         [SVProgressHUD dismiss];
         [weakSelf.tableView reloadData];
         
         });
         weakSelf.isRequesting = NO;
         
         }
         */
        else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:@"获取数据失败,请稍后再试!"];
        }
        
    }];
}


#pragma mark - 获取轮播图数据
/*
 - (void)getData {
 
 [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
 [SVProgressHUD showWithStatus:@"正在获取数据"];
 __weak typeof(self) weakSelf = self;
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
 
 //__block NSError *error;
 dispatch_group_t downloadGroup = dispatch_group_create(); // 2
 
 
 
 dispatch_group_enter(downloadGroup); // 3
 [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopList") parameters:nil completed:^(id responseObject, NSError *error) {
 
 if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
 //NSLog(@"%@",responseObject[@"result"][0]);
 weakSelf.allStoreArray = [GSStoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
 NSLog(@"reloadData");
 dispatch_async(dispatch_get_main_queue(), ^{
 [weakSelf.tableView reloadData];
 });
 
 // 4
 }
 dispatch_group_leave(downloadGroup);
 
 }];
 
 //        dispatch_group_enter(downloadGroup);
 //        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopListTopAd") parameters:nil completed:^(id responseObject, NSError *error) {
 //            if ([responseObject[@"status"] isEqualToString:@"0"]) {
 //                weakSelf.bannerArray = responseObject[@"result"];
 //                [self updataBanner];
 //            }
 //
 //            dispatch_group_leave(downloadGroup);
 //        }];
 
 
 dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
 dispatch_async(dispatch_get_main_queue(), ^{ // 6
 NSLog(@"dismiss");
 [SVProgressHUD dismiss];
 });
 });
 }
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyWord = textField.text;
    
    if ([textField.text isEqualToString:@""] || !textField.text) {
        [self searchButtonClick:_searchButton];
    } else {
        
        [self getStoreListWithLongitude:_longitude latitude:_latitude keyWord:_keyWord page:@"1" refreshType:MJRefreshTypeClear];
    }
    
    return YES;
}


- (IBAction)searchButtonClick:(id)sender {
    UIButton *button = sender;
    button.selected = !button.isSelected;
    
    
    if (button.isSelected) {
        _searchTextField.hidden = NO;
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateSelected];
    } else {
        [_searchTextField resignFirstResponder];
        _searchTextField.hidden = YES;
        [_allStoreArray removeAllObjects];
        _keyWord = @"";
        [self.tableView.mj_header beginRefreshing];
        [button setImage:[UIImage imageNamed:@"fangdajing"] forState:UIControlStateNormal];
    }
}

/*
 - (void)getDataWithKeyWord:(NSString *)keyWord page:(NSString *)page {
 [SVProgressHUD showWithStatus:@"正在获取数据..."];
 NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
 if (_longitude && _latitude && ![_longitude isEqualToString:@""] && ![_latitude isEqualToString:@""]) {
 [params setObject:_longitude forKey:@"longitude"];
 [params setObject:_latitude forKey:@"latitude"];
 }
 if (UserId) {
 [params setObject:UserId forKey:@"user_id"];
 }
 
 //[params setObject:keyWord forKey:@"keyword"];
 //[params setObject:page forKey:@"page"];
 //[params setObject:@"10" forKey:@"page_size"];
 
 NSLog(@"%@",params);
 
 __weak typeof(self) weakSelf = self;
 [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopList") parameters:@{@"token":[params paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
 [SVProgressHUD dismiss];
 [weakSelf.tableView.mj_header endRefreshing];
 
 if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
 
 NSMutableArray *tempArray = [GSStoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
 NSLog(@"reloadData");
 
 [weakSelf.allStoreArray addObjectsFromArray:tempArray];
 dispatch_async(dispatch_get_main_queue(), ^{
 [weakSelf.tableView reloadData];
 if (tempArray.count < 50) {
 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
 //[weakSelf.tableView.footer noticeNoMoreData];
 } else {
 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
 //[weakSelf.tableView.footer endRefreshing];
 }
 });
 
 
 
 
 } else {
 dispatch_async(dispatch_get_main_queue(), ^{
 [_tableView reloadData];
 });
 
 }
 }];
 }
 
 */

- (void)updataBanner {
    NSMutableArray *bannerModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.bannerArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = @{@"img":obj[@"image_url"]};
        [bannerModelArray addObject:dic];
    }];
    if (!_banner) {
        _banner = [[NJBannerView alloc] initWithFrame:CGRectMake(0, 0, Width, _bannerView.frame.size.height)];
        //        NSLog(@"%@",bannerModelArray);
        _banner.datas = bannerModelArray;
        _banner.backgroundColor = [UIColor orangeColor];
        [self.bannerView addSubview:_banner];
    }
    
    
    
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.allStoreArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSNearbyStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfiy forIndexPath:indexPath];
    
    if (indexPath.row < self.allStoreArray.count) {
        GSStoreListModel *storeListModel = self.allStoreArray[indexPath.row];
        if (!storeListModel.distance || [storeListModel.distance isEqualToString:@""]) {
            storeListModel.distance = @"定位成功";
        }
        
        if (!storeListModel.expect_time || [storeListModel.expect_time isEqualToString:@""]) {
            storeListModel.expect_time = @"0";
        } else {
            storeListModel.expect_time = [NSString stringWithFormat:@"%@",storeListModel.expect_time];
        }
        
        cell.storeListModel = storeListModel;
        __weak typeof(self) weakSelf = self;
        [cell setSelectStoreBlock:^(GSStoreListModel *storeModel) {
            [weakSelf didSelectStoreWithStoreModel:storeModel];
        }];
        
    }
    return cell;
}

- (void)didSelectStoreWithStoreModel:(GSStoreListModel *)storeModel {
    GSStoreDetailViewController *storeDetailViewController = ViewController_in_Storyboard(@"Main", @"storeDetailViewController");
    storeDetailViewController.storeModel = storeModel;
    [self.navigationController pushViewController:storeDetailViewController animated:YES];
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
