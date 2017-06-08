//
//  GSNewMineViewController.m
//  guoshang
//
//  Created by Rechied on 2016/10/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewMineViewController.h"
#import "GSMineTopUserInfoView.h"
#import "UIScrollView+HeaderScaleImage.h"
#import "SetUpViewController.h"
#import "GSMineCollectionViewCell.h"
#import "GSMineToolsModel.h"
#import "WKProgressHUD.h"
#import "SLFRechargeViewController.h"
#import "MyOrderViewController.h"

typedef NS_ENUM(NSInteger, GSMineToolButtonType) {
    GSMineToolButtonTypeNonPayment = 1, //待付款
    GSMineToolButtonTypeWaitDelivery,   //待发货
    GSMineToolButtonTypeUnconfirmed,    //待确认
    GSMineToolButtonTypeFinished,       //已完成
};

@interface GSNewMineViewController ()<GSMineTopUserInfoViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet GSMineTopUserInfoView *topUserInfoView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *toolsModelArray;

@property (assign, nonatomic) BOOL isGuideUserType;

@end

@implementation GSNewMineViewController

- (NSMutableArray *)toolsModelArray {
    if (!_toolsModelArray) {
        _toolsModelArray = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"我的收藏",@"我的资产",@"我的推广",@"我的充值卡",@"修改密码",@"浏览记录",@"我的团购"];
        NSArray *iconNames = @[@"re_myCenter_top1",@"re_myCenter_top2",@"re_myCenter_top3",@"re_myCenter_bottom1",@"re_myCenter_bottom2",@"re_myCenter_bottom3",@"re_group1"];
        NSArray *viewControllerClasses = @[@"MyCollectViewController",@"MyPropertyViewController",@"MyPopularizeViewController",@"SLFRechargeViewController",@"changePasswordViewController",@"MyHistoryViewController",@"GSGroupOrderViewController"];
        for (NSInteger i = 0; i < 7; i ++) {
            GSMineToolsModel *mineToolModel = [[GSMineToolsModel alloc] init];
            mineToolModel.title = titles[i];
            mineToolModel.iconName = iconNames[i];
            mineToolModel.viewControllerClassName = viewControllerClasses[i];
            [_toolsModelArray addObject:mineToolModel];
        }
    }
    return _toolsModelArray;
}

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSNewMineViewController");

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.topUserInfoView reloadData];
    if ([self isGuideUser] && !_isGuideUserType) {
        GSMineToolsModel *guideModel = [[GSMineToolsModel alloc] init];
        guideModel.title = @"去开团";
        guideModel.iconName = @"re_group1";
        guideModel.viewControllerClassName = @"GSCreateGroupViewController";
        [self.toolsModelArray replaceObjectAtIndex:self.toolsModelArray.count - 1 withObject:guideModel];
        _isGuideUserType = YES;
        [self.collectionView reloadData];
    } else {
        if (_isGuideUserType) {
            GSMineToolsModel *guideModel = [[GSMineToolsModel alloc] init];
            guideModel.title = @"我的团购";
            guideModel.iconName = @"re_group2";
            guideModel.viewControllerClassName = @"GSGroupOrderViewController";
            [self.toolsModelArray replaceObjectAtIndex:self.toolsModelArray.count - 1 withObject:guideModel];
            _isGuideUserType = NO;
            [self.collectionView reloadData];
        }
    }
}

- (void)setupUI {
    [self createItems];
    self.scrollView.yz_headerScaleImage = [UIImage imageNamed:@"icon_mine_topbg"];
    self.scrollView.yz_headerScaleImageHeight = 400 * Width / 750;
}


-(void)createItems{
    
    UIBarButtonItem * back = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(navigationBarBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * idit = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarSettingButtonClick)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = idit;
    
}

#pragma mark - Action 
- (void)navigationBarBackButtonClick {
    
}

- (void)navigationBarSettingButtonClick {
    SetUpViewController * setUp = [[SetUpViewController alloc] init];
    setUp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setUp animated:YES];
}

//我的订单
- (IBAction)myOrderClick:(id)sender {
    if ([self isLoginSuccess]) {
        MyOrderViewController * orderView = [[MyOrderViewController alloc]init];
        orderView.hidesBottomBarWhenPushed = YES;
        orderView.informNum = 0;
        [self.navigationController pushViewController:orderView animated:YES];
    }
}

//待付款 待发货 待确认 已完成
- (IBAction)toolBarButtonClick:(UIButton *)sender {
    if ([self isLoginSuccess]) {
        GSMineToolButtonType toolButtonType = sender.tag - 10;
        MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
        orderView.hidesBottomBarWhenPushed = YES;
        orderView.informNum = toolButtonType;
        [self.navigationController pushViewController:orderView animated:YES];
    }
}

- (IBAction)callClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008931880"]];
}








#pragma mark - GSMineTopUserInfoViewDelegate
- (void)topUserInfoViewWillPushViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[NSClassFromString(@"GSNewLoginViewController.h") class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.toolsModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item < self.toolsModelArray.count) {
        cell.toolsModel = self.toolsModelArray[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Width/3, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLoginSuccess]) {
        if (indexPath.item < self.toolsModelArray.count) {
            GSMineToolsModel *model = self.toolsModelArray[indexPath.item];
            UIViewController *viewController = [[NSClassFromString(model.viewControllerClassName) alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            if ([viewController isKindOfClass:[SLFRechargeViewController class]]) {
                SLFRechargeViewController *rechargeViewController = (SLFRechargeViewController *)viewController;
                rechargeViewController.tap = 1;
                [self.navigationController pushViewController:rechargeViewController animated:YES];
            } else {
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    
}

#pragma mark - 判断是否登陆
- (BOOL)isLoginSuccess {
    if (!UserId) {
        [AlertTool alertMesasge:@"请先登录" confirmHandler:nil viewController:self];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isGuideUser {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isGuide"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGuide"] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
