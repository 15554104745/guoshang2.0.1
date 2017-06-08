//
//  PopViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "PopViewController.h"
#import "HomeViewController.h"
@interface PopViewController ()

@end

@implementation PopViewController



- (void)viewDidLoad {
    [super viewDidLoad];
  
    
 
    for (int i = 0; i < 3; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 10+i * 30, self.view.frame.size.width, 25)];
        button.backgroundColor = [UIColor grayColor];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(toPush:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
    
    
}


-(void)toPush:(UIButton *)button{
    
    if (button.tag ==100) {
//        NSLog(@"消息");
        
        [self.delegate tabbarControllerSelectIndex:3];
        
        
        
    }else if (button.tag == 101){
//        NSLog(@"分类");
        
        [self.delegate tabbarControllerSelectIndex:1];
        
        
    }else if (button.tag == 102){
//        NSLog(@"主页");
        
        [self.delegate tabbarControllerSelectIndex:0];
        
        
        
    }
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
