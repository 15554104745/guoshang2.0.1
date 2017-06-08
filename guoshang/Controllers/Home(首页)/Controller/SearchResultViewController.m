//
//  SearchResultViewController.m
//  guoshang
//
//  Created by 张涛 on 16/4/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.view.backgroundColor = MyColor;
    self.tableView.frame = CGRectMake(0, 30, Width, Height-80);
    self.collectionView.frame = CGRectMake(0, 30, Width, Height-80);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    self.siftButton.hidden = YES;
//    self.url = URLDependByBaseURL(@"?m=Api&c=Category&a=category");
//    self.url = self.urlStr;
    if (!self.urlStr) {
        
    }
    self.keywords = self.words;
//    self.parameters = self.params;
    
    
    [self allDataInit];
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
    
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
