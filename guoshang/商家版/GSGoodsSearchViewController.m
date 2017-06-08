//
//  GSGoodsSearchViewController.m
//  guoshang
//
//  Created by 陈赞 on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsSearchViewController.h"

@interface GSGoodsSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation GSGoodsSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor whiteColor];
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navBarView];

    UITextField * SearchTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 25, Width-100, 30)];
//    SearchTF.placeholder = @"棒球服";
    
    SearchTF.returnKeyType = UIReturnKeySearch;
    SearchTF.borderStyle = UITextBorderStyleRoundedRect;

    UIImageView *imageViewUserName=[[UIImageView alloc]initWithFrame:CGRectMake(Width-100-30, 7.5, 15, 15)];
    imageViewUserName.image=[UIImage imageNamed:@"fangdajing"];
    [SearchTF addSubview:imageViewUserName];
 //   SearchTF.rightView=imageViewUserName;
    SearchTF.delegate = self;
//    SearchTF.rightViewMode=UITextFieldViewModeUnlessEditing; //此处用来设置leftview现实时机
    SearchTF.backgroundColor  = [UIColor whiteColor];

    [navBarView addSubview:SearchTF];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    leftBtn.tag = 807;
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
  NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
        self.dataSource = [[NSMutableArray alloc]init];


        self.dataSource= [defaluts objectForKey:@"ss"];


    [self createTab];
    // Do any additional setup after loading the view.
}
-(void)createTab{

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, Height-64)  style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];


    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.dataSource[indexPath.row],@"text", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
  


}
- (void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define RecordCount 5
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //NSLog(@"%@",textField.text);
    //储存搜索记录

    NSMutableArray * searchArray = [[NSMutableArray alloc]init];
  searchArray =   [[[NSUserDefaults standardUserDefaults] objectForKey:@"ss"] mutableCopy];
    if (searchArray == nil) {
        searchArray = [[NSMutableArray alloc]init];
    } else if ([searchArray containsObject:textField.text]) {
        [searchArray removeObject:textField.text];
    } else if ([searchArray count] >= RecordCount) {
        [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
    }

      [searchArray insertObject:textField.text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"ss"];
//    if (arr.count ==0) {
//          NSMutableArray * SearchHisstory = [[NSMutableArray alloc]init];
//        [SearchHisstory addObject:textField.text];
//        [[NSUserDefaults standardUserDefaults] setObject:SearchHisstory forKey:@"ss"];
//
//    }
//    else
//    {
//        [arr addObject:textField.text];
//        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"ss"];
//    }
       NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:textField.text,@"text", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
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
