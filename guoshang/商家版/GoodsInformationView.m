//
//  GoodsInformationView.m
//  guoshang
//
//  Created by JinLian on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsInformationView.h"

@implementation GoodsInformationView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    _dataList = [NSMutableDictionary dictionary];
    
    self.goods_name.delegate = self;
    self.goods_subNme.delegate = self;
    self.inventory.delegate = self;
    self.sellingPrice.delegate = self;
    self.marketPrice.delegate = self;
    
    //默认添加库存
    [_dataList setObject:@"1" forKey:@"is_add_stock"];

}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        [self alertView];
    }
    if (textField == self.goods_name) {
        [_dataList setObject:self.goods_name.text forKey:@"goods_name"];
    }else if (textField == self.goods_subNme) {
        
        [_dataList setObject:self.goods_subNme.text forKey:@"goods_short_name"];
        
    }else if (textField == self.inventory){
        
        [_dataList setObject:self.inventory.text forKey:@"goods_stock"];
    }else if (textField == self.sellingPrice) {
        
        [_dataList setObject:self.sellingPrice.text forKey:@"shop_price"];
    }else if (textField == self.marketPrice) {
        
        [_dataList setObject:self.marketPrice.text forKey:@"market_price"];
    }
    
}
- (IBAction)btn_AddToStock:(UIButton *)sender {
   
    NSString *str = @"1";
    if (!sender.selected) {
        str = @"0";
    }
    [_dataList setObject:str forKey:@"is_add_stock"];
    sender.selected = !sender.selected;
}

- (void)returnVale:(passBlock)block {
    _block = block;
}


- (void)alertView {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据不能为空" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:alert];
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)textFieldResignFirstResponder {
    
    [self.goods_name resignFirstResponder];
    [self.goods_subNme resignFirstResponder];
    [self.inventory resignFirstResponder];
    [self.sellingPrice resignFirstResponder];
    [self.marketPrice resignFirstResponder];
}

//返回数据
- (void)passValue {
    [self textFieldResignFirstResponder];
    
    if (self.goods_name.text.length != 0 && self.goods_subNme.text.length != 0 && self.inventory.text.length != 0 && self.sellingPrice.text.length != 0 && self.marketPrice.text.length != 0) {
        _block(_dataList);
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self textFieldResignFirstResponder];
}


@end


@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end
