//
//  GSStoreInfoController.m
//  UISetting
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 jlkj. All rights reserved.
//

#import "GSStoreInfoController.h"
#import "GSStoreEditViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "GSTakePhotoManager.h"
#import "RequestManager.h"
#import "GSBusinessMineViewController.h"
#import "GSIDCardEditViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface GSStoreInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *infoTitleArray;
@property (nonatomic, strong) NSMutableDictionary *infoDataDictionary; //信息字典
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;
@property (nonatomic, copy) NSArray *paramsKeyArray;
@property (nonatomic, strong) UIImage *selectImage;
@property (strong, nonatomic) UIButton *saveButton;
@end

@implementation GSStoreInfoController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 40, Width, 80)];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = _tableView.separatorColor;
        //[footer addSubview:line];
        //        [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.offset(0);
        //            make.left.offset(15);
        //            make.right.offset(-10);
        //            make.height.offset(.5f);
        //        }];
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"re_button_gray"] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"re_button_red"] forState:UIControlStateSelected];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_saveButton setTitle:@"保存修改" forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 8.0f;
        _saveButton.layer.masksToBounds = YES;
        [footer addSubview:_saveButton];
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30);
            make.right.offset(-30);
            make.height.offset(40);
            make.centerX.equalTo(footer.mas_centerX);
            make.centerY.equalTo(footer.mas_centerY);
        }];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _navView.backgroundColor = [UIColor colorWithRed:160.0f/255.0 green:160.0f/255.0 blue:160.0f/255.0 alpha:1];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.size.sizeOffset(CGSizeMake(30, 30));
            make.centerY.equalTo(_navView.mas_centerY).offset(10);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
       titleLab.text = @"小店信息";
        titleLab.textColor = WhiteColor;
        [_navView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_navView.mas_centerY).offset(10);
            make.centerX.equalTo(_navView.mas_centerX);
        }];
    }
    return _navView;
}

- (NSMutableDictionary *)paramsDictionary {
    if (!_paramsDictionary) {
        _paramsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _paramsDictionary;
}

- (NSArray *)paramsKeyArray {
    if (!_paramsKeyArray) {
        _paramsKeyArray = @[@"",@"",@"shop_title",@"shop_address",@"delivery_amount",@"identify_number"];
    }
    return _paramsKeyArray;
}



- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClick:(UIButton *)saveButton {
    if (!saveButton.selected) {
        return;
    }
    if (_selectImage) {
        [self saveHeaderImage];
    } else {
        [self saveSettings];
    }
    
}

- (void)saveHeaderImage {
    [SVProgressHUD showWithStatus:@"正在保存..."];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] uploadImageWithImage:self.selectImage completed:^(id responseObject, NSError *error) {
        
        if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
            
            [weakSelf.paramsDictionary setObject:responseObject[@"result"][@"image_url"] forKey:@"shop_logo"];
            [weakSelf saveSettings];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败,请稍后再试!"];
        }
    }];
}

- (void)saveSettings {
    if (!_selectImage) {
        [SVProgressHUD showWithStatus:@"正在保存..."];
    }
    [self.paramsDictionary setObject:GS_Business_Shop_id forKey:@"shop_id"];
    
    //    NSLog(@"%@",self.paramsDictionary);
    
    __weak typeof(self) weakSelf = self;
    
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/Update") parameters:@{@"token":[_paramsDictionary paramsDictionaryAddSaltString]} completed:^
       (id responseObject, NSError *error) {
        
        if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            GSBusinessMineViewController *mineVC = [self.navigationController viewControllers][0];
            mineVC.getUserInfoSuccess = NO;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败,请稍后再试!"];
        }
    }];
}



- (void)viewDidLoad {
    [self loadData];
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
}

