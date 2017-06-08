//
//  GSChooseAddressManager.m
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChooseAddressManager.h"
#import "GSChooseAddressInfoCell.h"
#import "UIColor+HaxString.h"

#import "RequestManager.h"
#import "MBProgressHUD.h"
#import "ChooseLocationView.h"


#define ContentViewHeight Height * 0.6f

@interface GSChooseAddressManager()<UITableViewDelegate,UITableViewDataSource,ChooseLocationViewDelegate>

@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (strong, nonatomic) ChooseLocationView *chooseLocationView;
@end

@implementation GSChooseAddressManager

+ (instancetype)manager {
    GSChooseAddressManager *manager = [[GSChooseAddressManager alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    return manager;
}

- (void)createCover {
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.coverView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.4f];
    self.coverView.alpha = 0.0f;
    [self addSubview:_coverView];
}

- (void)createContent {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Height, Width, ContentViewHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
}

- (void)createTopToolView {
    UIView *toolView = [[UIView alloc] init];
    [self.contentView addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(44);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择收货地址";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"E73736"];
    [toolView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolView.mas_centerX);
        make.centerY.equalTo(toolView.mas_centerY);
    }];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.width.offset(40);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"E73736"];
    [toolView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.offset(.5f);
    }];
    
    UIButton *addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addNewAddressButton.backgroundColor = [UIColor colorWithHexString:@"E73736"];
    [addNewAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addNewAddressButton addTarget:self action:@selector(addNewAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addNewAddressButton];
    [addNewAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.offset(40);
    }];
}

- (void)createAddressTable {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 52.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"GSChooseAddressInfoCell" bundle:nil] forCellReuseIdentifier:@"GSChooseAddressInfoCell"];
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(44);
        make.left.right.mas_offset(0);
        make.bottom.offset(-40);
    }];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

#pragma mark - 请求用户收货地址
- (void)loadAddressData {
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/myaddress") parameters:[@{@"user_id":UserId} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if (responseObject && responseObject[@"result"]) {
            weakSelf.dataSourceArray = [GSChackOutOrderAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            [weakSelf.tableView reloadData];
        });
        
    }];
}

#pragma mark - 显示选择器
- (void)showChooseAddressControl {
    [self createCover];
    [self createContent];
    [self createTopToolView];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    [self createAddressTable];
    [self loadAddressData];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.coverView.alpha = 1.0f;
        weakSelf.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, - ContentViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 新增收货地址 选择省份 城市 区/县
- (void)showAddNewAddressControl {
    
    
    [self createCover];
    
    self.chooseLocationView = [[ChooseLocationView alloc] initWithFrame:CGRectMake(0, Height, Width, ContentViewHeight) notShowUserAddress:YES];
    _chooseLocationView.backgroundColor = [UIColor whiteColor];
    _chooseLocationView.delegate = self;
    [self addSubview:_chooseLocationView];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.coverView.alpha = 1.0f;
        weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(self.chooseLocationView.transform, 0, - ContentViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ChooseLocationViewDelegate

- (void)chooseLocationViewDidFinishSelected:(NSDictionary *)addressInfo {
    
    if ([_delegate respondsToSelector:@selector(chooseAddressManager:didFinishSelectAddressInfo:)]) {
        [_delegate chooseAddressManager:self didFinishSelectAddressInfo:addressInfo];
    }
    [self close];
}

- (void)chooseLocationViewDidClose {
    [self close];
}

#pragma mark - 关闭选择器
- (void)close {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.coverView.alpha = 0;
        if (weakSelf.contentView) {
            weakSelf.contentView.transform = CGAffineTransformIdentity;
        }
        
        if (weakSelf.chooseLocationView) {
            weakSelf.chooseLocationView.transform = CGAffineTransformIdentity;
        }
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Button Click Functions

- (void)closeClick {
    [self close];
}

- (void)addNewAddressButtonClick {
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArray.count) {
        GSChackOutOrderAddressModel *addressModel = self.dataSourceArray[indexPath.row];
        self.selectAddressID = addressModel.address_id;
        if ([_delegate respondsToSelector:@selector(chooseAddressManager:didSelectAddress:)]) {
            self.userInteractionEnabled = NO;
            [self performSelector:@selector(respondsDelegateWithAddressModel:) withObject:addressModel afterDelay:.5];
        }
    }
}

- (void)respondsDelegateWithAddressModel:(GSChackOutOrderAddressModel *)addressModel {
    [_delegate chooseAddressManager:self didSelectAddress:addressModel];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSChooseAddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSChooseAddressInfoCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSourceArray.count) {
        GSChackOutOrderAddressModel *addressModel = self.dataSourceArray[indexPath.row];
        cell.addressModel = addressModel;
        
        if ([addressModel.address_id isEqualToString:self.selectAddressID]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

@end
