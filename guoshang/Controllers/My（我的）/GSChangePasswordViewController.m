//
//  GSChangePasswordViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChangePasswordViewController.h"

@interface GSChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassTf;

@property (weak, nonatomic) IBOutlet UITextField *nowPassTf;

@property (weak, nonatomic) IBOutlet UITextField *turePassTf;

@end

@implementation GSChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"enter"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isBusinessUser"];
     
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    */
    
}

- (IBAction)commitButton:(id)sender {
    
    
    
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
