//
//  FirstTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "TimeModel.h"

@interface FirstTableViewCell () {
    NSTimeInterval time;
}

@property (nonatomic, weak)   id           m_data;
@property (nonatomic, assign)   NSInteger section;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greateWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lowWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rulebtn_height;
@property (weak, nonatomic) IBOutlet UIView *ruleBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLab;

@end

@implementation FirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNSNotificationCenter];
    [self createRuleBtn];
}

- (void)setDataList:(NSDictionary *)dataList {
    _dataList = dataList;
    
}

- (void)createRuleBtn {
    
}

-(void)setModel:(BuyNewModel *)model {
    _model = model;
    
    self.group_name.text = model.title;
    self.group_price.text = [NSString stringWithFormat:@"￥:%@",model.group_price];
    self.group_orignPrice.text = [NSString stringWithFormat:@"原价:%@",model.market_price];
}

- (void)setGroup_rule:(NSArray *)group_rule {
    
    _group_rule = group_rule;
    
    NSInteger count = group_rule.count;
    
    int coloumn = 3;
    CGFloat margin = 5;
    CGFloat lab_h = 20;
    CGFloat lab_w = (Width - 40) / coloumn;
    
    CGFloat height =  (margin + lab_h) * ((count - 1) / 3 + 1);
    _rulebtn_height.constant = height;
    
    int currentColoumn = 0;
    int currentRow = 0;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < count; i++) {
        
        NSDictionary *dic = group_rule[i];
        NSString *str = [NSString stringWithFormat:@"%@,%@",dic[@"amount"],dic[@"price"]];
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:10];
        lab.text = str;
        lab.textColor = COLOR(76, 76, 76, 1);
        currentColoumn = i % coloumn;
        currentRow = i / coloumn;
        
        x = margin + (margin + lab_w) * currentColoumn;
        y = (margin + lab_h) * currentRow;
        
        lab.frame = CGRectMake(x, y, lab_w, lab_h);
        
        [_ruleBackView addSubview:lab];
        
        if (currentColoumn == 0) {
            lab.textAlignment = NSTextAlignmentLeft;
        }else if (currentColoumn == 1) {
            lab.textAlignment = NSTextAlignmentCenter;
        }else if (currentColoumn == 2) {
            lab.textAlignment = NSTextAlignmentRight;
        }
        
    }
    
}


- (void)loadData:(id)data index:(NSInteger)section {
    
    if ([data isMemberOfClass:[TimeModel class]]) {
        [self storeWeakValueWithData:data index:section];
        TimeModel *model = (TimeModel*)data;
        NSString *grouptime = [NSString stringWithFormat:@"%@",[model currentTimeString]];
        
        _group_time.text = grouptime;
        
        if (model.timestyle == timeStyleEndTime) {
            _titleTimeLab.text = @"剩余时间：";
        }else if (model.timestyle == timeStyleStatTime) {
            _titleTimeLab.text = @"开始时间：";
        }else if (model.timestyle == timeStyleAlreadyEnd) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"alreadTimeNotificationNameBuyNow" object:nil];
        }
        
        
        if (grouptime.length >= 10) {
            _greateWidth.priority = UILayoutPriorityDefaultHigh;
            _lowWidth.priority = UILayoutPriorityDefaultLow;
        }else {
            _greateWidth.priority = UILayoutPriorityDefaultLow;
            _lowWidth.priority = UILayoutPriorityDefaultHigh;
        }
        
        int currenttime = [model getTimeInterval];
        if (currenttime == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alreadTimeNotificationNameBuyNow" object:nil];
        }
        
    }
}

- (void)storeWeakValueWithData:(id)data index:(NSInteger )section {
    
    self.m_data         = data;
    self.section = section;
}

- (void)dealloc {
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterAction:)
                                                 name:FirstTableViewCellNotifaction
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FirstTableViewCellNotifaction object:nil];
}

- (void)notificationCenterAction:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data index:self.section];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
