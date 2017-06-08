//
//  GSBusinessMineViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessMineViewController.h"
#import "GSMineTabCell.h"
#import "GSPropertyView.h"
#import "GSMineHeaderView.h"
#import "RequestManager.h"
#import "GSNslogDictionaryManager.h"
#import "GSBusinessUserInfoModel.h"
#import "WKProgressHUD.h"
#import "SVProgressHUD.h"
#import "GSBusinessUserModel.h"
#import "GSStoreInfoController.h"

#import "GSTabbarController.h"
#import "TransactionViewController.h"
#import "GSOrderInfoViewController.h"

static NSString *mineTabCellId = @"mineTabCell";

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface GSBusinessMineViewController ()<UITableViewDelegate,UITableViewDataSource,GSMineHeaderViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) GSMineHeaderView *mineHeaderView;

@property (strong, nonatomic) GSBusinessUserInfoModel *userInfoModel;
@property (strong, nonatomic) GSBusinessUserModel *userModel;
//@property (assign, nonatomic) BOOL navigationBarHiden;
@end

@implementation GSBusinessMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    

    
    
     [self getBusinessUserData];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"backback" object:nil];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        self.getUserInfoSuccess = YES;
//    });

    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self getBusinessUserData];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-20);
        make.left.right.bottom.mas_offset(0);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GSMineTabCell" bundle:nil] forCellReuseIdentifier:mineTabCellId];
        
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.mineHeaderView;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableFooterView = view;
    }  
    return _tableView;
}

- (GSMineHeaderView *)mineHeaderView {
    if (!_mineHeaderView) {
        _mineHeaderView = [[GSMineHeaderView alloc] initWithHeight:375.0f];
        _mineHeaderView.delegate = self;
        [self setPropertyButtonClick];
    }
    return _mineHeaderView;
}

#pragma mark - 获取商家信息
- (void)getBusinessUserData {
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:@"加载中" animated:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD showWithStatus:@"正在加载信息..."];
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@",GS_Business_Shop_id];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopInfo") parameters:@{@"token":encryptString} completed:^(id responseObject, NSError *error) {
        
        if (responseObject[@"status"] && [responseObject[@"status"] isEqualToString:@"0"]) {
            [hud dismiss:YES];
            _getUserInfoSuccess = YES;
            [SVProgressHUD dismiss];
            //[responseObject[@"result"] logDictionary];
            //[GSNslogDictionaryManager logDictionary:responseObject[@"result"]];
            weakSelf.userModel = [GSBusinessUserModel mj_objectWithKeyValues:responseObject[@"result"]];
        } else {
//            [SVProgressHUD dismiss];
            [hud dismiss:YES];
            [SVProgressHUD showErrorWithStatus:@"您的店铺还没有审核通过哟!"];
            [weakSelf backClick];
        }
    }];
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
                
                
                [weakSelf setUserInfoModel:[GSBusinessUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]]];
            }
        }];
    }
    
}

- (void)setUserModel:(GSBusinessUserModel *)userModel {
    _userModel = userModel;
    [_mineHeaderView.userView setHeader:userModel.shoplogo name:userModel.shop_title num:userModel.shop_phone];
    [_mineHeaderView.propertyView setGoldNum:userModel.user_money guobiNum:userModel.pay_points topupCardNum:userModel.rechargeable_card_money];
    [_mineHeaderView setBabyNumberWithAll:userModel.goods_num new:userModel.now_num guanZhuNum:userModel.collect_num];
}

- (void)setUserInfoModel:(GSBusinessUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    [_mineHeaderView.propertyView setGoldNum:userInfoModel.user_money_org guobiNum:userInfoModel.pay_points_org topupCardNum:userInfoModel.rechargeable_card_money];
    [_mineHeaderView.userView setHeader:nil name:userInfoModel.store_user_name num:userInfoModel.mobile_phone];
}

#pragma mark - GSMineHeaderViewDelegate
- (void)GSMineHeaderView:(GSMineHeaderView *)headerView didClickDetailButton:(UIButton *)button {
    
    GSStoreInfoController *storeInfo = [[GSStoreInfoController alloc] init];
    storeInfo.userModel = self.userModel;
    [self.navigationController pushViewController:storeInfo animated:YES];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSMineTabCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTabCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.leftImageView.image = [UIImage imageNamed:@"re_icon_cell_0"];
        cell.titleLabel.text = @"我的订单";
    }
    
    if (indexPath.row == 1) {
        cell.leftImageView.image = [UIImage imageNamed:@"re_icon_cell_1"];
        cell.titleLabel.text = @"交易明细";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        TransactionViewController *transVC = [[TransactionViewController alloc]init];
        [self.navigationController pushViewController:transVC animated:YES];
    }else if (indexPath.row==0){
        GSOrderInfoViewController * orderView = [[GSOrderInfoViewController alloc] init];
        orderView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderView animated:YES];
 
    }
}

- (void)setPropertyButtonClick {
    _mineHeaderView.propertyView.propertyButtonClickBlock = ^(NSInteger index) {
        switch (index) {
            case 0://金币
                
                break;
                
            case 1://国币
                
                break;
                
            case 2://充值卡
                
                break;
                
            default:
                break;
        }
    };
}

- (void)backClick {
    GSTabbarController *gsTabbar = [[GSTabbarController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:gsTabbar];
    mainNav.navigationBarHidden = YES;
    [UIView beginAnimations:@"trans" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[UIApplication sharedApplication].delegate window] cache:NO];
    [[UIApplication sharedApplication].delegate window].rootViewController = mainNav;
    [UIView commitAnimations];
    //[self.navigationController popViewControllerAnimated:YES];
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
