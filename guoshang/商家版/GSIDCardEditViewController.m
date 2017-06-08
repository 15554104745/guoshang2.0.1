//
//  GSIDCardEditViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSIDCardEditViewController.h"
#import "NSString+MobilePhone.h"

@interface GSIDCardEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;

@property (weak, nonatomic) IBOutlet UITextField *idNumberTf;

@end

@implementation GSIDCardEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSInteger length = 0;
    if (textField.tag == 20) {
        length = 10;
    } else {
        length = 18;
    }
    
    return [self convertToInt:str] > length ? NO : YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 20) {
        [self.idNumberTf becomeFirstResponder];
    }
    return YES;
}

- (NSInteger)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commitBtnClick:(id)sender {
    
    NSString *commitName = nil;
    NSString *commitNumber = nil;
    if (_nameTf.text && ![_nameTf.text isEqualToString:@""]) {
        if (![_nameTf.text isEqualToString:_name]) {
            commitName = _nameTf.text;
        }
    } else {
        [self alertWithMessage:@"您还没有输入姓名!"];
        return;
    }
    
    if (_idNumberTf.text && ![_idNumberTf.text isEqualToString:@""]) {
        if (![_idNumberTf.text isEqualToString:_idNumber]) {
            if (![_idNumberTf.text isCorrect]) {
                [self alertWithMessage:@"请输入正确的身份证号码!"];
                return;
            }
            commitNumber = _idNumberTf.text;
        }
    } else {
        [self alertWithMessage:@"您还没有输入身份证号码!"];
        return;
    }
    
    if (_commitBlock) {
        _commitBlock(commitName,commitNumber);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertWithMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
