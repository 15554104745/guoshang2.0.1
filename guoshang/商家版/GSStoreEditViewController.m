//
//  GSStoreEditViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSStoreEditViewController.h"

@interface GSStoreEditViewController ()<UITextViewDelegate>

@end

@implementation GSStoreEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.text && ![self.text isEqualToString:@""]) {
        self.textView.text = self.text;
    }
    self.textView.returnKeyType = UIReturnKeyDone;
    
    if (_titleText && ![_titleText isEqualToString:@""]) {
        
        _titleLabel.text = _titleText;
    }
    if ([_titleLabel.text isEqualToString:@"起送金额"]) {
        self.textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}
- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitBtnClick:(id)sender {
    
    if (_commitBlock && ![_textView.text isEqualToString:@""] && ![_textView.text isEqualToString:_text]) {
        _commitBlock([NSString stringWithString:_textView.text]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self convertToInt:textView.text] > self.maxStringLength && textView.markedTextRange == nil) {
        
        textView.text = [self subStringWithMaxLength:self.maxStringLength string:textView.text];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSString *)subStringWithMaxLength:(NSInteger)maxLength string:(NSString *)string{
    NSInteger length = 0;
    NSInteger totalCount = 0;
    BOOL isOK = NO;
    NSString *returnString = @"";
    for (NSInteger i = 0; i < [string length]; i ++) {
        NSInteger a = [string characterAtIndex:i];
        if (totalCount < 20 && !isOK) {
            if (a > 0x4e00 && a < 0x9fff) {
                length ++;
                totalCount += 2;
            } else {
                length ++;
                totalCount ++;
            }
            if (totalCount > 20) {
                length -= 1;
                isOK = YES;
            }
        } else {
            returnString = [string substringToIndex:length];
            break;
        }
        
    }
    return returnString;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
    //NSLog(@"%@",str);
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([text isEqualToString:@""]) {
        return YES;
    } else {
        
        return ([self convertToInt:str] > _maxStringLength) ? NO : YES;
    }
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
