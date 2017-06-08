//
//  GroupInfoTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupInfoTableViewCell.h"
#import "HcdDateTimePickerView.h"
#import "UIView+UIViewController.h"
@interface GroupInfoTableViewCell () {
    HcdDateTimePickerView * dateTimePickerView;
    HcdDateTimePickerView * dateTimePickerView_end;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *groupName_textfield;
@property (weak, nonatomic) IBOutlet UIButton *startTime_btn;
@property (weak, nonatomic) IBOutlet UIButton *endTime_btn;
@property (weak, nonatomic) IBOutlet UITextField *allPerson_textfield;
@property (weak, nonatomic) IBOutlet UITextField *allGoodsNum_textfield;
@property (weak, nonatomic) IBOutlet UITextField *everoneBuyNum_textfield;
@property (strong, nonatomic)UIButton *buyNowBtn;                           //立即购买
@property (copy, nonatomic)NSString *startTimeStr;
@property (copy, nonatomic)NSString *endTimerStr;
@property (strong, nonatomic)NSMutableDictionary *dataList;
@end

@implementation GroupInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.startTime_btn.layer.cornerRadius = 5;
    self.startTime_btn.clipsToBounds = YES;
    
    self.endTime_btn.layer.cornerRadius = 5;
    self.endTime_btn.clipsToBounds = YES;
    
    _dataList = [NSMutableDictionary dictionary];
}

- (void)setModel:(GroupInfoModel *)model {
    _model = model;
    
    self.groupName_textfield.text = model.title;
    [self.endTime_btn setTitle:model.end_time forState:UIControlStateNormal];
    [self.startTime_btn setTitle:model.start_time forState:UIControlStateNormal];
    self.allPerson_textfield.text = model.max_user_amount;
    self.allGoodsNum_textfield.text = model.max_copies_amount;
    self.everoneBuyNum_textfield.text = model.each_amount;
    
    self.startTimeStr = model.start_time;
    
//    if (model) {
//        [_dataList setObject:model.end_time forKey:@"groupName"];
//        [_dataList setObject:model.max_copies_amount forKey:@"allGoodsNum"];
//        [_dataList setObject:model.max_user_amount forKey:@"allPerson"];
//        [_dataList setObject:model.each_amount forKey:@"everoneBuyNum"];
//        [_dataList setObject:model.start_time forKey:@"startTime"];
//        [_dataList setObject:model.end_time forKey:@"endTime"];
//    }

}


- (IBAction)starTimeBtnAction:(UIButton *)sender {
    
    [self textFieldResignFirstResponder];
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    __weak typeof(self) weakSelf = self;
    
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        weakSelf.startTimeStr = datetimeStr;
        [weakSelf.startTime_btn setTitle:datetimeStr forState:UIControlStateNormal];
        
        NSDate *date = [weakSelf getSurplusTimeWithLastTime:datetimeStr];
        NSString *endtime = [weakSelf stringFromDate:date];
        weakSelf.endTimerStr = endtime;
        [weakSelf.endTime_btn setTitle:endtime forState:UIControlStateNormal];
        
        if (weakSelf.buyNowBtn) {
            weakSelf.buyNowBtn.hidden = NO;
        }
    };
    
    if (dateTimePickerView) {
        _buyNowBtn = [self.superview.superview.superview viewWithTag:500];
        _buyNowBtn.hidden = YES;
        [self.superview.superview.superview addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}

- (IBAction)endTimeBtnAction:(UIButton *)sender {
    [self textFieldResignFirstResponder];
    
    dateTimePickerView_end = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    __weak typeof(self) weakSelf = self;
    dateTimePickerView_end.clickedOkBtn = ^(NSString * datetimeStr){
        
        if (weakSelf.startTimeStr.length > 0) {
            NSTimeInterval timeInterval = [weakSelf getTimeIntervalWithStartTime:weakSelf.startTimeStr withEndTime:datetimeStr];
            if (timeInterval > 24*60*60) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设置时间不得超过24小时" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
            }else if (timeInterval > 0 && timeInterval < 24*60*60){
                [weakSelf.endTime_btn setTitle:datetimeStr forState:UIControlStateNormal];
            }
            
        }else {
            [weakSelf.endTime_btn setTitle:datetimeStr forState:UIControlStateNormal];
        }
        
        if (weakSelf.buyNowBtn) {
            weakSelf.buyNowBtn.hidden = NO;
        }
    };
    
    if (dateTimePickerView_end) {
        _buyNowBtn = [self.superview.superview.superview viewWithTag:500];
        _buyNowBtn.hidden = YES;
        [self.superview.superview.superview addSubview:dateTimePickerView_end];
        [dateTimePickerView_end showHcdDateTimePicker];
    }
}

- (NSDate *)getSurplusTimeWithLastTime:(NSString *)endTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:endTime];
    NSDate *newDate = [date dateByAddingTimeInterval:24*60*60];
    return newDate;
}


- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSTimeInterval)getTimeIntervalWithStartTime:(NSString *)startTime withEndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *start_date = [dateFormatter dateFromString:startTime]; //开始时间
    NSDate *end_date = [dateFormatter dateFromString:endTime];  //结束时间
    //计算时间间隔（单位是秒）
    NSTimeInterval timeInterval = [end_date timeIntervalSinceDate:start_date];
    return timeInterval;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldResignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self textFieldResignFirstResponder];
}

- (void)textFieldResignFirstResponder {
    [self.groupName_textfield resignFirstResponder];
    [self.allGoodsNum_textfield resignFirstResponder];
    [self.allPerson_textfield resignFirstResponder];
    [self.everoneBuyNum_textfield resignFirstResponder];
    
}

- (void)passValueAction {
    
    [self textFieldResignFirstResponder];
    
    [_dataList setObject:self.allPerson_textfield.text forKey:@"allPerson"];
    
    [_dataList setObject:self.groupName_textfield.text forKey:@"groupName"];

    [_dataList setObject:self.allGoodsNum_textfield.text forKey:@"allGoodsNum"];
    
    [_dataList setObject:self.everoneBuyNum_textfield.text forKey:@"everoneBuyNum"];

    [_dataList setObject:self.startTime_btn.titleLabel.text forKey:@"startTime"];

    [_dataList setObject:self.endTime_btn.titleLabel.text forKey:@"endTime"];

    
    if (self.block && _dataList.count == 6) {
        self.block(_dataList);
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请补全数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
