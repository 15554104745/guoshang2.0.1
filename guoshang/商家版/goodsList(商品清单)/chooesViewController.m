//
//  chooesViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "chooesViewController.h"
#import "CzDetailCollectionViewCell.h"
#import "SVProgressHUD.h"
@interface chooesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
     UICollectionView * _recommedCollection;
     int  _page;
}
@end

@implementation chooesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [SVProgressHUD showWithStatus:@"请求数据中"];
//    self.view.backgroundColor = [UIColor redColor];

    self.getUrl = URLDependByBaseURL(@"/Api/Shop/GoodsList");


        [self getdata];


    [self creatRefresh];
    // Do any additional setup after loading the view.
    
}
-(void)search:(NSString*)keyword
{
    _dataArray = [NSMutableArray array];
    NSString *  en = [[NSString stringWithFormat:@"shop_id=%@,is_onsale=1,type=goods,is_check=1,page=%d,page_size=10,shop_cat_id=%@,keywords=%@",self.shopid,_page,self.classid,keyword] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:self.getUrl parameters:@{@"token":en} success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            NSArray * rootArray = responseObject[@"result"];
            for (NSDictionary * dic  in rootArray) {

                HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
            }


            [_recommedCollection reloadData];
        }
        [SVProgressHUD dismiss];
        [weakSelf createUI];
        [_recommedCollection.footer endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_recommedCollection.footer endRefreshing];
    }];

}
-(void)createUI{
    UICollectionViewFlowLayout * fowLayout = [[UICollectionViewFlowLayout alloc] init];
    fowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _recommedCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,Width,Height) collectionViewLayout:fowLayout];
    _recommedCollection.backgroundColor = MyColor;
    _recommedCollection.delegate = self;
    _recommedCollection.dataSource = self;
    [_recommedCollection registerClass:[CzDetailCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCell"];
    //
    [self.view addSubview:_recommedCollection];
    
}
-(void)getdata
{
    _dataArray = [NSMutableArray array];
    NSMutableArray * array = [NSMutableArray array];

    NSString *  en = [[NSString stringWithFormat:@"shop_id=%@,is_onsale=1,type=goods,is_check=1,page=%d,page_size=10,shop_cat_id=%@",self.shopid,_page,self.classid] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:self.getUrl parameters:@{@"token":en} success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            NSArray * rootArray = responseObject[@"result"];
            for (NSDictionary * dic  in rootArray) {

                HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                [array addObject:model];
            }
            _dataArray = array;

            [_recommedCollection reloadData];
        }
        [SVProgressHUD dismiss];
            [weakSelf createUI];
        [_recommedCollection.footer endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_recommedCollection.footer endRefreshing];
    }];

}
-(void)Search
{
        _dataArray = [NSMutableArray array];
            NSString *  en = [[NSString stringWithFormat:@"shop_id=%@,is_onsale=1,type=goods,is_check=1,page=%d,page_size=10,shop_cat_id=%@,keywords=%@",self.shopid,_page,self.classid,self.keyWord] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:self.getUrl parameters:@{@"token":en} success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            NSArray * rootArray = responseObject[@"result"];
            for (NSDictionary * dic  in rootArray) {

                HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
            }


            [_recommedCollection reloadData];
        }
        [SVProgressHUD dismiss];
            [weakSelf createUI];
        [_recommedCollection.footer endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_recommedCollection.footer endRefreshing];
    }];

   }
//-(NSMutableArray *)dataArray{
//
//    if (_dataArray == nil) {
//          }
//    
//    return _dataArray;
//}
-(void)JIAZAI
{
    NSString *  en = [[NSString stringWithFormat:@"shop_id=%@,is_onsale=1,type=goods,is_check=1,page=%d,page_size=10,shop_cat_id=%@",self.shopid,_page,self.classid] encryptStringWithKey:KEY];

    [HttpTool POST:self.getUrl parameters:@{@"token":en} success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            NSArray * rootArray = responseObject[@"result"];
            for (NSDictionary * dic  in rootArray) {

                HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
            }


            [_recommedCollection reloadData];
        }
        [SVProgressHUD dismiss];
        [_recommedCollection.footer endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_recommedCollection.footer endRefreshing];
    }];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//告诉每个组有多少个 item（块）
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CzDetailCollectionViewCell * home = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    home.type = @"1";
    HomeModel * model = _dataArray[indexPath.row];
    home.dataModel = model;
    return home;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    CGFloat  itemHieght = (self.view.frame.size.width - 30)/3.0;
    
    return CGSizeMake(itemHieght, itemHieght  +  95.0);
    
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)creatRefresh{
    
    // 下拉刷新
//    _recommedCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 刷新数据的接口
//        [self pullRefresh];
//    }];
//    [_recommedCollection.header endRefreshing];

    // 上拉加载
    _recommedCollection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self pushRefresh];
    }];
    [_recommedCollection.footer endRefreshing];
    
    
}


-(void)pullRefresh{
    _page = 1;
    
    [self.dataArray removeAllObjects];
    
    
    [self dataArray];
    
    
    
}
-(void)pushRefresh{
    _page++;
    
    [self JIAZAI];
    
}
//设置偏移


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
