//
//  ForgetViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ForgetViewController.h"
#import "UIButton+countDown.h"
#import "FinishiViewController.h"
@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
}
-(void)click:(UIButton *)button{
    if (button.tag == 20) {
        
        int count = 0;
        
        NSString * str = [NSString stringWithString:self.numTF.text];
        for (int i = 0; i < self.numTF.text.length; i++) {
            char  chr = [str characterAtIndex:i];
            
            if (chr>= '0' && chr <= '9') {
                count++;
            }
        }
      
        
        if (self.numTF.text.length == 11 &&self.numTF.text!=nil && count == 11) {
            //发送验证码
            [button startWithTime:60 title:@"获取验证码" countDownTitle:@"秒后重新发送" color:NewRedColor countCOlor:NewRedColor];
            NSString  *encryptString;
            NSString * account = [NSString stringWithFormat:@"mobile=%@",self.numTF.text];
            encryptString = [account encryptStringWithKey:KEY];

            
            [HttpTool POST:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=resendcode" parameters:@{@"token":encryptString} success:^(id responseObject) {
                
                self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
                
                [self toPost];
                
                
            } failure:^(NSError *error) {
      
            }];
            

        }else{
            
           [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
        
        }
        
        
    }else{
       
        if ([self.checkTF.text isEqualToString:self.checkStr]) {
            FinishiViewController * fvc = [[FinishiViewController alloc]init];
            
            fvc.accountStr =self.numTF.text;
            fvc.isForget = YES;
            [self.navigationController pushViewController:fvc animated:YES];
        }else{
            [AlertTool alertMesasge:@"验证码错误，请重新输入" confirmHandler:nil viewController:self];
       
        }
        
    }
}

-(void)toPost{
    NSLog(@"%@",self.dic);
    NSString * str = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"status"]];
    
    if ([str isEqualToString:@"0"]) {
       self.checkStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"result"]];
 
    }else if ([str isEqualToString:@"2"]){

         [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:self];
        
    }else if ([str isEqualToString:@"3"]){
        
        [AlertTool alertMesasge:@"短信发送失败" confirmHandler:nil viewController:self];
        
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
