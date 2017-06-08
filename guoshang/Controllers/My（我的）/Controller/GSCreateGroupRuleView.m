//
//  GSCreateGroupRuleView.m
//  guoshang
//
//  Created by Rechied on 16/9/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCreateGroupRuleView.h"
#import "UIColor+HaxString.h"

@implementation GSCreateGroupRuleView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        self.ruleImageView = imageView;
        __weak typeof(self) weakSelf = self;
        [self addSubview:self.ruleImageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.size.sizeOffset(CGSizeMake(30, 30));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithHexString:@"4D4D4D"];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        self.ruleLabel = label;
        [self addSubview:self.ruleLabel];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.equalTo(weakSelf.mas_width).offset(-15);
            make.height.offset(25);
        }];
    }
    return self;
}

- (void)setRuleModel:(GSGroupModelRuleModel *)ruleModel {
    _ruleModel = ruleModel;
    self.ruleLabel.text = [NSString stringWithFormat:@"%@%@",ruleModel.amount,ruleModel.price];
}

@end
