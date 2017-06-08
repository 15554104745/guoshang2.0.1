//
//  BuyCountView.m
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import "BuyCountView.h"

@interface BuyCountView() <UITextFieldDelegate>


@end

@implementation BuyCountView

- (instancetype)initWithFrame:(CGRect)frame {
  
    if (self = [super initWithFrame:frame]) {
        
        [self crateSubView];
    }
    return self;
}

//创建 加减功能 视图
- (void)crateSubView {

    _lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    _lb.text = @"购买数量";
    _lb.textColor = [UIColor colorWithHexString:@"242424"];
    _lb.font = [UIFont systemFontOfSize:14];
    [self addSubview:_lb];
    
    _bt_add= [UIButton buttonWithType:UIButtonTypeCustom];
    _bt_add.frame = CGRectMake(self.frame.size.width-10-40, 10,40, 30);
    [_bt_add setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [_bt_add setTitleColor:[UIColor colorWithHexString:@"242424"] forState:0];
    _bt_add.titleLabel.font = [UIFont systemFontOfSize:20];
    [_bt_add setTitle:@"+" forState:0];
    [_bt_add addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bt_add];
    
    _tf_count = [[UITextField alloc] initWithFrame:CGRectMake(_bt_add.frame.origin.x -45, 10, 40, 30)];
    _tf_count.delegate = self;
    _tf_count.keyboardType = UIKeyboardTypeNumberPad;
    _tf_count.text = @"1";
    _tf_count.textAlignment = NSTextAlignmentCenter;
    _tf_count.font = [UIFont systemFontOfSize:15];
    _tf_count.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tf_count.returnKeyType = UIReturnKeyDone;
    //_tf_count.userInteractionEnabled = NO;
    [self addSubview:_tf_count];
    
    _bt_reduce= [UIButton buttonWithType:UIButtonTypeCustom];
    _bt_reduce.frame = CGRectMake(_tf_count.frame.origin.x -45, 10, 40, 30);
    [_bt_reduce setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [_bt_reduce setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:0];
    _bt_reduce.titleLabel.font = [UIFont systemFontOfSize:20];
    [_bt_reduce setTitle:@"-" forState:0];
    [_bt_reduce addTarget:self action:@selector(reduceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bt_reduce];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldsDidChange:) name:UITextFieldTextDidChangeNotification object:_tf_count];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];

    
}

- (void)textfieldsDidChange:(NSNotification *)notif {
    if ([_tf_count.text integerValue] > 200) {
        _tf_count.text = @"200";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"单次购买数量不得超过200!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    if (![_tf_count.text isEqualToString:@""]) {
        if ([_tf_count.text integerValue] == 0) {
            _tf_count.text = @"1";
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"单次购买数量不得小于1!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([_tf_count.text isEqualToString:@""] || [_tf_count.text integerValue] == 1) {
        _tf_count.text = @"1";
        [self.bt_reduce setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:UIControlStateNormal];
        [self.bt_add setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
    } else if ([_tf_count.text integerValue] == 200) {
        [self.bt_add setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:UIControlStateNormal];
        [self.bt_reduce setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
    } else {
        [self.bt_add setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
        [self.bt_reduce setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
    }
}


- (void)addButtonAction {
    if ([self.tf_count.text integerValue] < 200) {
        if ([self.tf_count.text integerValue ]== 199) {
            [self.bt_add setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:UIControlStateNormal];
        }
        if ([self.tf_count.text integerValue] == 1) {
            [self.bt_reduce setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
        }
        
        self.tf_count.text = [NSString stringWithFormat:@"%zi",[self.tf_count.text integerValue] + 1];
        
    }
}

- (void)reduceButtonAction {
    if ([self.tf_count.text integerValue] != 1) {
        self.tf_count.text = [NSString stringWithFormat:@"%zi",[self.tf_count.text integerValue] - 1];
        
        if ([self.tf_count.text integerValue ]== 199) {
            [self.bt_add setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
        }
        if ([self.tf_count.text integerValue] == 1) {
            [self.bt_reduce setTitleColor:[UIColor colorWithHexString:@"81838e"] forState:UIControlStateNormal];
        }
    }
}



@end
