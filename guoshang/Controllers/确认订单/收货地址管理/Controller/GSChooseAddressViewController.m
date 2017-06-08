//
//  GSChooseAddressViewController.m
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChooseAddressViewController.h"
#import "GSChooseAddressTableViewCell.h"
#import "MBProgressHUD.h"
#import "RequestManager.h"
#import "GSChackOutOrderViewController.h"
#import "GSAddAddressViewController.h"


@interface GSChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource,GSChooseAddressTableViewCellDelegate,GSAddAddressViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@end

@implementation GSChooseAddressViewController

#pragma mark - getter
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingTableView];
    [self loadAddressData];
}

- (void)settingTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 45.0f;
}

#pragma mark - 请求用户收货地址
- (void)loadAddressData {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/myaddress") parameters:[@{@"user_id":UserId} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if (responseObject && responseObject[@"result"]) {
            weakSelf.dataSourceArray = [GSChackOutOrderAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:nil animated:YES];
            [weakSelf.tableView reloadData];
        });
        
    }];
}


- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)addNewAddressInfoButtonClick:(id)sender {
    [self pushToEditAddressWithAddressModel:nil];
}

#pragma mark - 跳转到添加收货地址界面

- (void)pushToEditAddressWithAddressModel:(GSChackOutOrderAddressModel *)addressModel {
    GSAddAddressViewController *addAddressViewController = ViewController_in_Storyboard(@"Main", @"GSAddAddressViewController");
    addAddressViewController.delegate = self;
    addAddressViewController.addressModel = addressModel;
    [self.navigationController pushViewController:addAddressViewController animated:YES];
}

#pragma mark - GSAddAddressViewControllerDelegate

- (void)addAddressViewControllerDidFinishAddAddress:(GSChackOutOrderAddressModel *)addressModel {
    if ([_delegate respondsToSelector:@selector(chooseAddressViewControllerDidSelectAddress:)]) {
        [_delegate chooseAddressViewControllerDidSelectAddress:addressModel];
        [[self.navigationController viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GSChackOutOrderViewController class]]) {
                [self.navigationController popToViewController:obj animated:YES];
            }
        }];
    } else {
        [self loadAddressData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - GSChooseAddressTableViewCellDelegate

- (void)editWithAddressInfoWithAddressModel:(GSChackOutOrderAddressModel *)addressModel {
    [self pushToEditAddressWithAddressModel:addressModel];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSChooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSChooseAddressTableViewCell"];
    if (indexPath.row < self.dataSourceArray.count) {
        GSChackOutOrderAddressModel *addressModel = self.dataSourceArray[indexPath.row];
        
        cell.addressModel = addressModel;
        cell.delegate = self;
        
        if ([addressModel.address_id isEqualToString:self.selectAddressID]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(chooseAddressViewControllerDidSelectAddress:)]) {
        GSChooseAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell || ![cell.addressModel.address_id isEqualToString:self.selectAddressID]) {
            if (self.dataSourceArray.count > indexPath.row) {
                self.view.userInteractionEnabled = NO;
                [self performSelector:@selector(delegateRespondsAfterDealyWithAddressModel:) withObject:self.dataSourceArray[indexPath.row] afterDelay:.5f];
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArray.count) {
        GSChackOutOrderAddressModel *addressModel = self.dataSourceArray[indexPath.row];
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"?m=Api&c=User&a=deladdress") parameters:[@{@"user_id":UserId,@"address_id":addressModel.address_id} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUDForView:nil animated:YES];
            
            if (responseObject && [responseObject[@"status"] isEqualToNumber:@(0)]) {
                [weakSelf.dataSourceArray removeObject:addressModel];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除收货地址成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"删除收货地址失败,请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSChooseAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.addressModel.address_id isEqualToString:self.selectAddressID]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - 延迟执行代理
- (void)delegateRespondsAfterDealyWithAddressModel:(GSChackOutOrderAddressModel *)addressModel {
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate chooseAddressViewControllerDidSelectAddress:addressModel];
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
