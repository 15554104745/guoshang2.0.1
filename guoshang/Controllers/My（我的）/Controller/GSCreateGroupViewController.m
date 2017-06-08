//
//  GSCreateGroupViewController.m
//  guoshang
//
//  Created by Rechied on 16/8/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCreateGroupViewController.h"
#import "GSGroupDetailModel.h"
#import "GSGroupGoodsInfoModel.h"
#import "UIImageView+WebCache.h"
#import "GSGroupRuleModel.h"
#import "RequestManager.h"
#import "GSMyGroupListModel.h"
#import "GSCreateGroupTableViewCell.h"
#import "GSCreateGroupLeftTableViewCell.h"
#import "UITableView+MJRefresh.h"
#import "MBProgressHUD.h"
#import "GSGroupWillCreateModel.h"
#import "GroupInfoViewController.h"
#import "GSGroupInfoViewController.h"
#import "UIColor+HaxString.h"
@interface GSCreateGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
/*
 @property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
 
 @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *markt_priceLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *groupTypeLabel;
 */

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lineView;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIButton *lastButton;

@property (assign, nonatomic) BOOL tableShow;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (strong, nonatomic) NSMutableArray *leftDataSouceArray;

//@property (nonatomic,strong) GSGroupDetailModel *detailModel;
@end

@implementation GSCreateGroupViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSCreateGroupViewController");
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self loadData];
    [self createTableViews];
    [self createLeftTableViewRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)leftDataSouceArray {
    if (!_leftDataSouceArray) {
        _leftDataSouceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leftDataSouceArray;
}

- (void)createLeftTableViewRefresh {
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    
    MJRefreshRequestModel *requestModel = [MJRefreshRequestModel refreshModelWithURL:URLDependByBaseURL(@"/Api/Groupon/waitStartGroup") dataArray:self.leftDataSouceArray listRows:10 params:@{@"page_size":@"10",} pagePropertyName:@"page" startPageNumber:1];
    
    [self.leftTableView addRefreshWithRequestModel:requestModel requestKey:@"leftTableRequest"];
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.leftTableView headerBeginRefreshWithRequestKey:@"leftTableRequest" result:^(id responseObject, NSError *error, MJRefreshType refreshType) {
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        if (refreshType == MJRefreshTypeClear) {
            [weakSelf.leftDataSouceArray removeAllObjects];
        }
        
        
        if (responseObject && [responseObject[@"result"] count] != 0) {
            NSArray *tempArray = [GSGroupWillCreateModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [weakSelf.leftDataSouceArray addObjectsFromArray:tempArray];
        } else {
            [weakSelf.leftTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.leftTableView reloadData];
        
    }];
}


- (void)createTableViews {
    
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedRowHeight = 210.0f;
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMyGroupListDataWithRefreshType:MJRefreshTypeClear page:@"1"];
    }];
    
}

- (void)createRefreshFooter {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [weakSelf getMyGroupListDataWithRefreshType:MJRefreshTypeAdd page:[NSString stringWithFormat:@"%zi",weakSelf.dataSourceArray.count / 5 + 1]];
    }];
    
    if (self.dataSourceArray.count < 5) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)getMyGroupListDataWithRefreshType:(MJRefreshType)refreshType page:(NSString *)page {
    __weak typeof(self) weakSelf = self;
    //    NSLog(@"%@",[@{@"user_id":UserId,@"page":page} addSaltParamsDictionary]);
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Groupon/myGroup") parameters:[@{@"user_id":UserId,@"page":page} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (refreshType == MJRefreshTypeClear) {
            [weakSelf.dataSourceArray removeAllObjects];
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        
        if (responseObject && responseObject[@"result"]) {
            [weakSelf.dataSourceArray addObjectsFromArray:[GSMyGroupListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]]];
            if ([responseObject[@"result"] count] < 5) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
        if (!weakSelf.tableShow) {
            [weakSelf createRefreshFooter];
            weakSelf.tableShow = YES;
        }
    }];
}

- (IBAction)topSlideButtonClick:(UIButton *)sender {
    [self scrollWithClickButton:sender refresh:NO animated:YES];
}

- (void)scrollWithClickButton:(UIButton *)sender refresh:(BOOL)refresh animated:(BOOL)animated {
    if (self.lastButton) {
        self.lastButton.userInteractionEnabled = YES;
        [self.lastButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self.createGroupButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    
    [sender setTitleColor:[UIColor colorWithHexString:@"e73736"] forState:UIControlStateNormal];
    if (sender.tag == 11) {
        if (!self.tableShow) {
            [self.tableView.mj_header beginRefreshing];
        } else {
            if (refresh) {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }
    self.lastButton = sender;
    sender.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.center = CGPointMake(sender.center.x, _lineView.center.y);
    }];
    
    [self.scrollView setContentOffset:CGPointMake((sender.tag - 10) * Width, 0) animated:animated];
}

- (void)scrollToMyGroupWithRefresh:(BOOL)refresh {
    if ([self.view viewWithTag:11] && [[self.view viewWithTag:11] isKindOfClass:[UIButton class]]) {
        [self scrollWithClickButton:[self.view viewWithTag:11] refresh:refresh animated:NO];
    }
}


- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)AlertWithTitle:(NSString*) message {
    __weak typeof(self) weakSelf = self;
    [AlertTool alertTitle:@"温馨提示" mesasge:message preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        weakSelf.navigationController.navigationBarHidden= NO;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } viewController:self];
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftDataSouceArray.count;
    } else {
        return self.dataSourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        GSCreateGroupLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSCreateGroupLeftTableViewCell" forIndexPath:indexPath];
        if (self.leftDataSouceArray.count > indexPath.row) {
            cell.groupModel = self.leftDataSouceArray[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [cell setCreateBlock:^(NSString *group_id) {
                GroupInfoViewController *infoViewController = [[GroupInfoViewController alloc] init];
                infoViewController.hidesBottomBarWhenPushed = YES;
                infoViewController.tuan_id = group_id;
                [weakSelf.navigationController pushViewController:infoViewController animated:YES];
            }];
        }
        return cell;
    } else {
        GSCreateGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupViewCell" forIndexPath:indexPath];
        if (indexPath.row < self.dataSourceArray.count) {
            cell.groupListModel = self.dataSourceArray[indexPath.row];
        }
        return cell;
    }
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
