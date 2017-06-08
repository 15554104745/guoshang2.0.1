//
//  ClassifyViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ClassifyViewController.h"
#import "MultilevelMenu.h"
#import "ClassifyModel.h"
#import "GoodsViewController.h"
#import "GoodsDetailViewController.h"
#import "SVProgressHUD.h"
@interface ClassifyViewController ()<MultiViewDelegate>
{
    NSMutableArray * dataArray;
    NSMutableArray * secArray;
    NSMutableArray * thiArray;
    NSInteger _index;
    MultilevelMenu * mView; //二级分类View
    NSMutableString * goods_id; //banner id
    NSMutableString * goods_thumb; // banner 图片
}


@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"分类";
    dataArray = [[NSMutableArray alloc]init];
    secArray = [[NSMutableArray alloc]init];
    thiArray = [[NSMutableArray alloc]init];
    _index = 0;
    
    [self dataInit];

}
#pragma - mark 此处需要加提示显示没有数据；暂时return掉
-(void)sendValue:(NSInteger)index{
    _index = index;
    [secArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    NSString * catId = [dataArray[index] ID];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Category&a=getCateOne") parameters:@{@"cat_id":catId} success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"result"] count] ==0) {
            return;
        }
        //分类数组中  cat_id为每个小分类的ID
        for (NSDictionary * dic in responseObject[@"result"][@"category"]) {
            ClassifyModel * model = [[ClassifyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [secArray addObject:model];
        }
        
        //banner id 和图片
        goods_id = responseObject[@"result"][@"banner"][@"goods_id"];
        goods_thumb = responseObject[@"result"][@"banner"][@"goods_thumb"];
        [mView removeFromSuperview];
        [weakSelf createUI];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

-(void)dataInit{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中..."];

    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Category&a=index") parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];

        for (NSDictionary * dic  in responseObject[@"result"]) {
            ClassifyModel * model = [[ClassifyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        if (_index == 0) {
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
    mView=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64 - 49) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMenu* info) {
        ClassifyModel * model = secArray[left];
        NSArray * arr = model.cat_id;
        NSString * ID = [NSString stringWithString:arr[right][@"id"]];
        NSString * name = [NSString stringWithString:arr[right][@"name"]];
        
        GoodsViewController * gvc = [[GoodsViewController alloc]init];
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

-(void)adButtonClick{
    GoodsDetailViewController * show = [GoodsDetailViewController createGoodsDetailView];
    show.goodsId = goods_id;
    [self.navigationController pushViewController:show animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
