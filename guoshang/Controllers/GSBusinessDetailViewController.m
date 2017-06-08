//
//  GSBusinessDetailViewController.m
//  guoshang
//
//  Created by Rechied on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessDetailViewController.h"

@interface GSBusinessDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellCountLabel;//需添加单位@"件"

@property (weak, nonatomic) IBOutlet UILabel *minDistributionLabel;//需添加单位@"元"

@property (weak, nonatomic) IBOutlet UILabel *distributionMoneyLabel;//需添加@"配送费：元"

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation GSBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 30.0f;
    self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headerImageView.layer.borderWidth = .5f;
    [self updataData];
    NSArray *leftLabelTextTitleArray = @[@"营业时间：",@"地址：",@"电话：",@"活动："];
    NSArray *rightLabelTextTitleArray = @[_storeModel.business_time,_storeModel.shopaddress,_storeModel.shop_phone,_storeModel.latest_activity];
    __block GSBusinessDetailCustomCellView *lastView = nil;
    [leftLabelTextTitleArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GSBusinessDetailCustomCellView *customCellView = [[GSBusinessDetailCustomCellView alloc] initWithLeftLabelText:obj rightLabelText:rightLabelTextTitleArray[idx]];
        if (idx == 2) {
            [customCellView setShowRightIcon:YES];
        }
        [self.view addSubview:customCellView];
        [customCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(40);
            if (idx == 0) {
                make.top.equalTo(_topView.mas_bottom).offset(0);
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
        }];
        lastView = customCellView;
    }];
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(lastView.mas_bottom).offset(20);
        make.height.offset(60);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] init];
    [mStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"*" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor redColor]}]];
    [mStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"因部分商品促销原因，线上线下价格未同步，请以线上显示价格为准。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor lightGrayColor]}]];
    [label setAttributedText:mStr];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.centerX.equalTo(view.mas_centerX);
        make.width.equalTo(view.mas_width).offset(-40);
    }];
}

- (void)updataData {
    self.shopTitleLabel.text = _storeModel.shop_title;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:_storeModel.shoplogo] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
    self.distributionMoneyLabel.text = [NSString stringWithFormat:@"配送费：%@元",[self noNull:_storeModel.freight]];
    self.minDistributionLabel.text = [NSString stringWithFormat:@"%@元",[self noNull:_storeModel.delivery_amount]];
    self.timeLabel.text = [self noNull:_storeModel.expect_time];
    self.sellCountLabel.text = [NSString stringWithFormat:@"%@元",_storeModel.sale_num];
}

- (NSString *)noNull:(NSString *)string {
    if (!string) {
        return @"";
    } else {
        return string;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClick:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
