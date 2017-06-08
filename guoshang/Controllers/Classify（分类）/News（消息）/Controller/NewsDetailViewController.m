//
//  NewsDetailViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/14.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()
{
    
}
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

-(void)createUI{
    
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
