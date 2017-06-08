//
//  GSStoreDetailViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSStoreDetailViewController.h"

#import "CFPicCarousView.h"
#import "CFPicModel.h"
#import "GSStoreDetailCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "GSStoreGoodsModel.h"
#import "GoodsListViewController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "GSStoreDetailCollectionFlowViewCell.h"
#import "GSBusinessDetailViewController.h"
#import "GoodsShowViewController.h"
#import "GSStoreCategoryModel.h"
#import "MJRefresh.h"
#import "GSGoodsDetailInfoViewController.h"
static NSString *collectionViewCellidenterfiy = @"storeGoodsCollectionViewCell";

@interface GSStoreDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateWaterfallLayout,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *collectionBackView;

@property (weak, nonatomic) IBOutlet UIView *categoryView;

@property (strong, nonatomic) UILabel *noCategoryLabel;
@property (nonatomic,copy) NSString  *shop_id;

@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *minDistributionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distributionMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet CFPicCarousView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (copy, nonatomic) NSString *keyword;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) UICollectionView *collectionFlowView;
@property (strong, nonatomic) NSMutableArray *categoryArray;

@property (assign, nonatomic) BOOL isHideTabBar;
@end

@implementation GSStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shopLogoImageView.layer.masksToBounds = YES;
    _shopLogoImageView.layer.cornerRadius = 30;
//    _shopLogoImageView.backgroundColor = [UIColor orangeColor];
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 5;
    [self getData];
    
    
}

- (UICollectionView *)collectionFlowView {
    if (!_collectionFlowView) {
        UICollectionViewWaterfallLayout *layOut = [[UICollectionViewWaterfallLayout alloc] init];
        layOut.delegate = self;
        layOut.columnCount = 2;
        layOut.itemWidth = (Width - 30)/ 2;
        layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        CGFloat y = (68.0f*Width/360.0f) + 64 +100 + 60 +30;
        _collectionFlowView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, Width, Height - y - 49) collectionViewLayout:layOut];
        _collectionFlowView.delegate = self;
        _collectionFlowView.backgroundColor = [UIColor whiteColor];
        _collectionFlowView.dataSource = self;
        _collectionFlowView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _searchTextField.text = @"";
            _keyword = @"";
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"正在获取数据"];
            [self.dataSourceArray removeAllObjects];
            [self getDataWithKeyWord:@"" page:@"1"];
        }];
        
        _collectionFlowView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"正在获取数据"];
            [self getDataWithKeyWord:_keyword page:[NSString stringWithFormat:@"%zi",[self.dataSourceArray count]/10 + 1]];
        }];
        
        [_collectionFlowView registerNib:[UINib nibWithNibName:@"GSStoreDetailCollectionFlowViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellidenterfiy];
    }
    return _collectionFlowView;
}



- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _categoryArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //_shop_id =_storeModel.shop_id;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.tabBarController.tabBar.isHidden) {
        _isHideTabBar = YES;
        self.tabBarController.tabBar.hidden = NO;
    }
    
    
    //self.tabBarController.tabBar.hidden = NO;
    if (_storeModel.shop_phone && ![_storeModel.shop_phone isEqualToString:@""]) {
        [self setupData];
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupData {
    
    UIImage *aImage = [UIImage imageNamed:@"fangdajing"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:aImage];
    imageView.transform = CGAffineTransformMakeScale(-1, 1);
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [tempView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tempView.mas_centerX);
        make.centerY.equalTo(tempView.mas_centerY);
    }];
    _searchTextField.leftView = tempView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    
    CGRect titleStringRect = [_storeModel.shop_title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.shopTitleLabel.text = _storeModel.shop_title;
    if (titleStringRect.size.width > 70) {
        [self.shopTitleLabel removeFromSuperview];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = self.shopTitleLabel.textColor;
        titleLabel.text = _storeModel.shop_title;
        [self.topView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.top.equalTo(_shopLogoImageView.mas_bottom).offset(5);
        }];
    }
    
    
    [self.shopLogoImageView setImageWithURL:[NSURL URLWithString:_storeModel.shoplogo] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
    self.minDistributionLabel.text = [NSString stringWithFormat:@"%@元起送",_storeModel.delivery_amount ? _storeModel.delivery_amount : @"0"];
    self.distributionMoneyLabel.text = [NSString stringWithFormat:@"配送费：%@元",_storeModel.freight ? _storeModel.freight : @"0"];
    
    
    
    NSString *str = (_storeModel.distance && ![_storeModel.distance isEqualToString:@""] )? _storeModel.distance : @"定位失败";
    
    NSMutableAttributedString *leftString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/",str] attributes:@{NSFontAttributeName:_timeLabel.font}];
    NSString *string = [NSString stringWithFormat:@"%@分钟",(_storeModel.expect_time && ![_storeModel.expect_time isEqualToString:@""]) ? _storeModel.expect_time : @"0"];
    NSMutableAttributedString *rightString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:_timeLabel.font,NSForegroundColorAttributeName:[UIColor redColor]}];
    [leftString appendAttributedString:rightString];
    
    [self.timeLabel setAttributedText:leftString];
    
}


