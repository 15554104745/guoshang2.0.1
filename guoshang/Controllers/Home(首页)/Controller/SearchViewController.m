//
//  SearchViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchViewController.h"

#import "GSNewShopBaseViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView * searchView;
    UITextField * _searchBar;
    UIButton * searchBut;
    NSString * fileName;
    UITableView * _tableView;
    NSMutableArray * dataArray;
}
@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
        searchView.hidden = NO;
    searchBut.hidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    searchView.hidden = YES;
    searchBut.hidden = YES;
    for (UITextField * textField in searchView.subviews) {
        // 回收键盘
        [textField resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MyColor;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    //将搜索历史保存到本地
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path=[paths objectAtIndex:0];
    //在path路径下创建文件
    fileName =[path stringByAppendingPathComponent:@"searchHistory.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fileName]) {
        [manager createFileAtPath:fileName contents:nil attributes:nil];
    }
    
    //读文件搜索历史
    NSMutableArray * arr = [NSMutableArray arrayWithContentsOfFile:fileName];
    dataArray = [NSMutableArray array];
    //倒序排列
    for (int i =(int)arr.count-1; i>=0; i--) {
        [dataArray addObject:arr[i]];
    }
    
    [self createUI];
}

-(void)createUI{
    searchView = [[UIView alloc]initWithFrame:CGRectMake((Width -(Width - 110)) * 0.5, 7, Width - 110, 30)];
    searchView.backgroundColor = MyColor;
    searchView.layer.cornerRadius = 6;
    [self.navigationController.navigationBar addSubview:searchView];
    
    searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBut.frame = CGRectMake(Width -48, 7, 40, 30);
    [searchBut setTitle: @"搜索" forState:UIControlStateNormal];
    [searchBut addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:searchBut];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"sousuokuang-1"]];
    [searchView addSubview:imageView];
    
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, Width - 150, 30)];
    _searchBar.placeholder = @"宝贝搜索";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = MyColor;
    _searchBar.tintColor = [UIColor grayColor];
    [searchView addSubview:_searchBar];
    if (dataArray.count) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        titleLabel.text = @"历史搜索";
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.view addSubview:titleLabel];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, Width-10, Height-30) style:UITableViewStylePlain];
    _tableView.backgroundColor = MyColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}

-(void)search{
    if (_searchBar.text.length) {
        //读文件
        NSMutableArray * readArr = [NSMutableArray arrayWithContentsOfFile:fileName];
        if (readArr.count) {
            NSArray * arr = [NSArray arrayWithArray:readArr];
            BOOL isExist = NO;
            for (NSString * str in arr) {
                if ([str isEqualToString:_searchBar.text]) {
                    isExist = YES;
                }
            }
            if (!isExist) {
                [readArr addObject:_searchBar.text];
                [readArr writeToFile:fileName atomically:YES];
            }
        }else{
            //创建一个数组，写到plist文件里
            NSMutableArray * arr = [NSMutableArray arrayWithObject:_searchBar.text];
            [arr writeToFile:fileName atomically:YES];
        }
        [self searchResultWithKeywords:_searchBar.text];
        
    }else{
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请输入搜索内容!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:NO];
        [promptAlert show];
    }
    
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)searchResultWithKeywords:(NSString *)keywords {
    GSNewShopBaseViewController *searchResult = [[GSNewShopBaseViewController alloc] init];
    searchResult.keywords = keywords;
    searchResult.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchResult animated:YES];
}

#pragma mark -tableView协议方法
// 分为多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.添加标识
    static NSString * cellId = @"cellId";
    // 2.复用池中调用
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    // 3.找不到创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    //    NSMutableArray * arr = [NSMutableArray array];
    //    for (int i =(int)dataArray.count-1; i>=0; i--) {
    //        [arr addObject:dataArray[i]];
    //    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
//每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self searchResultWithKeywords:dataArray[indexPath.row]];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Width, 90)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton * deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, Width -  40, 40)];
    deleteBtn.backgroundColor =[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [deleteBtn setTintColor:[UIColor whiteColor]];
    deleteBtn.layer.cornerRadius = 20;
    [deleteBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(removeSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteBtn];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (dataArray.count) {
        return 100;
    }
    return 0;
}

-(void)removeSearchHistory{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path=[paths objectAtIndex:0];
    //在path路径下创建文件
    fileName =[path stringByAppendingPathComponent:@"searchHistory.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:fileName error:nil];
    [dataArray removeAllObjects];
    [_tableView reloadData];
}
//键盘收回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITextField * textField in searchView.subviews) {
        // 回收键盘
        [textField resignFirstResponder];
    }
}


//结束响应时进行数据请求
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length) {
//        //读文件
//        NSMutableArray * readArr = [NSMutableArray arrayWithContentsOfFile:fileName];
//        if (readArr.count) {
//            NSArray * arr = [NSArray arrayWithArray:readArr];
//            BOOL isExist = NO;
//            for (NSString * str in arr) {
//                if ([str isEqualToString:textField.text]) {
//                    isExist = YES;
//                }
//            }
//            if (!isExist) {
//                [readArr addObject:textField.text];
//                [readArr writeToFile:fileName atomically:YES];
//            }
//        }else{
//            //创建一个数组，写到plist文件里
//            NSMutableArray * arr = [NSMutableArray arrayWithObject:textField.text];
//            [arr writeToFile:fileName atomically:YES];
//        }
//        SearchResultViewController * srvc = [[SearchResultViewController alloc]init];
//        srvc.urlStr = @"http://www.ibg100.com/Apiss/index.php?m=Api&c=Category&a=category";
//        srvc.words = textField.text;
//        [self.navigationController pushViewController:srvc animated:YES];
//    }else{
//        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请输入搜索内容!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                         target:self
//                                       selector:@selector(timerFireMethod:)
//                                       userInfo:promptAlert
//                                        repeats:NO];
//        [promptAlert show];
//    }
//}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
