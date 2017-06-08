//
//  GSNearbyShopListViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNearbyShopListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RequestManager.h"
#import "GSStoreListModel.h"
#import "GSNslogDictionaryManager.h"

#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0
#import "SVProgressHUD.h"
@interface GSNearbyShopListViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
@property (weak, nonatomic) IBOutlet UILabel *topLocationLabel;

@property (strong, nonatomic) NSMutableArray *allStoreArray;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) GSStoreListModel *nearbyModel;

@property (assign, nonatomic) BOOL locationFinished;
@property (assign, nonatomic) BOOL requestFinished;
@property (assign, nonatomic) BOOL nearbyIsHaveStore;
@end

@implementation GSNearbyShopListViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在获取门店信息..."];
    //[self getAllStoreList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 8;
    
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 8;
    
    self.bottomTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    [self startLocation];
    
    
    
    
    
}

- (void)setLocationFinished:(BOOL)locationFinished {
    _locationFinished = locationFinished;
    [self updataHUD];
}

- (void)setRequestFinished:(BOOL)requestFinished {
    _requestFinished = requestFinished;
    [self updataHUD];
}

- (void)updataHUD {
    if (self.locationFinished && self.requestFinished) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allStoreArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GSStoreListModel *model = self.allStoreArray[indexPath.row];
    
    cell.textLabel.text = model.shopaddress;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}



#pragma mark - 定位
- (void)startLocation {
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
//        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
//    NSLog(@"经纬度：%lf,%lf",location.coordinate.latitude,location.coordinate.longitude);
    
    [self getStoreListWithLongitude:[NSString stringWithFormat:@"%lf",location.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf",location.coordinate.latitude]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.locationFinished = YES;
    _topLocationLabel.text = @"获取位置失败";
}

- (void)getStoreListWithLongitude:(NSString *)longitude latitude:(NSString *)latitude {
    [SVProgressHUD showWithStatus:@"正在获取附近门店..."];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (longitude && latitude && ![longitude isEqualToString:@""] && ![latitude isEqualToString:@""]) {
        [params setObject:longitude forKey:@"longitude"];
        [params setObject:latitude forKey:@"latitude"];
    }
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopList") parameters:nil completed:^(id responseObject, NSError *error) {
        weakSelf.locationFinished = YES;
        if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
            
            if (responseObject[@"result"] && [responseObject[@"result"] count] > 0) {
                weakSelf.nearbyModel = [GSStoreListModel mj_objectWithKeyValues:responseObject[@"result"][0]];
            } else {
                weakSelf.topLocationLabel.text = @"该位置附近暂无商家入驻";
            }
            
            
        }
    }];
}

- (void)getAllStoreList {
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopList") parameters:nil completed:^(id responseObject, NSError *error) {
        weakSelf.requestFinished = YES;
        if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
            weakSelf.allStoreArray = [GSStoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [weakSelf.bottomTableView reloadData];
        }
        
    }];
}


- (void)setNearbyModel:(GSStoreListModel *)nearbyModel {
    _nearbyModel = nearbyModel;
    
    self.topLocationLabel.text = nearbyModel.shopaddress;
    self.nearbyIsHaveStore = YES;
}

#pragma mark - 附近门店按钮点击后调用
- (IBAction)nearBtnClick:(id)sender {
    if (!self.nearbyIsHaveStore) {
        return;
    } else {
//        NSLog(@"定位数据被点击");
    }
    
}

#pragma mark - tableView选中后跳转到商家详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
