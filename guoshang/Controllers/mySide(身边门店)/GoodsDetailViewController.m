//
//  GoodsDetailViewController.m
//  guoshang
//
//  Created by 大菠萝 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation GoodsDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self loadData];
}

-(void)createUI
{
    self.dataArr=[NSMutableArray array];
    
    self.scrArr=[NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, Width, Height-40) style:UITableViewStyleGrouped];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsStoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodstore"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"gooddatail"];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height-40)*2)];
    _sc.delegate=self;
    [_sc addSubview:_tableView];
    [self.view addSubview:_sc];
    _sc.scrollEnabled=NO; //禁止scrollview滚动

    
    UIButton *fhBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 20, 20)];
    [self.view addSubview:fhBtn];
    fhBtn.backgroundColor=[UIColor colorWithRed:67.84/255.0 green:-128.00/255.0 blue:-72.78/255.0 alpha:0.5];
    [fhBtn addTarget:self action:@selector(clicktoFh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *gouwucheBtn=[[UIButton alloc]initWithFrame:CGRectMake(Width-30-35, 30, 20, 20)];
    [self.view addSubview:gouwucheBtn];
    gouwucheBtn.backgroundColor=[UIColor colorWithRed:67.84/255.0 green:-128.00/255.0 blue:-72.78/255.0 alpha:0.5];
    [gouwucheBtn addTarget:self action:@selector(clicktoGfc:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *liebiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(Width-30, 30, 20, 20)];
    [self.view addSubview:liebiaoBtn];
    liebiaoBtn.backgroundColor=[UIColor colorWithRed:67.84/255.0 green:-128.00/255.0 blue:-72.78/255.0 alpha:0.5];
    [fhBtn addTarget:self action:@selector(clicktoLb:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
}
//偏移量跳转
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_tableView.contentSize.height>self.view.frame.size.height) {
        
        if (_tableView.contentOffset.y>_tableView.contentSize.height-self.view.frame.size.height) {
            
            DetailsViewController *se=[[DetailsViewController alloc]init];
            [self presentViewController:se animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        if (_tableView.contentOffset.y>0) {
            
            
            DetailsViewController *se=[[DetailsViewController alloc]init];
            [self presentViewController:se animated:YES completion:^{
                
            }];
        }
        
    }
}



//点击返回
-(void)clicktoFh:(id)sender
{

}
//购物车
-(void)clicktoGfc:(id)sender
{
    
}
//列表按钮
-(void)clicktoLb:(id)sender
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        GoodsDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"gooddatail" forIndexPath:indexPath];
        
        return cell;
        
        
    }
 else
 {
     GoodsStoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"goodstore" forIndexPath:indexPath];
     
     return cell;
 }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row==0) {
        return 160.0;
    }else{
        return 300.0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 30)];
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 20)];
        la.text=@"请选择尺码，颜色分类";
        la.font=[UIFont systemFontOfSize:12];
        [view addSubview:la];
        
        
        UIButton *ba=[[UIButton alloc]initWithFrame:CGRectMake(Width-25, 5, 20, 15)];
        [view addSubview:ba];
        ba.backgroundColor=[UIColor cyanColor];
        [ba addTarget:self action:@selector(chimaFeilei:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return view;
        
    }
else
{
    UIView *vi=[[UIView alloc]init];
    
    
    return vi;
}
    
    
}

-(void)chimaFeilei:(id)sender
{


}

-(void)loadData
{
    
    [HttpTool POST:@"http://api_domain/Api/Goods/view" parameters:@{}  success:^(id responseObject) {
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
    StoreListScrollView *sc=[[StoreListScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, 200) AndPicArray:_scrArr];
    
    self.tableView.tableHeaderView=sc;
    
    
 
    

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
