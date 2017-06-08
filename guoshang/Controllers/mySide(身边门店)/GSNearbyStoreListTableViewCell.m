//
//  GSNearbyStoreListTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNearbyStoreListTableViewCell.h"
#import "RequestManager.h"
@interface GSNearbyStoreListTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *strollButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end

@implementation GSNearbyStoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.strollButton.layer.masksToBounds = YES;
    self.strollButton.layer.cornerRadius = 5.0f;
    self.shopLogoImageView.layer.masksToBounds = YES;
    self.shopLogoImageView.layer.cornerRadius = 30.0f;
    // Initialization code
}

- (void)setStoreListModel:(GSStoreListModel *)storeListModel {
    _storeListModel = storeListModel;
    
    self.collectButton.selected = [_storeListModel.is_collect isEqualToString:@"Y"];
    
    [self.shopLogoImageView setImageWithURL:[NSURL URLWithString:storeListModel.shoplogo] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
    self.shopTitleLabel.text = storeListModel.shop_title;
    self.minDistributionLabel.text = [NSString stringWithFormat:@"%@元起送",storeListModel.delivery_amount ? storeListModel.delivery_amount : @"0"];
    self.distributionMoneyLabel.text = [NSString stringWithFormat:@"配送费：%@元",storeListModel.freight ? storeListModel.freight : @"0"];
    
    NSString *str = (storeListModel.distance && ![storeListModel.distance isEqualToString:@""] )? storeListModel.distance : @"定位成功";
    
    NSMutableAttributedString *leftString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/",str] attributes:@{NSFontAttributeName:_timeLabel.font}];
    NSString *string = [NSString stringWithFormat:@"%@分钟",(storeListModel.expect_time && ![storeListModel.expect_time isEqualToString:@""]) ? storeListModel.expect_time : @"0"];
    NSMutableAttributedString *rightString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:_timeLabel.font,NSForegroundColorAttributeName:[UIColor redColor]}];
    [leftString appendAttributedString:rightString];
    
    //[[NSMutableAttributedString alloc] initWithString:<#(nonnull NSString *)#> ]
    [self.timeLabel setAttributedText:leftString];
    //self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",(storeListModel.distance && ![storeListModel.distance isEqualToString:@""] )? storeListModel.distance : @"定位失败",(storeListModel.expect_time && ![storeListModel.expect_time isEqualToString:@""]) ? storeListModel.expect_time : @"0分钟"];
    self.exerciseLabel.text = storeListModel.latest_activity;
}

- (IBAction)strollButtonClick:(id)sender {
    if (_selectStoreBlock) {
        _selectStoreBlock(_storeListModel);
    }
}

- (void)collectShop {
    
}
- (IBAction)collectButtonClick:(id)sender {
    __block UIButton *button = sender;
    if ([self isLoginSuccess]) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"user_id":UserId,@"shop_id":_storeListModel.shop_id};
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Collect/CollectShop") parameters:[dic addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
            if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                weakSelf.storeListModel.is_collect = button.isSelected ? @"N" : @"Y";
                button.selected = !button.isSelected;
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

- (BOOL)isLoginSuccess {
    if (!UserId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else {
        return YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
