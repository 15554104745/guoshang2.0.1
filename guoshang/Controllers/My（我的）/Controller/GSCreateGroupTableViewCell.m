//
//  GSCreateGroupTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/8/4.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCreateGroupTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HaxString.h"
#import "GSGroupInfoViewController.h"
#import "UIView+UIViewController.h"
@implementation GSCreateGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGroupListModel:(GSMyGroupListModel *)groupListModel {
    _groupListModel = groupListModel;
    self.goodsImageView.layer.borderWidth = .5f;
    self.goodsImageView.layer.borderColor = [[UIColor colorWithHexString:@"e6e6e6"] CGColor];
    self.titleLabel.text = groupListModel.title;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:groupListModel.goods_data.goods_img] placeholderImage:Goods_Pleaceholder_Image];
    NSString *groupStatusStr = nil;
    //end:结束，notstart:未开始，inprogress：进行中，unaudited：待审核，pass：审核通过，notpass：审核未通过
    NSDictionary *statusDic = @{@"end":@"结算中",@"notstart":@"未开始",@"inprogress":@"进行中",@"unaudited":@"待审核",@"pass":@"审核通过",@"notpass":@"审核未通过"};
    if (groupListModel.status && ![groupListModel.status isEqualToString:@""]) {
        groupStatusStr = statusDic[groupListModel.status];
    } else {
        groupStatusStr = @"未知状态";
    }
    self.groupStatusLabel.text = groupStatusStr;
    self.priceLabel.text = groupListModel.group_price;
    self.peopleNumLabel.text = [NSString stringWithFormat:@"已有%@人参团",groupListModel.user_num];
     
}

- (IBAction)showDetailButtonClick:(id)sender {
    
    GSGroupInfoViewController *groupVc = [[GSGroupInfoViewController alloc] init];
    groupVc.tuan_id = self.groupListModel.group_id;
    [self.viewController.navigationController pushViewController:groupVc animated:YES];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
