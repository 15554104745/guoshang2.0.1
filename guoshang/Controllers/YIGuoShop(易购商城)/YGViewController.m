//
//  YGViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "YGViewController.h"

@interface YGViewController ()

@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AlertTool alertMesasge:@"敬请期待" confirmHandler:^(UIAlertAction *action) {

    } viewController:self];
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