- (void)getDataWithKeyWord:(NSString *)keyWord page:(NSString *)page{
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    NSDictionary *params = @{@"shop_id":_storeModel.shop_id,@"is_onsale":@"1",@"is_check":@"1",@"type":@"goods",@"keywords":keyWord?keyWord:@"",@"page":page?page:@"1"};
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/GoodsList") parameters:@{@"token":[params paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
        
        
        if (responseObject && ([responseObject[@"status"] isEqualToString:@"0"] || [responseObject[@"status"] isEqualToString:@"1"])) {
            NSMutableArray *tempArray = [GSStoreGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [weakSelf.dataSourceArray addObjectsFromArray:tempArray];
            
            if (!_collectionFlowView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view addSubview:weakSelf.collectionFlowView];
                });
                
            }
            
            if ([responseObject[@"result"] count] < 10) {
                
                [_collectionFlowView.mj_footer endRefreshingWithNoMoreData];
                if (_dataSourceArray.count == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有搜索到您想要的商品!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } else {
                [_collectionFlowView.mj_footer endRefreshing];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [weakSelf.collectionFlowView reloadData];
                [_collectionFlowView.mj_header endRefreshing];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
               
                [weakSelf.collectionFlowView reloadData];
                [_collectionFlowView.mj_header endRefreshing];
            });
        }
        
    }];
}

- (void)getData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        dispatch_group_t downloadGroup = dispatch_group_create(); // 2
        
        if (!_storeModel.shop_phone || [_storeModel.shop_phone isEqualToString:@""]) {
            dispatch_group_enter(downloadGroup);
            
            NSLog(@"%@",@{@"token":[@{@"shop_id":_storeModel.shop_id} paramsDictionaryAddSaltString]});
            [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopInfo") parameters:@{@"token":[@{@"shop_id":_storeModel.shop_id} paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
                
                weakSelf.storeModel = [GSStoreListModel mj_objectWithKeyValues:responseObject[@"result"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setupData];
                });
                dispatch_group_leave(downloadGroup);
            }];
        }
        
        dispatch_group_enter(downloadGroup); // 3
        
        NSDictionary *params = @{@"shop_id":_storeModel.shop_id,@"is_onsale":@"1",@"is_check":@"1",@"type":@"goods"};
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/GoodsList") parameters:@{@"token":[params paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
            
            if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
                weakSelf.dataSourceArray = [GSStoreGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_collectionFlowView) {
                        [weakSelf.view addSubview:weakSelf.collectionFlowView];
                    }
                    if ([weakSelf.dataSourceArray count] < 10) {
                        [weakSelf.collectionFlowView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [weakSelf.collectionFlowView.mj_footer resetNoMoreData];
                    }
                    [weakSelf.collectionFlowView reloadData];
                });
                
            }
            dispatch_group_leave(downloadGroup);
        }];
        
        dispatch_group_enter(downloadGroup);
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/shop/CustomGoodsCategory") parameters:@{@"token":[@{@"shop_id":_storeModel.shop_id} paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
            
            if ([responseObject[@"status"] isEqualToString:@"0"]) {
                weakSelf.categoryArray = [GSStoreCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            }
            [weakSelf setupCategoryView];
            dispatch_group_leave(downloadGroup);
        }];
        
        
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
        dispatch_async(dispatch_get_main_queue(), ^{ // 6
//            NSLog(@"dismiss");
            
            [SVProgressHUD dismiss];
        });
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _keyword = textField.text;
    [_dataSourceArray removeAllObjects];
    [textField resignFirstResponder];
    
    [self getDataWithKeyWord:textField.text page:@"1"];
    
    return YES;
}