-(void)loadData{
    self.titleArray = [NSMutableArray arrayWithObjects:@"头像",@"账号",@"小店名称",@"地址",@"起送金额",@"绑定身份证", nil];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row==0) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.tag = 100;
        imageV.frame = CGRectMake(Width-90, 10, 60, 60);
        
        if (self.selectImage) {
            imageV.image = _selectImage;
        } else {
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:self.infoDataDictionary[_infoTitleArray[indexPath.row]]]];
        }
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = 30.0f;
        [cell.contentView addSubview:imageV];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }  else {
        [[cell.contentView viewWithTag:100] removeFromSuperview];
    }
    if (self.paramsDictionary[self.paramsKeyArray[indexPath.row]] && ![self.paramsDictionary[self.paramsKeyArray[indexPath.row]] isEqualToString:@""]) {
        cell.detailTextLabel.text = self.paramsDictionary[self.paramsKeyArray[indexPath.row]];
    } else {
        cell.detailTextLabel.text = self.infoDataDictionary[_infoTitleArray[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {//头像
            __weak typeof(self) weakSelf = self;
            [GSTakePhotoManager sharePicture:^(UIImage *image) {
                weakSelf.selectImage = image;
            }];
        }
            break;
            
        case 1: {//账号（不能修改）
            
            
        }
            break;
            
        case 2: {//小店名称
            
            [self pushEditViewControllerWithTitle:@"小店名称" text:cell.detailTextLabel.text maxEditLength:40  commitBlock:^(NSString *commitString) {
                
                [self gs_setParamsObject:commitString forKey:@"shop_title"];
                
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }
            break;
            
        case 3: {//地址
            [self pushEditViewControllerWithTitle:@"地址" text:cell.detailTextLabel.text maxEditLength:100 commitBlock:^(NSString *commitString) {
                [self gs_setParamsObject:commitString forKey:@"shop_address"];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }
            break;
            
        case 4: {//起送金额
            [self pushEditViewControllerWithTitle:@"起送金额" text:cell.detailTextLabel.text maxEditLength:10 commitBlock:^(NSString *commitString) {
                [self gs_setParamsObject:commitString forKey:@"delivery_amount"];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
        }
            break;
            
        case 5: {//绑定身份证
            GSIDCardEditViewController *cardEditViewController = ViewController_in_Storyboard(@"Main", @"idCardEditViewController");
            cardEditViewController.name = _userModel.true_name;
            cardEditViewController.idNumber = _userModel.identify_number;
            cardEditViewController.commitBlock = ^(NSString *commitName, NSString *commitNumber) {
                if (commitName && ![commitName isEqualToString:@""]) {
                    [self gs_setParamsObject:commitName forKey:@"true_name"];
                }
                
                if (commitNumber && ![commitNumber isEqualToString:@""]) {
                    [self gs_setParamsObject:commitNumber forKey:@"identify_number"];
                }
                [_tableView reloadData];
            };
            
            [self.navigationController pushViewController:cardEditViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (void)gs_setParamsObject:(NSString *)object forKey:(NSString *)key {
    NSString *oldValue = nil;
    if ([key isEqualToString:@"shop_address"]) {
        
        
        oldValue = [_userModel valueForKey:@"shopaddress"];
        
        
    } else {
        
        oldValue = [_userModel valueForKey:key];
    }
    
    if ([object isEqualToString:oldValue]) {
        [self.paramsDictionary removeObjectForKey:key];
    } else {
        [self.paramsDictionary setValue:object forKey:key];
    }
    
    if (!_selectImage && _paramsDictionary.count == 0) {
        _saveButton.selected = NO;
    } else {
        _saveButton.selected = YES;
    }
}

- (void)pushEditViewControllerWithTitle:(NSString *)titleText text:(NSString *)text maxEditLength:(NSInteger)maxEditLength commitBlock:(void(^)(NSString *commitString))commitBlock {
    GSStoreEditViewController *editVC = ViewController_in_Storyboard(@"Main", @"storeEditViewController");
    
    editVC.titleText = titleText;
    editVC.maxStringLength = maxEditLength;
    if (text && ![text isEqualToString:@""]) {
        editVC.text = text;
    }
    editVC.commitBlock = commitBlock;
    
    [self.navigationController pushViewController:editVC animated:YES];
}


- (void)setSelectImage:(UIImage *)selectImage {
    
    if (selectImage) {
        _selectImage = selectImage;
        _saveButton.selected = YES;
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 80;
    }
    return 40;
}

- (void)setUserModel:(GSBusinessUserModel *)userModel {
    _userModel = userModel;
    
    if (!self.infoDataDictionary) {
        self.infoDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (!self.infoTitleArray) {
        self.infoTitleArray = [NSMutableArray arrayWithObjects:@"header",@"phone",@"storeTitle",@"address",@"minPrice",@"cardID", nil];
    }
    
    
    [self infoDataDictionarySetObject:userModel.shoplogo forKey:_infoTitleArray[0]];
    [self infoDataDictionarySetObject:userModel.shop_phone forKey:_infoTitleArray[1]];
    [self infoDataDictionarySetObject:userModel.shop_title forKey:_infoTitleArray[2]];
    [self infoDataDictionarySetObject:userModel.shopaddress forKey:_infoTitleArray[3]];
    [self infoDataDictionarySetObject:userModel.delivery_amount forKey:_infoTitleArray[4]];
    [self infoDataDictionarySetObject:userModel.identify_number forKey:_infoTitleArray[5]];
    
}

- (void)infoDataDictionarySetObject:(NSString *)object forKey:(NSString *)key {
    if (object && ![object isEqualToString:@""]) {
        [_infoDataDictionary setObject:object forKey:key];
    }else {
        if ([key isEqualToString:@"cardID"]) {
            [_infoDataDictionary setObject:@"未绑定" forKey:key];
        } else {
            [_infoDataDictionary setObject:@"" forKey:key];
        }
    }
    
    
}
@end
