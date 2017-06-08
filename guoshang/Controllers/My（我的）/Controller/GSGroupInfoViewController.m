//
//  GSGroupInfoViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupInfoViewController.h"
#import "GSCollectionHeaderView.h"
#import "GSGroupInfoViewCell.h"

@interface GSGroupInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) GSGroupInfoModel *groupModel;
@property (nonatomic,strong) UIView *customNavigitonBar;
@end

@implementation GSGroupInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购详情";
    [self.view addSubview:self.customNavigitonBar];
    [self.view addSubview:self.collectionView];
    
    [self defualtSetting];
    [self loadData];
    [self creatRefresh];
    
      }


//    navigation
-(UIView *)customNavigitonBar{
    if (!_customNavigitonBar) {
        _customNavigitonBar = [[UIView alloc] init];
        _customNavigitonBar.frame = CGRectMake(0, 0, Width, 64);
        _customNavigitonBar.backgroundColor =NewRedColor;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 48, 48);
        
        [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
        
        [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
        [_customNavigitonBar addSubview:backBtn];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        CGFloat titleX =CGRectGetMaxX(backBtn.frame);
        CGFloat titleY= 20;
        CGFloat titleW= Width-backBtn.frame.size.width*2;
        CGFloat titleH = 44;
        titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"团购详情";
        [_customNavigitonBar addSubview:titleLabel];
    }
    return _customNavigitonBar;
}

-(void)defualtSetting{
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GSGroupInfoViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
    [self.collectionView registerClass:[GSCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
  
}
-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = CGSizeMake(40, 40);
        flowlayout.minimumInteritemSpacing =5;
        flowlayout.minimumLineSpacing = 10;
        flowlayout.headerReferenceSize = CGSizeMake(Width, 120);
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat collectionY =CGRectGetMaxY(self.customNavigitonBar.frame);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,collectionY, Width, Height-collectionY) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma    mark ======刷新
-(void)creatRefresh{
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self pullRefresh];
    }];
    [self.collectionView.mj_header endRefreshing];
    
}

-(void)pullRefresh{
    
    //    [self.dataArray removeAllObjects];
        [self loadData];
}

//加载数据
-(void)loadData{
    
    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"tuan_id=%@",self.tuan_id];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Groupon/groupDetail") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
//        NSLog(@"===============%@",responseObject);
        if([responseObject[@"status"] isEqualToString:@"1"]){
            
            GSGroupInfoModel *infoModel =[GSGroupInfoModel mj_objectWithKeyValues:responseObject[@"result"] context:nil];
            weakSelf.groupModel = infoModel;
            
        } else {
            
            [AlertTool alertMesasge:@"团购信息不存在" confirmHandler:nil viewController:weakSelf];
            
  
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
//        NSLog(@"----------%@",error);
    }];
    
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *group_userArray = self.groupModel.group_user_list;
    return [self.groupModel.user_num integerValue];
    
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GSGroupInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GSGroupInfoViewCell" owner:nil options:nil] lastObject];
        }
    cell.grouper = indexPath.row==0?YES:NO;
    NSArray *array= self.groupModel.group_user_list;
    if (indexPath.row>=array.count) {
        return cell;
    }
    cell.model =array[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
   
    
    if (kind == UICollectionElementKindSectionHeader){
        
        GSCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.model = self.groupModel;
        return headerView;
	} else {
		return nil;
	}
	
}




@end