- (void)setupCategoryView {
    
    if (self.categoryArray.count == 0) {
        [self.view viewWithTag:5].userInteractionEnabled = NO;
        [self.view viewWithTag:5].hidden = YES;
        if (!_noCategoryLabel) {
            _noCategoryLabel = [[UILabel alloc] init];
            _noCategoryLabel.text = @"该商家暂无分类";
            _noCategoryLabel.textColor = [UIColor lightGrayColor];
            _noCategoryLabel.font = [UIFont systemFontOfSize:14];
            [self.categoryView addSubview:_noCategoryLabel];
        }
        
        
        [_noCategoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.top.bottom.mas_offset(0);
        }];
    } else {
        if (_noCategoryLabel) {
            [_noCategoryLabel removeFromSuperview];
            _noCategoryLabel = nil;
        }
        
        [self.view viewWithTag:5].userInteractionEnabled = YES;
        [self.view viewWithTag:5].hidden = NO;
        for (int i = 1; i < 5; i ++) {
            UIButton *button = [self.view viewWithTag:i];
            if (i < self.categoryArray.count + 1) {
                GSStoreCategoryModel *categoryModel = self.categoryArray[i-1];
                [button setTitle:categoryModel.category_title forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                button.hidden = NO;
            } else {
                button.userInteractionEnabled = NO;
                button.hidden = YES;
            }
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSStoreDetailCollectionFlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellidenterfiy forIndexPath:indexPath];
    if (_dataSourceArray.count > indexPath.item) {
        cell.goodsModel = _dataSourceArray[indexPath.item];
    }
    
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.cornerRadius = 5.0f;
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
     return (Width - 30)/ 2 + 70;
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GSStoreGoodsModel *model = _dataSourceArray[indexPath.item];
    GSGoodsDetailInfoViewController *showViewController = [[GSGoodsDetailInfoViewController alloc] init];
    if (_isHideTabBar) {
        self.tabBarController.tabBar.hidden = YES;
    }
    showViewController.hidesBottomBarWhenPushed = YES;
    showViewController.recommendModel = model;
    [self.navigationController pushViewController:showViewController animated:YES];
}

- (IBAction)detailButtonClick:(id)sender {
    GSBusinessDetailViewController *businessDetailViewControler = ViewController_in_Storyboard(@"Main", @"businessDetailViewController");
    businessDetailViewControler.storeModel = _storeModel;
    [self presentViewController:businessDetailViewControler animated:YES completion:nil];
}


#pragma mark - 4个分类按钮点击的方法
- (IBAction)kindBtnClick:(id)sender {

    UIButton *button = sender;
//    NSLog(@"%zi",button.tag);
    GoodsListViewController * goodsList = [[GoodsListViewController alloc] init];
    goodsList.informNum = 0;
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"listOrder"];
    goodsList.hidesBottomBarWhenPushed = YES;
    goodsList.dataArr =_categoryArray;
    goodsList.index = button.tag-1;
    [self.navigationController pushViewController:goodsList animated:YES];

}

#pragma mark - 更多按钮点击的方法
- (IBAction)moreBtnClick:(id)sender {
    
    GoodsListViewController * goodsList = [[GoodsListViewController alloc] init];
    goodsList.informNum = 0;
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"listOrder"];
    goodsList.hidesBottomBarWhenPushed = YES;
    goodsList.dataArr =_categoryArray;
    [self.navigationController pushViewController:goodsList animated:YES];

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
