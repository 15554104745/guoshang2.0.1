//
//  GSBusinessClassifyViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessClassifyViewController.h"
#import "MultilevelMenu.h"
#import "GoodsViewController.h"
#import "ClassifyModel.h"
#import "GSGoodsDetailViewController.h"
#import "SVProgressHUD.h"
@interface GSBusinessClassifyViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,
UICollectionViewDataSource>
{
    NSMutableArray * dataArray; //一级界面数组
    NSMutableArray * secArray;  //二级界面数组
    NSMutableArray * thiArray;  //三级界面数组
    NSMutableString * goods_id; // 分类Id二级界面数据id拼接
    NSMutableString * goods_thumb; //分类广告图
    NSInteger _selectIndex; //选择
    BOOL _isScrollDown; 
}

@end

@implementation GSBusinessClassifyViewController
{
    MultilevelMenu * mView;
    NSInteger _index;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.navigationController.navigationBar.barTintColor  = GS_Business_NavBarColor;

    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray = [[NSMutableArray alloc]init];
    
    secArray = [[NSMutableArray alloc]init];
    
    thiArray = [[NSMutableArray alloc]init];
    _index = 0;
    [self RequestData];
}

-(void)createUI{

    // 构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<dataArray.count; i++) {
        //一级菜单
        rightMenu * menu=[[rightMenu alloc] init];
        menu.menuName=[dataArray[i] name];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j < secArray.count; j++) {
            rightMenu * meun1=[[rightMenu alloc] init];
            meun1.menuName=[secArray[j] name];

            [sub addObject:meun1];

            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            ClassifyModel * model = secArray[j];

            NSInteger count = model.cat_id.count;
            for ( int k=0; k < count; k++) {
                rightMenu * meun2 = [[rightMenu alloc] init];
                meun2.menuName = model.cat_id[k][@"name"];

                [zList addObject:meun2];
            }
            meun1.nextArray=zList;
        }
        menu.nextArray=sub;
        [lis addObject:menu];
    }
    //实例化MultilevelMenu
    mView=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, Width, Height-49-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMenu* info) {
        ClassifyModel * model = secArray[left];
        NSArray * arr = model.cat_id;
        NSString * ID = [NSString stringWithString:arr[right][@"id"]];
        NSString * name = [NSString stringWithString:arr[right][@"name"]];

        GSGoodsDetailViewController * gvc = [[GSGoodsDetailViewController alloc]init];
        gvc.ID = ID;
        gvc.name = name;
        gvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gvc animated:YES];

    }];
    mView.delegate = self;
    mView.selectIndex = _index;
    [mView.adButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:goods_thumb]];
    //    [mView.adButton addTarget:self action:@selector(adButtonClick) forControlEvents:UIControlEventTouchUpInside];
    mView.isRecordLastScroll=YES;
    [self.view addSubview:mView];
}

-(void)RequestData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/getCategory") parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
//       NSLog(@"%@",responseObject);
        for (NSDictionary * dic  in responseObject[@"result"]) {
            ClassifyModel * model = [[ClassifyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        if (_index == 0) {//默认页面
            goods_id = responseObject[@"result"][_index][@"goods_id"];
            goods_thumb = responseObject[@"result"][_index][@"goods_thumb"];
            for (NSDictionary * dic1 in responseObject[@"result"][_index][@"cat_id"]) {
                ClassifyModel * model = [[ClassifyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [secArray addObject:model];
            }
        }
        [weakSelf createUI];

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)sendValue:(NSInteger)index{
    _index = index;
    [secArray removeAllObjects];
    NSString * catId = [dataArray[index] ID];
    NSString * userId = [NSString stringWithFormat:@"cat_id=%@",catId];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
     [SVProgressHUD showWithStatus:@"加载中..."];
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/getChildren") parameters:@{@"token":encryptString} success:^(id responseObject) {
        [SVProgressHUD dismiss];

        if ([responseObject[@"result"] count] ==0) {

            return;
        }
        for (NSDictionary * dic in responseObject[@"result"][@"category"]) {
            ClassifyModel * model = [[ClassifyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [secArray addObject:model];
        }
        goods_id = responseObject[@"result"][@"banner"][@"goods_id"];
        goods_thumb = responseObject[@"result"][@"banner"][@"goods_thumb"];
        [mView removeFromSuperview];
        [weakSelf createUI];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

@end
