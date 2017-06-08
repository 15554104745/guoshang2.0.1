//
//  GSCreateGroupLeftTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCreateGroupLeftTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GSGroupModelRuleModel.h"
#import "GSCreateGroupRuleView.h"

@implementation GSCreateGroupLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGroupModel:(GSGroupWillCreateModel *)groupModel {
    _groupModel = groupModel;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.goods_thumb] placeholderImage:Goods_Pleaceholder_Image];
    self.groupTitleLabel.text = groupModel.title;
    self.goodsNameLabel.text = groupModel.goods_name;
    self.groupPriceLabel.text = [NSString stringWithFormat:@"%@元",groupModel.shop_price];
    self.groupPeopleNumberLabel.text = [NSString stringWithFormat:@"%@人团",groupModel.max_user_amount];
    self.groupEffectivenessLabel.text = [NSString stringWithFormat:@"开团时效%@小时之内",groupModel.valid];
    
    [[self.rulesView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    __block UIView *lastContentView = nil;
    __block UIView *contentView = nil;
    __block GSCreateGroupRuleView * lastRuleView = nil;
    __weak typeof(self) weakSelf = self;
    
    if (groupModel.rule.count % 4 != 0) {
        self.rulesViewHeight.constant = ((groupModel.rule.count / 4) + 1) * 70;
    } else {
        self.rulesViewHeight.constant = groupModel.rule.count / 4 * 70;
    }
    
    [groupModel.rule enumerateObjectsUsingBlock:^(GSGroupModelRuleModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx%4 == 0) {
            if (idx != 0) {
                lastContentView = contentView;
            }
            
            lastRuleView = nil;
            
            contentView = [[UIView alloc] init];
            [weakSelf.rulesView addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (idx != 0 && lastContentView) {
                    make.top.equalTo(lastContentView.mas_bottom).offset(0);
                } else {
                    make.top.offset(0);
                }
                make.left.right.mas_offset(0);
                make.height.offset(70.0f);
            }];
        }
        
        lastRuleView = [weakSelf createRuleViewWithIndex:idx ruleModel:obj contentView:contentView lastRuleView:lastRuleView];
        
    }];
    [self layoutSubviews];
    
}

- (GSCreateGroupRuleView *)createRuleViewWithIndex:(NSInteger)idx ruleModel:(GSGroupModelRuleModel *)ruleModel contentView:(UIView *)contentView lastRuleView:(GSCreateGroupRuleView *)lastRuleView {
    GSCreateGroupRuleView *ruleView = [[GSCreateGroupRuleView alloc] init];
    [contentView addSubview:ruleView];
    ruleView.ruleImageView.image = [UIImage imageNamed:[self getImageWithIndex:idx]];
    ruleView.ruleModel = ruleModel;
    
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.width.offset(Width/4.0f);
        if (lastRuleView) {
            make.left.equalTo(lastRuleView.mas_right).offset(0);
        } else {
            make.left.offset(0);
        }
    }];
    return ruleView;
}


- (NSString *)getImageWithIndex:(NSInteger)idx {
    
    NSString *ruleImageString = nil;
    if (idx == 0) {
        ruleImageString = @"icon_group_01";
    } else if (idx == 1) {
        ruleImageString = @"icon_group_02";
    } else if (idx == self.groupModel.rule.count - 1 && idx != 2) {
        ruleImageString = @"icon_group_04";
    } else {
        ruleImageString = @"icon_group_03";
    }
    return [[NSString alloc] initWithString:ruleImageString];
}

- (IBAction)createGroupButtonClick:(id)sender {
    if (self.createBlock) {
        _createBlock(_groupModel.ID);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
